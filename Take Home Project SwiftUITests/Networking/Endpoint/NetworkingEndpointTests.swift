//
//  NetworkingEndpointTests.swift
//  Take Home Project SwiftUITests
//
//  Created by Hansa Anuradha on 2023-03-02.
//

import XCTest
@testable import Take_Home_Project_SwiftUI

final class NetworkingEndpointTests: XCTestCase {

    func test_with_users_endpoint_request_is_valid() throws {
        
        let endpoint = Endpoint.users(page: 1)
        
        XCTAssertEqual(endpoint.scheme, "https", "The scheme should be https")
        XCTAssertEqual(endpoint.host, "reqres.in", "The hose should be reqres.in")
        XCTAssertEqual(endpoint.path, "/api/users", "The path should be /api/users")
        XCTAssertEqual(endpoint.methodType, .GET, "The method type should be GET")
        XCTAssertEqual(endpoint.queryComponents.first, URLQueryItem(name: "page", value: "1"), "The first query component should be page:1")
        
        XCTAssertEqual(endpoint.url?.absoluteString, "https://reqres.in/api/users?page=1&delay=1", "Url should be https://reqres.in/api/users?page=1&delay=1")
    }
    
    func test_with_user_details_endpoint_request_is_valid() throws {
        
        let userId = 1
        let endpoint = Endpoint.userDetails(id: userId)
        
        XCTAssertEqual(endpoint.scheme, "https", "The scheme should be https")
        XCTAssertEqual(endpoint.host, "reqres.in", "The hose should be reqres.in")
        XCTAssertEqual(endpoint.path, "/api/users/\(userId)", "The path should be /api/users/\(userId)")
        XCTAssertEqual(endpoint.methodType, .GET, "The method type should be GET")
        XCTAssertEqual(endpoint.queryComponents.first!, URLQueryItem(name: "delay", value: "1"), "The first query component should be delay=1")
        
        XCTAssertEqual(endpoint.url!.absoluteString, "https://reqres.in/api/users/\(userId)?delay=1", "Url should be https://reqres.in/api/users/\(userId)?delay=1")
    }
    
    func test_with_create_user_endpoint_request_is_valid() throws {
                                
        let endpoint = Endpoint.createUser(data: nil)
        
        XCTAssertEqual(endpoint.scheme, "https", "The scheme should be https")
        XCTAssertEqual(endpoint.host, "reqres.in", "The hose should be reqres.in")
        XCTAssertEqual(endpoint.path, "/api/users", "The path should be /api/users")
        XCTAssertEqual(endpoint.methodType, .POST(data: nil), "The method type should be POST")
        XCTAssertEqual(endpoint.queryComponents.first!, URLQueryItem(name: "delay", value: "1"), "The first query component should be delay=1")
        
        XCTAssertEqual(endpoint.url!.absoluteString, "https://reqres.in/api/users?delay=1", "Url should be https://reqres.in/api/users")
    }
    
    func test_with_update_user_endpoint_request_is_valid() throws {
        
        let userId = 1
        let endpoint = Endpoint.updateUser(id: userId, data: nil)
        
        XCTAssertEqual(endpoint.scheme, "https", "The scheme should be https")
        XCTAssertEqual(endpoint.host, "reqres.in", "The hose should be reqres.in")
        XCTAssertEqual(endpoint.path, "/api/users/\(userId)", "The path should be /api/users/\(userId)")
        XCTAssertEqual(endpoint.methodType, .PUT(data: nil), "The method type should be PUT")
        XCTAssertEqual(endpoint.queryComponents.first!, URLQueryItem(name: "delay", value: "1"), "The first query component should be delay=1")
        
        XCTAssertEqual(endpoint.url!.absoluteString, "https://reqres.in/api/users/\(userId)?delay=1", "https://reqres.in/api/users/\(userId)?delay=1")
    }
    
    func test_with_delete_user_endpoint_request_is_valid() throws {
        
        let userId = 1
        let endpoint = Endpoint.deleteUser(id: userId)
        
        XCTAssertEqual(endpoint.scheme, "https", "The scheme should be https")
        XCTAssertEqual(endpoint.host, "reqres.in", "The hose should be reqres.in")
        XCTAssertEqual(endpoint.path, "/api/users/\(userId)", "The path should be /api/users/\(userId)")
        XCTAssertEqual(endpoint.methodType, .DELETE, "The method type should be DELETE")
        XCTAssertEqual(endpoint.queryComponents.first!, URLQueryItem(name: "delay", value: "1"), "The first query component should be delay=1")
        
        XCTAssertEqual(endpoint.url!.absoluteString, "https://reqres.in/api/users/\(userId)?delay=1", "https://reqres.in/api/users/\(userId)?delay=1")
    }

}
