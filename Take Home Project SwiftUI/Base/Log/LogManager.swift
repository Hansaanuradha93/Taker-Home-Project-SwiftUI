//
//  LogManager.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-19.
//

import Foundation
import os.log

final class LogManager {
    
    static let shared = LogManager()
    
    private let logger = Logger()
    
    private init() {}
}

// MARK: - Logger Types
extension LogManager {
    
    enum LogType {
        case info
        case warning
        case error(error: Error)
    }
}

// MARK: - Methods
extension LogManager {
    
    func log(message: String = "", withType type: LogType) {
        
        switch type {
        case .info:
            logger.info("🟢 Info: \(message)")
        case .warning:
            logger.warning("🟡 Warning: \(message)")
        case .error(let error):
            logger.error("🔴 Error: \(error.localizedDescription)")
        }
    }
    
    func log(urlRequest request: URLRequest) {
        
        let httpHeaders = request.allHTTPHeaderFields?.debugDescription
        
        let httpMethod = request.httpMethod
        
        let urlString = request.url?.absoluteString
        
        let httpBody = request.httpBody?.debugDescription
        
        var message = "\n➡️\n"
        
        if let httpHeaders = httpHeaders {
            message.append("Http Headers: \(httpHeaders)\n")
        }
        
        if let httpMethod = httpMethod {
            message.append("Http Method: \(httpMethod)\n")
        }
        
        if let urlString = urlString {
            message.append("Url: \(urlString)\n")
        }
        
        if let httpBody = httpBody {
            message.append("Http Body: \(httpBody)\n")
        }
        
        message.append("⬅️\n")
        
        logger.debug("\(message)")
    }
}


func log(message: String = "", withType type: LogManager.LogType) {
    LogManager.shared.log(message: message, withType: type)
}

func log(_ request: URLRequest) {
    LogManager.shared.log(urlRequest: request)
}
