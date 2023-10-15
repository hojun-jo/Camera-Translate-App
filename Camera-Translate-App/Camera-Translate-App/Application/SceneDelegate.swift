//
//  SceneDelegate.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let translationModel = TranslationModel()
        let translationViewModel = TranslationViewModel(translationModel: translationModel)
        let translationViewController = TranslationViewController(viewModel: translationViewModel)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = translationViewController
        window?.makeKeyAndVisible()
    }
}
