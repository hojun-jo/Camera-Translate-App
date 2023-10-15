//
//  SupportedLanguage.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/13.
//

enum SupportedLanguage: String, CaseIterable {
    case korean = "한국어"
    case english = "영어"
    
    var identifier: String {
        switch self {
        case .korean:
            return "ko"
        case .english:
            return "en"
        }
    }
}
