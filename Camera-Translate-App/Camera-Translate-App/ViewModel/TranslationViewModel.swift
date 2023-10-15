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
    let languageButtonTapped = PassthroughSubject<(LanguageType, SupportedLanguage), Never>()
    private var cancellables = Set<AnyCancellable>()
    
    var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }
    
    init(translationModel: TranslationModel) {
        self.translationModel = translationModel
        
        setUpBindings()
    }
    
    private func setUpBindings() {
        languageButtonTapped.sink { (type, language) in
            switch type {
            case .source:
                self.translationModel.source = language
            case .target:
                self.translationModel.target = language
            }
            print("Language Button Tapped - type: \(type), language: \(language)")
        }
        .store(in: &cancellables)
    }
}
