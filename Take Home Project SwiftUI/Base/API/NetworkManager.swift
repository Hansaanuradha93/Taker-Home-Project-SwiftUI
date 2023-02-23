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

// MARK: - Async API Calls
extension NetworkManager {
    
    /// Request api with async function to return data
    /// - Parameters:
    ///   - endPoint: Endpoint url
    ///   - type: Response decoding type
    /// - Returns: Decoded Type
    func request<T: Codable>(endPoint: EndPoint,
                             type: T.Type) async throws -> T {
        
        guard let url = endPoint.url else {
            throw NetworkError.invalidURL
        }
        
        let urlRequest = buildRequest(from: url, methodType: endPoint.methodType)
        
        log(urlRequest)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dataResponse = try decoder.decode(type, from: data)
        
        return dataResponse
    }
    
    /// Request api with async function to return the result
    /// - Parameters:
    ///   - endPoint: Endpoint url
    func request(endPoint: EndPoint) async throws {
        
        guard let url = endPoint.url else {
            throw NetworkError.invalidURL
        }
        
        let urlRequest = buildRequest(from: url, methodType: endPoint.methodType)
        
        log(urlRequest)
        
        let (_, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }
    }
}

// MARK: - API Calls
extension NetworkManager {
    
    /// Request api and returns decoded data
    /// - Parameters:
    ///   - endPoint: Endpoint url
    ///   - type: Response decoding type
    ///   - completion: Returns decoded json data or error
    func request<T: Codable>(endPoint: EndPoint,
                             type: T.Type,
                             completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = endPoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let urlRequest = buildRequest(from: url, methodType: endPoint.methodType)
        
        log(urlRequest)
                
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
    ///   - completion: Returns status or error
    func request(endPoint: EndPoint,
                 completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let url = endPoint.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let urlRequest = buildRequest(from: url, methodType: endPoint.methodType)
        
        log(urlRequest)
                
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
                      methodType: EndPoint.MethodType) -> URLRequest {
        
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
            return "Something went wrong: \(error.localizedDescription)"
        case .invalidStatusCode(statusCode: let statusCode):
            return "Status code: \(statusCode) falls in to the wrong range"
        case .invalidData:
            return "Response data is invalid"
        case .faildToDecode(error: let error):
            return "Failed to decode: \(error.localizedDescription)"
        }
    }
}
