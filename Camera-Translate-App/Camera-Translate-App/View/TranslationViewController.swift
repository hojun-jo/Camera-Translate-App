//
//  TranslationViewController.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/09.
//

import UIKit
import VisionKit
import Combine

final class TranslationViewController: UIViewController {
    private let translationView = TranslationView()
    
    private let dataScanner = DataScannerViewController(
        recognizedDataTypes: [.text()],
        qualityLevel: .accurate,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: false,
        isPinchToZoomEnabled: true,
        isGuidanceEnabled: false,
        isHighlightingEnabled: true)
    
    private let translatedTextLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.numberOfLines = .zero
        label.textColor = .black
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        label.font = .preferredFont(forTextStyle: .title3)
        label.minimumScaleFactor = 0.5
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private let viewModel: TranslationViewModel
    private var isAvailableTranslate = true
    private var fetchDelayTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: TranslationViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = translationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translationView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpDataScanner()
        startDataScanning()
        setUpBindings()
    }
    
    private func setUpDataScanner() {
        addChild(dataScanner)
        translationView.cameraView.addSubview(dataScanner.view)
        dataScanner.didMove(toParent: self)
        
        dataScanner.view.frame = translationView.cameraView.bounds
        dataScanner.delegate = self
        
        translationView.addSubview(translatedTextLabel)
    }
    
    private func startDataScanning() {
        do {
            if viewModel.scannerAvailable {
                try dataScanner.startScanning()
                startFetchDelayTimer()
            } else {
                let alert = AlertBuilder()
                    .setTitle("권한 요청")
                    .setMessage("실시간 번역을 위해 설정에서 카메라 권한을 허용해 주세요.")
                    .addAction(title: "확인", style: .default)
                    .build()
                
                present(alert, animated: true)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func startFetchDelayTimer() {
        fetchDelayTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(enableTranslate),
            userInfo: nil,
            repeats: true)
    }
    
    @objc
    private func enableTranslate() {
        isAvailableTranslate = true
    }
    
    private func setUpBindings() {
        viewModel.$translationModel
            .sink { [weak self] model in
                self?.translatedTextLabel.text = model.translatedText
            }
            .store(in: &cancellables)
        
        viewModel.$isPausedScan
            .sink { [weak self] isPaused in
                if isPaused {
                    self?.translationView.pauseImageView.image = UIImage(systemName: "play.rectangle.fill")
                } else {
                    self?.translationView.pauseImageView.image = UIImage(systemName: "pause.rectangle.fill")
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - DataScannerViewControllerDelegate

extension TranslationViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        guard isAvailableTranslate,
              let item = allItems.last
        else {
            return
        }
        
        isAvailableTranslate = false
        
        switch item {
        case .text(let text):
            let padding = translationView.topItemStackView.bounds.height
            + translationView.safeAreaInsets.top
            let topLeft =  text.bounds.topLeft
            let topRight = text.bounds.topRight
            let bottomLeft = text.bounds.bottomLeft
            
            translatedTextLabel.frame = .init(
                origin: .init(x: topLeft.x - 10, y: padding + topLeft.y - 10),
                size: .init(
                    width: topRight.x - topLeft.x + 20,
                    height: bottomLeft.y - topLeft.y + 20))
            
            viewModel.scanData.send(text.transcript)
        case .barcode(_):
            break
        @unknown default:
            print(item)
        }
    }
}

// MARK: - TranslationViewDelegate

extension TranslationViewController: TranslationViewDelegate {
    func didTapLanguageButton(type: LanguageType, language: SupportedLanguage) {
        viewModel.languageButtonTapped.send((type, language))
    }
    
    func didTapLanguageSwapButton() {
        viewModel.languageSwapButtonTapped.send()
    }
    
    func didTapPauseImageView() {
        viewModel.pauseImageViewTapped.send()
    }
}
