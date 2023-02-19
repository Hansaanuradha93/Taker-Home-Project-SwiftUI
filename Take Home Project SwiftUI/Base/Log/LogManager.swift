//
//  LogManager.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-19.
//

import os.log

final class LogManager {
    
    static let shared = LogManager()
    
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
        
        let logger = Logger()
        
        switch type {
        case .info:
            logger.info("🟢 Info: \(message)")
        case .warning:
            logger.warning("🟡 Warning: \(message)")
        case .error(let error):
            logger.error("🔴 Error: \(error.localizedDescription)")
        }
    }
}
