//
//  NetworkManager.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

final class NetworkMaanager {
    
    static let shared = NetworkMaanager()
    
    private init() {}
}

extension NetworkMaanager {
    
    func request<T: Codable>(absoluteURL: String, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: absoluteURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error = error {
                completion(.failure(NetworkError.customError(error: error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...300) ~= response.statusCode else {
                let statusCode = (response as! HTTPURLResponse).statusCode
                completion(.failure(NetworkError.invalidStatusCode(statusCode: statusCode)))
                return
            }
            
            
            guard let data = data else {
                completion(.failure(NetworkError.invaliData))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let dataResponse = try decoder.decode(type, from: data)
                completion(.success(dataResponse))

            } catch {
                completion(.failure(NetworkError.faildToDecode(error: error)))
            }
        }
        
        dataTask.resume()
    }
}

// MARK: - Error Handling
extension NetworkMaanager {
    
    enum NetworkError: Error {
        case invalidURL
        case customError(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invaliData
        case faildToDecode(error: Error)
    }
}

