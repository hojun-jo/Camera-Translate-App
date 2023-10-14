//
//  NetworkManager.swift
//  Camera-Translate-App
//
//  Created by Moon on 2023/10/13.
//

import Foundation

final class NetworkManager {
    private init() { }
    
    private static func createRequest(with api: some APIType) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: api.baseURL) else {
            throw NetworkError.invalidURL
        }
        
        urlComponents.queryItems = api.queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = api.httpMethod.rawValue
        
        api.headers?.forEach { (key, value) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    static func fetchData<T: Decodable>(for api: some APIType) async throws -> T {
        guard let request = try? createRequest(with: api) else {
            throw NetworkError.invalidURL
        }
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw NetworkError.invalidData
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.failResponse(statusCode: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
