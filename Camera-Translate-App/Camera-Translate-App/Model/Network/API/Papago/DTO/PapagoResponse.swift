//
//  PapagoResponse.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/13.
//

struct PapagoResponse: Decodable {
    let message: PapagoMessage
}

struct PapagoMessage: Decodable {
    let result: PapagoResult
}

struct PapagoResult: Decodable {
    let translatedText: String
}
