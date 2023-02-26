//
//  JSONMapperTests.swift
//  Take Home Project SwiftUITests
//
//  Created by Hansa Anuradha on 2023-02-25.
//

import XCTest
@testable import Take_Home_Project_SwiftUI

class JSONMapperTests: XCTestCase {
    
    func test_with_valid_json_successfully_decodes() {
        
        XCTAssertNoThrow(try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self), "Mapper shouldn't throw and error")
        
        let usersResponse = try? StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        XCTAssertNotNil(usersResponse, "Users respoonse shouldn't be nil")
        
        XCTAssertEqual(usersResponse?.page, 1, "Page number should be 1")
        XCTAssertEqual(usersResponse?.perPage, 6, "Per page should be 6")
        XCTAssertEqual(usersResponse?.total, 12, "Total should be 12")
        XCTAssertEqual(usersResponse?.totalPages, 2, "Total pages should be 2")
        
        XCTAssertEqual(usersResponse?.data.count, 6, "The total number of users should be 6")
        
        let firstUser = usersResponse?.data[0]
        
        XCTAssertEqual(firstUser?.id, 1, "Id should be 1")
        XCTAssertEqual(firstUser?.email, "george.bluth@reqres.in", "Email should be george.bluth@reqres.in")
        XCTAssertEqual(firstUser?.firstName, "George", "first name should be George")
        XCTAssertEqual(firstUser?.lastName, "Bluth", "Last name should be Bluth")
        XCTAssertEqual(firstUser?.avatar, "https://reqres.in/img/faces/1-image.jpg", "The url should be https://reqres.in/img/faces/1-image.jpg")
    }
    
    func test_with_missing_file_name_error_thrown() {
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "", type: UsersResponse.self), "An error should be thrown")
        
        do {
            _ = try StaticJSONMapper.decode(file: "", type: UsersResponse.self)
            
        } catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is the wrong type of error")
                return
            }
            
            XCTAssertEqual(mappingError, StaticJSONMapper.MappingError.failedToGetContent, "This should be failed to get content error")
        }
    }
    
    func test_with_invalid_file_name_error_thrown() {
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "jdnsf", type: UsersResponse.self), "An error should be thrown")
        
        do {
            _ = try StaticJSONMapper.decode(file: "jdnsf", type: UsersResponse.self)
            
        } catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is the wrong type of error")
                return
            }
            
            XCTAssertEqual(mappingError, StaticJSONMapper.MappingError.failedToGetContent, "This should be failed to get content error")
        }
    }
    
    func test_with_invalid_json_error_thrown() {
        
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "UsersStaticData", type: UserDetailsResponse.self), "An error should be thrown")
        
        do {
            _ = try StaticJSONMapper.decode(file: "UsersStaticData", type: UserDetailsResponse.self)
            
        } catch {
            if error is StaticJSONMapper.MappingError {
                XCTFail("Got the wrong type of error, expecting a system decoding error")
            }
        }
    }
}
