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
        isPinchToZoomEnabled: false,
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
            } else {
                print("카메라 권한이 필요합니다")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - DataScannerViewControllerDelegate

extension TranslationViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        guard let item = allItems.last else {
            return
        }
        
        switch item {
        case .text(let text):
            let padding = translationView.topItemStackView.bounds.height
            + translationView.safeAreaInsets.top
            let topLeft =  text.bounds.topLeft
            let topRight = text.bounds.topRight
            let bottomLeft = text.bounds.bottomLeft
            
            translatedTextLabel.frame = .init(
                origin: .init(x: topLeft.x, y: padding + topLeft.y),
                size: .init(
                    width: topRight.x - topLeft.x,
                    height: bottomLeft.y - topLeft.y))
            
            translatedTextLabel.text = text.transcript
            
            translatedTextLabel.layoutIfNeeded()
        case .barcode(_):
            break
        @unknown default:
            print(item)
        }
    }
}

// MARK: - TranslationViewDelegate

extension TranslationViewController: TranslationViewDelegate {
    func didTapOriginalLanguageButton(_ language: Language) {
        print("Original Language Button Tapped / language : \(language.rawValue)")
    }
    
    func didTapSwitchLanguageButton() {
        print("Switch Button Tapped")
    }
    
    func didTapTranslateLanguageButton(_ language: Language) {
        print("Translate Language Button Tapped / language : \(language.rawValue)")
    }
    
    func didTapPauseImageView() {
        print("Pause Button Tapped")
    }
}
