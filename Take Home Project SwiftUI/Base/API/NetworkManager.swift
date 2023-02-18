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

// MARK: API Calls
extension NetworkMaanager {
    
    func request<T: Codable>(httpMethod: HttpMethod = .GET,
                             endPoint: EndPoint,
                             type: T.Type,
                             completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = endPoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let urlRequest = buildRequest(from: url, methodType: httpMethod)
                
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
    
    func request(httpMethod: HttpMethod = .GET,
                 endPoint: EndPoint,
                 completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let url = endPoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let urlRequest = buildRequest(from: url, methodType: httpMethod)
                
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
            
            completion(.success(()))
        }
        
        dataTask.resume()
    }
}

// MARK: - Helper Methods
private extension NetworkMaanager {
    
    func buildRequest(from url: URL,
                      methodType: HttpMethod) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        case .POST(let data):
            request.httpMethod = "POST"
            request.httpBody = data
        case .PUT(let data):
            request.httpMethod = "PUT"
            request.httpBody = data
        case .DELETE:
            request.httpMethod = "DELETE"
        }
        
        return request
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

// MARK: - HTTP Methods
extension NetworkMaanager {
    
    enum HttpMethod {
        case GET
        case POST(data: Data?)
        case PUT(data: Data?)
        case DELETE
    }
}

