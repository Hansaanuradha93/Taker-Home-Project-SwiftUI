//
//  CreateViewModel.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

final class CreateViewModel: ObservableObject {
    
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
    @MainActor
    func createAsync() async {
        
        do {
            
            try validator.validate(newUser)
            
            submissionState = .submitting

            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(newUser)
            
            try await NetworkManager.shared.request(endPoint: .createUser(data: data))
            
            log(message: "New user created", withType: .info)
            submissionState = .successful
            
        } catch {
            log(withType: .error(error: error))
            
            hasError = true

            submissionState = .unsuccessful
            
            switch error {
                
            case is NetworkManager.NetworkError:
                self.error = .network(error: error as! NetworkManager.NetworkError)
                
            case is CreateValidator.CreateValidatorError:
                self.error = .validation(error: error as! CreateValidator.CreateValidatorError)
                
            
            default:
                self.error = .system(error: error)
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
        case system(error: Error)
    }
}

// MARK: - Error Descriptions
extension CreateViewModel.FormError {
    
    var errorDescription: String? {
        switch self {
        case .network(let error),
             .validation(let error):
            return error.errorDescription
        case .system(let error):
            return error.localizedDescription
        }
    }
}
