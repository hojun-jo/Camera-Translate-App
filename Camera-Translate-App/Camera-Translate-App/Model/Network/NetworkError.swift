//
//  NetworkError.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/14.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case failResponse(statusCode: Int)
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .failResponse(let statusCode):
            return "Status Code : \(statusCode)"
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        }
    }
}
