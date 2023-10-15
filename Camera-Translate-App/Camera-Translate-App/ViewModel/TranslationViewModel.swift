//
//  TranslationViewModel.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/15.
//

import VisionKit
import Combine

@MainActor
final class TranslationViewModel {
    @Published private var translationModel: TranslationModel
    
    var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }
    
    init(translationModel: TranslationModel) {
        self.translationModel = translationModel
    }
}
