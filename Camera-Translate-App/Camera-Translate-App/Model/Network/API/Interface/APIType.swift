//
//  APIType.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/14.
//

import Foundation

protocol APIType {
    var baseURL: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: [String : String]? { get }
    var queryItems: [URLQueryItem]? { get }
}
