//
//  PeopleDetailViewModel.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

final class UserDetailsViewModel: ObservableObject {
    
    @Published private(set) var userInfo: UserDetailsResponse?
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published var hasError: Bool = false
    @Published private(set) var isLoading: Bool = false
    
    func fetchUserDetails(for userId: Int) {
        
        isLoading = true
        
        NetworkManager.shared.request(endPoint: .userDetails(id: userId),
                                      type: UserDetailsResponse.self) { [weak self] result in
            
            DispatchQueue.main.async {
                
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
