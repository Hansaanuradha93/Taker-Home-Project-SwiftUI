//
//  CreateValidator.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-20.
//

import Foundation

struct CreateValidator {
    
    func validate(_ newUser: NewUser) throws {
        
        if newUser.firstName.isEmpty {
            throw CreateValidatorError.invalidFirstName
        }
        
        if newUser.lastName.isEmpty {
            throw CreateValidatorError.invalidLastName
        }
        
        if newUser.job.isEmpty {
            throw CreateValidatorError.invalidJob
        }
    }
}

// MARK: - Error Types
extension CreateValidator {
    
    enum CreateValidatorError: LocalizedError {
        case invalidFirstName
        case invalidLastName
        case invalidJob
    }
}

// MARK: - Error Descriptions
extension CreateValidator.CreateValidatorError {
    
    var errorDescription: String? {
        switch self {
        case .invalidFirstName:
            return "First name can't be empty"
        case .invalidLastName:
            return "Last name can't be empty"
        case .invalidJob:
            return "Job can't be empty"
        }
    }
}
