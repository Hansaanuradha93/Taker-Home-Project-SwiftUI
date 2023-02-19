//
//  PeopleViewModel.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

final class PeopleViewModel: ObservableObject {
    
    @Published private(set) var users: [User] = []
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published var hasError: Bool = false
    @Published private(set) var isLoading: Bool = false
    
    func fetchUsers(onPage page: Int = 1) {
        
        isLoading = true
        
        NetworkManager.shared.request(endPoint: .users(page: page),
                                      type: UsersResponse.self) { [weak self] result in
            
            DispatchQueue.main.async {
                
                defer { self?.isLoading = false }
                
                switch result {
                    
                case .success(let response):
                    self?.users = response.data
                    
                case .failure(let error):
                    LogManager.shared.log(withType: .error(error: error))
                    self?.hasError = true
                    self?.error = error as? NetworkManager.NetworkError
                }
            }
        }
    }
}
