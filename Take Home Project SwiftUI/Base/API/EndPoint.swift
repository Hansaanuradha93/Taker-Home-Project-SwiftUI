//
//  EndPoint.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

// MARK: Cases
enum EndPoint {
    case users(page: Int, delay: Int = 0)
    case userDetails(id: Int, delay: Int = 0)
    case createUser(delay: Int = 0)
    case updateUser(id: Int, delay: Int = 0)
    case deleteUser(id: Int, delay: Int = 0)
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
        case .userDetails(let id, _):
            return "/api/users/\(id)"
        case .createUser:
            return "/api/users"
        case .updateUser(let id, _):
            return "/api/users/\(id)"
        case .deleteUser(let id, _):
            return "/api/users/\(id)"
        }
    }
}

// MARK: - Parameters
extension EndPoint {
    
    private var parameters: [String : Any] {
        switch self {
        case .users(let page, let delay):
            return [
                "page": "\(page)",
                "delay": "\(delay)"
            ]
        case .userDetails(_, let delay):
            return ["delay": "\(delay)"]
        case .createUser(let delay):
            return ["delay": "\(delay)"]
        case .updateUser(_, let delay):
            return ["delay": "\(delay)"]
        case .deleteUser(_, let delay):
            return ["delay": "\(delay)"]
        }
    }
}

// MARK: - Query Components
extension EndPoint {
    
    private var queryComponents: [URLQueryItem] {
        var components = [URLQueryItem]()
        
        for(key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.append(queryItem)
        }
        
        return components
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
        return components.url
    }
}
