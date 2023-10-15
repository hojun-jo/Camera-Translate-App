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
    @Published var translationModel: TranslationModel
    let languageButtonTapped = PassthroughSubject<(LanguageType, SupportedLanguage), Never>()
    let languageSwapButtonTapped = PassthroughSubject<Void, Never>()
    let scanData = PassthroughSubject<String, Never>()
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
        
        languageSwapButtonTapped.sink { _ in
            self.translationModel.swapSourceAndTarget()
            print("Switch Button Tapped")
        }
        .store(in: &cancellables)
        
        scanData.sink { text in
            Task {
                do {
                    let papago = PapagoAPI(
                        source: self.translationModel.source,
                        target: self.translationModel.target,
                        text: text)
                    let result: PapagoResponse = try await NetworkManager.fetchData(for: papago)
                    self.translationModel.translatedText = result.message.result.translatedText
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .store(in: &cancellables)
    }
}
