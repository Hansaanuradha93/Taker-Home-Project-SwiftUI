//
//  PeopleViewModel.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

@MainActor final class PeopleViewModel: ObservableObject {
    
    @Published private(set) var users: [User] = []
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published var hasError: Bool = false
    @Published private(set) var isLoading: Bool = false
    
    /// Fetch users
    /// - Parameter page: users on page
    func fetchUsers(onPage page: Int = 1) {
        
        isLoading = true
        
        NetworkManager.shared.request(endPoint: .users(page: page),
                                      type: UsersResponse.self) { [weak self] result in
            
            DispatchQueue.main.async {
                                
                self?.isLoading = false
                
                switch result {
                    
                case .success(let response):
                    self?.users = response.data
                    
                case .failure(let error):
                    log(withType: .error(error: error))
                    self?.hasError = true
                    self?.error = error as? NetworkManager.NetworkError
                }
            }
        }
    }
    
    /// Fetch users asynchronously
    /// - Parameter page: users on page
    func fetchUsersAsync(onPage page: Int = 1) async {
        
        isLoading = true
        
        defer { isLoading = false }
        
        do {
            
            let response = try await NetworkManager.shared.request(endPoint: .users(page: page), type: UsersResponse.self)
            self.users = response.data
            
        } catch {
            
            self.hasError = true
            
            if let networkError = error as? NetworkManager.NetworkError {
                self.error = networkError
            } else {
                self.error = .customError(error: error)
            }
        }
    }
}
