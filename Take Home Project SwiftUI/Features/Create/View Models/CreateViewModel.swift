//
//  CreateViewModel.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

final class CreateViewModel: ObservableObject {
    
    @Published var newUser = NewUser()
    @Published private(set) var submissionState: SubmissionState?
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published var hasError: Bool = false
    
    func create() {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(newUser)
        
        NetworkManager.shared.request(endPoint: .createUser, httpMethod: .POST(data: data)) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success():
                    LogManager.shared.log(message: "New user created", withType: .info)
                    self?.submissionState = .successful
                    
                case .failure(let error):
                    LogManager.shared.log(withType: .error(error: error))
                    self?.hasError = true
                    self?.submissionState = .unsuccessful
                    self?.error = error as? NetworkManager.NetworkError
                }
            }
        }
    }
}

// MARK: - Submission State
extension CreateViewModel {
    
    enum SubmissionState {
        case successful
        case unsuccessful
    }
}
