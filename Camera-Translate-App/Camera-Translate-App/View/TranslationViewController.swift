//
//  TranslationViewController.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/09.
//

import UIKit
import VisionKit

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
    
    private var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }
    
    private var isAvailableTranslate = true
    private var fetchDelayTimer: Timer?
    
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
            if scannerAvailable {
                try dataScanner.startScanning()
                startFetchDelayTimer()
            } else {
                print("카메라 권한이 필요합니다")
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
            
            Task {
                do {
                    let papago = PapagoAPI(source: .english, target: .korean, text: text.transcript)
                    let result: PapagoResponse = try await NetworkManager.fetchData(for: papago)
                    translatedTextLabel.text = result.message.result.translatedText
                    translatedTextLabel.layoutIfNeeded()
                } catch {
                    print(error.localizedDescription)
                }
            }
        case .barcode(_):
            break
        @unknown default:
            print(item)
        }
    }
}

// MARK: - TranslationViewDelegate

extension TranslationViewController: TranslationViewDelegate {
    func didTapSourceLanguageButton(_ language: Language) {
        print("Original Language Button Tapped / language : \(language.rawValue)")
    }
    
    func didTapSwitchLanguageButton() {
        print("Switch Button Tapped")
    }
    
    func didTapTargetLanguageButton(_ language: Language) {
        print("Translate Language Button Tapped / language : \(language.rawValue)")
    }
    
    func didTapPauseImageView() {
        print("Pause Button Tapped")
    }
}
