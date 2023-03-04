//
//  PeopleViewModel.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-18.
//

import Foundation

final class PeopleViewModel: ObservableObject {
    
    // MARK: Properties
    @Published private(set) var users: [User] = []
    @Published private(set) var error: NetworkManager.NetworkError?
    @Published var hasError: Bool = false
    @Published private(set) var viewState: ViewState?
    
    private var page: Int = 1
    
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
}

// MARK: - Async Methods
extension PeopleViewModel {
    
    /// Fetch users asynchronously
    /// - Parameter page: users on page
    @MainActor
    func fetchUsersAsync() async {
        
        reset()
        
        viewState = .loading
        
        // this will be called once everything in this method is completed
        defer { viewState = .finished }
        
        do {
            
            let response = try await NetworkManager.shared.request(endPoint: .users(page: page), type: UsersResponse.self)
            self.users = response.data
            
        } catch {
            log(withType: .error(error: error))
            
            self.hasError = true
            
            if let networkError = error as? NetworkManager.NetworkError {
                self.error = networkError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
    
    @MainActor
    func fetchNextSetOfUsersAsync() async {
        
        page += 1
        
        viewState = .fetching
        
        // this will be called once everything in this method is completed
        defer { viewState = .finished }

        do {
            
            let response = try await NetworkManager.shared.request(endPoint: .users(page: page), type: UsersResponse.self)
            self.users.append(contentsOf: response.data) 
            
        } catch {
            log(withType: .error(error: error))
            
            self.hasError = true
            
            if let networkError = error as? NetworkManager.NetworkError {
                self.error = networkError
            } else {
                self.error = .custom(error: error)
            }
        }
    }
}

// MARK: - Methods
extension PeopleViewModel {
    
    /// Fetch users
    /// - Parameter page: users on page
    func fetchUsers() {
                
        viewState = .loading

        NetworkManager.shared.request(endPoint: .users(page: page),
                                      type: UsersResponse.self) { [weak self] result in
            
            DispatchQueue.main.async {
                                
                // this will be called once everything in this method is completed
                defer { self?.viewState = .finished }
                
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
}

// MARK: - Helper Methods
extension PeopleViewModel {
    
    func hasReachedEnd(of user: User) -> Bool {
        users.last?.id == user.id
    }
}

// MARK: Private Methods
extension PeopleViewModel {
    
    func reset() {
        if viewState == .finished {
            users.removeAll()
            page = 1
            viewState = nil
        }
    }
}

// MARK: - ViewState
extension PeopleViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}
