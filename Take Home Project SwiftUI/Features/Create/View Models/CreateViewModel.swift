//
//  CreateViewModel.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

@MainActor final class CreateViewModel: ObservableObject {
    
    // MARK: Properties
    @Published var newUser = NewUser()
    @Published private(set) var submissionState: SubmissionState?
    @Published private(set) var error: FormError?
    @Published var hasError: Bool = false
    
    private let validator = CreateValidator()
}

// MARK: - Async Methods
extension CreateViewModel {
    
    /// Create new user asynchronously
    func createAsync() async {
        
        do {
            
            try validator.validate(newUser)
            
            submissionState = .submitting

            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try? encoder.encode(newUser)
            
            try await NetworkManager.shared.request(endPoint: .createUser(data: data))
            
            log(message: "New user created", withType: .info)
            submissionState = .successful
            
        } catch {
            log(withType: .error(error: error))
            
            submissionState = .unsuccessful

            hasError = true
            
            if let networkError = error as? NetworkManager.NetworkError {
                self.error = .network(error: networkError)
            }
            
            if let validationError = error as? CreateValidator.CreateValidatorError {
                self.error = .validation(error: validationError)
            }
        }
    }
}

// MARK: - Methods
extension CreateViewModel {
    
    /// Create new user
    func create() {
        
        do {
            try validator.validate(newUser)
            
            submissionState = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try? encoder.encode(newUser)
            
            NetworkManager.shared.request(endPoint: .createUser(data: data)) { [weak self] result in
                
                DispatchQueue.main.async {
                    
                    switch result {
                        
                    case .success():
                        log(message: "New user created", withType: .info)
                        self?.submissionState = .successful
                        
                    case .failure(let error):
                        log(withType: .error(error: error))
                        self?.submissionState = .unsuccessful
                        self?.hasError = true
                        
                        if let networkError = error as? NetworkManager.NetworkError {
                            self?.error = .network(error: networkError)
                        }
                    }
                }
            }
            
        } catch {
            log(withType: .error(error: error))
            
            self.hasError = true
            if let validationError = error as? CreateValidator.CreateValidatorError {
                self .error = .network(error: validationError)
            }
        }
    }
}

// MARK: - Submission State
extension CreateViewModel {
    
    enum SubmissionState {
        case successful
        case unsuccessful
        case submitting
    }
}

// MARK: - Error Types
extension CreateViewModel {
    
    enum FormError: LocalizedError {
        case network(error: LocalizedError)
        case validation(error: LocalizedError)
    }
}

// MARK: - Error Descriptions
extension CreateViewModel.FormError {
    
    var errorDescription: String? {
        switch self {
        case .network(let error),
             .validation(let error):
            return error.localizedDescription
        }
    }
}
