//
//  TranslationModel.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/15.
//

struct TranslationModel {
    var source: SupportedLanguage = .english
    var target: SupportedLanguage = .korean
    var translatedText: String = ""
    
    mutating func swapSourceAndTarget() {
        let tmp = source
        source = target
        target = tmp
    }
}
