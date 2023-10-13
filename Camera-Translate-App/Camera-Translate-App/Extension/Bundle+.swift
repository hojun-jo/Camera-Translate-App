//
//  Bundle+.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/13.
//

import Foundation

extension Bundle {
    static var papagoClientID: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let plistDictionary = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        
        guard let value = plistDictionary.object(forKey: "PapagoClientID") as? String else {
            fatalError("Couldn't find key 'PapagoClientID' in 'Info.plist'.")
        }
        
        return value
    }
    
    static var papagoClientSecret: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let plistDictionary = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        
        guard let value = plistDictionary.object(forKey: "PapagoClientSecret") as? String else {
            fatalError("Couldn't find key 'PapagoClientSecret' in 'Info.plist'.")
        }
        
        return value
    }
}
