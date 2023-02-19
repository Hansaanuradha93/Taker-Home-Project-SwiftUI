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
    
    func fetchUsers(onPage page: Int = 1) {
        
        NetworkManager.shared.request(endPoint: .users(page: page),
                                      type: UsersResponse.self) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let response):
                    self?.users = response.data
                    
                case .failure(let error):
                    print("🔴 error: \(error)")
                    self?.hasError = true
                    self?.error = error as? NetworkManager.NetworkError
                }
            }
        }
    }
}
