//
//  AlertBuilder.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/16.
//

import UIKit

final class AlertBuilder {
    private var title: String?
    private var message: String?
    private var actions: [UIAlertAction] = []
    private var preferredStyle: UIAlertController.Style = .alert
    
    init() { }
    
    func setTitle(_ title: String) -> AlertBuilder {
        self.title = title
        
        return self
    }
    
    func setMessage(_ message: String) -> AlertBuilder {
        self.message = message
        
        return self
    }
    
    func addAction(title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) -> AlertBuilder {
        actions.append(UIAlertAction(title: title, style: style, handler: handler))
        
        return self
    }
    
    func setPreferredStyle(_ preferredStyle: UIAlertController.Style) -> AlertBuilder {
        self.preferredStyle = preferredStyle
        
        return self
    }
    
    func build() -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        actions.forEach { action in
            alert.addAction(action)
        }
        
        return alert
    }
}
