//
//  EndPoint.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

// MARK: Cases
enum EndPoint {
    case users(page: Int)
    case userDetails(id: Int)
    case createUser(data: Data?)
    case updateUser(id: Int, data: Data?)
    case deleteUser(id: Int)
}

// MARK: - HTTP Methods
extension EndPoint {
    
    enum MethodType {
        case GET
        case POST(data: Data?)
        case PUT(data: Data?)
        case DELETE
    }
}

// MARK: - Scheme
extension EndPoint {
    private var scheme: String { return "https" }
}

// MARK: - Host
extension EndPoint {
    private var host: String { return "reqres.in" }
}

// MARK: - Path
extension EndPoint {
    
    private var path: String {
        switch self {
        case .users:
            return "/api/users"
        case .userDetails(let id):
            return "/api/users/\(id)"
        case .createUser:
            return "/api/users"
        case .updateUser(let id, _):
            return "/api/users/\(id)"
        case .deleteUser(let id):
            return "/api/users/\(id)"
        }
    }
}

// MARK: - Parameters
extension EndPoint {
    
    private var parameters: [String : Any]? {
        switch self {
        case .users(let page):
            return ["page": "\(page)"]
        case .userDetails,
             .createUser,
             .updateUser,
             .deleteUser:
            return nil
        }
    }
}

// MARK: - Query Components
extension EndPoint {
    
    private var queryComponents: [URLQueryItem] {
        var components = [URLQueryItem]()
        
        guard let parameters = parameters else { return components }
        
        for(key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.append(queryItem)
        }
        
        return components
    }
}

// MARK: - Http Method Type
extension EndPoint {
    
    var methodType: MethodType {
        switch self {
            
        case .users,
             .userDetails:
            return .GET
        case .createUser(let data):
            return .POST(data: data)
        case .updateUser(_, let data):
            return .PUT(data: data)
        case .deleteUser:
            return .DELETE
        }
    }
}

// MARK: - Url
extension EndPoint {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryComponents
        
        #if DEBUG
        components.queryItems?.append(
            URLQueryItem(name: "delay", value: "1")
        )
        #endif
        
        return components.url
    }
}
