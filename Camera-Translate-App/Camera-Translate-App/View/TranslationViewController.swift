//
//  TranslationViewController.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/09.
//

import UIKit

final class TranslationViewController: UIViewController {
    private let translationView = TranslationView()

    override func loadView() {
        view = translationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translationView.delegate = self
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
