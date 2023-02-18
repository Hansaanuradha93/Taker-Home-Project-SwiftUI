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
    
    func create() {
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(newUser)
        
        NetworkManager.shared.request(endPoint: .createUser, httpMethod: .POST(data: data)) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success():
                    print("🟢 New user created")
                    self?.submissionState = .successful
                    
                case .failure(let error):
                    print("🔴 \(error.localizedDescription)")
                    self?.submissionState = .unsuccessful
                }
            }
            
        }
    }
}

extension CreateViewModel {
    
    enum SubmissionState {
        case successful
        case unsuccessful
    }
}
