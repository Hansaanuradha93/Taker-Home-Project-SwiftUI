//
//  PeopleDetailViewModel.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

final class UserDetailsViewModel: ObservableObject {
    
    // MARK: Properties
    @Published private(set) var userInfo: UserDetailsResponse?
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published var hasError: Bool = false
    @Published private(set) var isLoading: Bool = false
}

// MARK: - Async Methods
extension UserDetailsViewModel {
    
    /// Fetch user details asynchronously
    /// - Parameter userId: id for the user
    @MainActor
    func fetchUserDetailsAsync(for userId: Int) async {
        
        isLoading = true
        
        // this will be called once everything in this method is completed
        defer { isLoading = false }
        
        do {
            let response = try await NetworkManager.shared.request(endPoint: .userDetails(id: userId),type: UserDetailsResponse.self)
            userInfo = response
        } catch {
            log(withType: .error(error: error))

            hasError = true
            
            if let networkError = error as? NetworkManager.NetworkError {
                self.error = networkError
            } else {
                self.error = .customError(error: error)
            }
        }
    }
}

// MARK: - Methods
extension UserDetailsViewModel {
    
    /// Fetch user detials
    /// - Parameter userId: id for the user
    func fetchUserDetails(for userId: Int) {
        
        isLoading = true
        
        NetworkManager.shared.request(endPoint: .userDetails(id: userId),
                                      type: UserDetailsResponse.self) { [weak self] result in
            
            DispatchQueue.main.async {
                
                // this will be called once everything in this method is completed
                defer { self?.isLoading = false }

                switch result {
                    
                case .success(let response):
                    self?.userInfo = response
                    
                case .failure(let error):
                    log(withType: .error(error: error))
                    self?.hasError = true
                    self?.error = error as? NetworkManager.NetworkError
                }
            }
        }
    }
}
