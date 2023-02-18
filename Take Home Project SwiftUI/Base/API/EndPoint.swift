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
        }
    }
}


// MARK: - Parameters
extension EndPoint {
    
    private var parameters: [String : Any] {
        switch self {
        case .users(let page):
            return ["page": "\(page)"]
        case .userDetails:
            return ["": ""]
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
