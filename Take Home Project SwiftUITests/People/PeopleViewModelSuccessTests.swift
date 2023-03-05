//
//  PeopleViewModelSuccessTests.swift
//  Take Home Project SwiftUITests
//
//  Created by Hansa Anuradha on 2023-03-05.
//

import XCTest
@testable import Take_Home_Project_SwiftUI

final class PeopleViewModelSuccessTests: XCTestCase {
    
    private var networkManagerMock: NetworkManagerImplementation!
    private var viewModel: PeopleViewModel!
    
    override func setUp() {
        networkManagerMock = NetworkManagerUsersResponseSuccessMock()
        viewModel = PeopleViewModel(networkManager: networkManagerMock)
    }
    
    override func tearDown() {
        networkManagerMock = nil
        viewModel = nil
    }

    func test_with_successful_response_users_array_is_set() async {
        
        XCTAssertEqual(viewModel.page, 1, "Page should be 1")

        XCTAssertFalse(viewModel.isLoading, "Is loading should be false ")
        
        // This will be called after everything is finished in the function
        defer {
            XCTAssertFalse(viewModel.isLoading, "Is loading should be false ")
            
            XCTAssertEqual(viewModel.viewState, .finished, "View State should be finished")
            
            XCTAssertFalse(viewModel.hasError, "Has Error should be false")
            
            XCTAssertEqual(viewModel.page, 1, "Page should be 1")
        }
        
        await viewModel.fetchUsersAsync()

        XCTAssertEqual(viewModel.users.count, 6, "Users count should be 6")
        
    }
    
    func test_with_successful_paginated_users_array_is_set() async throws {
        
        XCTAssertEqual(viewModel.isLoading, false, "Is Loading should be false")
        
        // This will be called after everything is finished in the function

        defer {
            XCTAssertEqual(viewModel.viewState, .finished, "View State should be finished")
            
            XCTAssertEqual(viewModel.isFetching, false, "Is Fetching should be false")
            
            XCTAssertFalse(viewModel.hasError, "Has Error should be false")
        }
        
        XCTAssertEqual(viewModel.page, 1, "Page should be 1")

        await viewModel.fetchUsersAsync()

        XCTAssertEqual(viewModel.users.count, 6, "Users count should be 6")

        await viewModel.fetchNextSetOfUsersAsync()
        
        XCTAssertEqual(viewModel.users.count, 12, "Users count should be 12")
        
        XCTAssertEqual(viewModel.page, 2, "Page should be 2")

    }

    func test_with_reset_called_values_is_reset() async throws {
        
        await viewModel.fetchUsersAsync()
        
        XCTAssertEqual(viewModel.users.count, 6, "Users count should be 6")

        await viewModel.fetchNextSetOfUsersAsync()
        
        XCTAssertEqual(viewModel.users.count, 12, "Users count should be 12")
        
        XCTAssertEqual(viewModel.page, 2, "Page should be 2")

        await viewModel.fetchUsersAsync()
        
        XCTAssertEqual(viewModel.users.count, 6, "Users count should be 6")

        XCTAssertEqual(viewModel.page, 1, "Page should be 1")
        
        XCTAssertEqual(viewModel.viewState, .finished, "View State should be finished")
        
        XCTAssertFalse(viewModel.isLoading, "Is loading should be false ")
    }
    
    func test_with_last_users_func_returns_true() async throws {
        
        await viewModel.fetchUsersAsync()
        
        let userData = try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        
        let hasReachedEnd = viewModel.hasReachedEnd(of: userData.data.last!)
        
        XCTAssertTrue(hasReachedEnd, "The last user should match")
    }
}
