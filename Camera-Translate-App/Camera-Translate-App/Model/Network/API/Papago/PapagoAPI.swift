//
//  PapagoAPI.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/14.
//

import Foundation

struct PapagoAPI: APIType {
    var baseURL = "https://openapi.naver.com/v1/papago/n2mt"
    var httpMethod = HTTPMethod.post
    var headers: [String : String]? = [
        "Content-Type" : "application/x-www-form-urlencoded; charset=UTF-8",
        "X-Naver-Client-Id" : Bundle.papagoClientID,
        "X-Naver-Client-Secret" : Bundle.papagoClientSecret
    ]
    var queryItems: [URLQueryItem]?
    
    init(source: SupportedLanguage, target: SupportedLanguage, text: String) {
        queryItems = [
            URLQueryItem(name: "source", value: source.identifier),
            URLQueryItem(name: "target", value: target.identifier),
            URLQueryItem(name: "text", value: text)
        ]
    }
}
