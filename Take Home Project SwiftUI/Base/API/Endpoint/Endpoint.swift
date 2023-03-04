//
//  EndPoint.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

// MARK: Cases
enum Endpoint {
    case users(page: Int)
    case userDetails(id: Int)
    case createUser(data: Data?)
    case updateUser(id: Int, data: Data?)
    case deleteUser(id: Int)
}

// MARK: - HTTP Methods
extension Endpoint {
    
    enum MethodType: Equatable {
        case GET
        case POST(data: Data?)
        case PUT(data: Data?)
        case DELETE
    }
}

// MARK: - Scheme
extension Endpoint {
    var scheme: String { return "https" }
}

// MARK: - Host
extension Endpoint {
    var host: String { return "reqres.in" }
}

// MARK: - Path
extension Endpoint {
    
     var path: String {
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
extension Endpoint {
    
    var parameters: [String : Any]? {
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
extension Endpoint {
    
    var queryComponents: [URLQueryItem] {
        
        var components: [URLQueryItem] = []
        
        parameters?.forEach { item in
            let component = URLQueryItem(name: item.key, value: "\(item.value)")
            components.append(component)
        }
        
        #if DEBUG
        components.append(
            URLQueryItem(name: "delay", value: "1")
        )
        #endif
        
        return components
    }
}

// MARK: - Http Method Type
extension Endpoint {
    
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
extension Endpoint {
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryComponents.isEmpty ? nil : queryComponents
        return components.url
    }
}
