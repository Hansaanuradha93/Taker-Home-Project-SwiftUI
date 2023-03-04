//
//  NetworkManagerTests.swift
//  Take Home Project SwiftUITests
//
//  Created by Hansa Anuradha on 2023-03-04.
//

import XCTest
@testable import Take_Home_Project_SwiftUI

final class NetworkManagerTests: XCTestCase {
    
    private var session: URLSession!
    private var url: URL!
    
    override func setUp() {

        url = URL(string: "https://reqres.in/api/users")

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSesstionProtocol.self]
        session = URLSession(configuration: configuration)

    }

    override func tearDown() {
        session = nil
        url = nil
    }

    func test_with_successful_response_with_data_is_valid() async throws {
        
                
        guard let path = Bundle.main.path(forResource: "UsersStaticData", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the UsersStaticData file")
            return
        }
        
        MockURLSesstionProtocol.loadingHandler = {
            
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            
            return (response!, data)
        }
        
        let response = try await NetworkManager.shared.request(session: session,
                                                               endPoint: .users(page: 1),
                                                               type: UsersResponse.self)
        
        
        let staticJSON = try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        
        XCTAssertEqual(response, staticJSON, "The returned response should be decoded properly")
    }

    func test_with_successful_response_void_is_valid() async throws {
        
        MockURLSesstionProtocol.loadingHandler = {
            
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            
            return (response!, nil)
        }
        
        _ = try await NetworkManager.shared.request(session: session,
                                                    endPoint: .users(page: 1))
    }
    
    
    func test_with_unsuccessful_response_code_in_invalid_range_is_invalid() async {
        
        let invalidStatusCode = 400
        
        MockURLSesstionProtocol.loadingHandler = {
            
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: invalidStatusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            
            return (response!, nil)
        }
        
        do {
            _ = try await NetworkManager.shared.request(session: session,
                                                        endPoint: .users(page: 1),
                                                        type: UsersResponse.self)
        } catch {
            
            guard let invalidStatusCodeErro = error as? NetworkManager.NetworkError else {
                XCTFail("Got a wrong type of error. Expecting a network error")
                return
            }
            
            XCTAssertEqual(invalidStatusCodeErro, NetworkManager.NetworkError.invalidStatusCode(statusCode: invalidStatusCode), "Invalid status code \(invalidStatusCode) should be thrown")
        }
    }
    
    func test_with_unsuccessful_response_code_void_in_invalid_range_is_invalid() async {
        
        let invalidStatusCode = 400
        
        MockURLSesstionProtocol.loadingHandler = {
            
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: invalidStatusCode,
                                           httpVersion: nil,
                                           headerFields: nil)
            
            return (response!, nil)
        }
        
        do {
            _ = try await NetworkManager.shared.request(session: session,
                                                        endPoint: .users(page: 1))
        } catch {
            
            guard let invalidStatusCodeErro = error as? NetworkManager.NetworkError else {
                XCTFail("Got a wrong type of error. Expecting a network error")
                return
            }
            
            XCTAssertEqual(invalidStatusCodeErro, NetworkManager.NetworkError.invalidStatusCode(statusCode: invalidStatusCode), "Invalid status code \(invalidStatusCode) should be thrown")
        }
    }
    
    func test_with_successful_response_invalid_json_is_invalid() async {
        
        guard let path = Bundle.main.path(forResource: "UsersStaticData", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the UsersStaticData file")
            return
        }
        
        MockURLSesstionProtocol.loadingHandler = {
            
            let response = HTTPURLResponse(url: self.url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            
            return (response!, data)
        }
        
        do {
            
            _ = try await NetworkManager.shared.request(session: session,
                                                        endPoint: .users(page: 1),
                                                        type: UserDetailsResponse.self)
            
        } catch {
            
            if error is NetworkManager.NetworkError {
                XCTFail("The error should a system decoding error")
                return
            }
        }
    }
    
}
