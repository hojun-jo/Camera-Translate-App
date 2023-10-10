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
    func didTappedOriginalLanguageButton() {
        print("Original Button Tapped")
    }
    
    func didTappedSwitchLanguageButton() {
        print("Switch Button Tapped")
    }
    
    func didTappedTranslateLanguageButton() {
        print("Translate Button Tapped")
    }
    
    func didTappedPauseImageView() {
        print("Pause Button Tapped")
    }
}
