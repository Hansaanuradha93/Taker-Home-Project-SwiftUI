//
//  NetworkManager.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
}

// MARK: - API Calls
extension NetworkManager {
    
    /// Request api and resturns decoded data
    /// - Parameters:
    ///   - endPoint: Endpoint url
    ///   - httpMethod: Http method type
    ///   - type: Response decoding type
    ///   - completion: Returns decoded json data or error
    func request<T: Codable>(endPoint: EndPoint,
                             httpMethod: HttpMethod = .GET,
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
                completion(.failure(NetworkError.invalidData))
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
    
    /// Request api and returns the result
    /// - Parameters:
    ///   - endPoint: Endpoint url
    ///   - httpMethod: Http method type
    ///   - completion: Returns status or error
    func request(endPoint: EndPoint,
                 httpMethod: HttpMethod = .GET,
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
private extension NetworkManager {
    
    /// Build a URLRequest object
    /// - Parameters:
    ///   - url: URL object
    ///   - methodType: Http method type
    /// - Returns: URLObject with http methods, and http body
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

// MARK: - HTTP Methods
extension NetworkManager {
    
    enum HttpMethod {
        case GET
        case POST(data: Data?)
        case PUT(data: Data?)
        case DELETE
    }
}

// MARK: - Error Types
extension NetworkManager {
    
    enum NetworkError: LocalizedError {
        case invalidURL
        case customError(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case faildToDecode(error: Error)
    }
}

// MARK: - Error Descriptions
extension NetworkManager.NetworkError {
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL isn't valid"
        case .customError(error: let error):
            return "Something went wronf \(error.localizedDescription)"
        case .invalidStatusCode(statusCode: let statusCode):
            return "Status code: \(statusCode) falls in to the wrong range"
        case .invalidData:
            return "Response data is invalid"
        case .faildToDecode(error: let error):
            return "Failed to decode: \(error.localizedDescription)"
        }
    }
}
