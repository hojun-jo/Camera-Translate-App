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
        self.addChild(dataScanner)
        self.translationView.cameraView.addSubview(dataScanner.view)
        dataScanner.didMove(toParent: self)
        
        dataScanner.view.frame = self.translationView.cameraView.bounds
        dataScanner.delegate = self
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
            print(text)
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
