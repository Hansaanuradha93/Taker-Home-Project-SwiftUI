//
//  PeopleViewModelFaliureTests.swift
//  Take Home Project SwiftUITests
//
//  Created by Hansa Anuradha on 2023-03-05.
//

import XCTest
@testable import Take_Home_Project_SwiftUI

final class PeopleViewModelFaliureTests: XCTestCase {

    private var networkManagerMock: NetworkManagerImplementation!
    private var viewModel: PeopleViewModel!
    
    override func setUp() {
        networkManagerMock = NetworkManagerUsersResponseFailureMock()
        viewModel = PeopleViewModel(networkManager: networkManagerMock)
    }
    
    override func tearDown() {
        networkManagerMock = nil
        viewModel = nil
    }
    
    func test_with_unsuccessful_response_error_is_handled() async {
        
        
        XCTAssertFalse(viewModel.isLoading, "Is loading should be false ")
        
        // This will be called after everything is finished in the function
        defer {
            XCTAssertFalse(viewModel.isLoading, "Is loading should be false ")
            
            XCTAssertEqual(viewModel.viewState, .finished, "View State should be finished")
            
        }
        
        await viewModel.fetchUsersAsync()
        
        XCTAssertTrue(viewModel.hasError, "Has Error should be false")

        XCTAssertNotNil(viewModel.error, "There should be an error")
    }
}
