//
//  CreateFormValidatorTests.swift
//  Take Home Project SwiftUITests
//
//  Created by Hansa Anuradha on 2023-02-26.
//

import XCTest
@testable import Take_Home_Project_SwiftUI

final class CreateFormValidatorTests: XCTestCase {
    
    private var validator: CreateValidator!
    
    override func setUp() {
        validator = CreateValidator()
    }
    
    override func tearDown() {
        validator = nil
    }
    

    func test_with_empty_first_name_error_thrown() {
        let user = NewUser()
        
        XCTAssertThrowsError(try validator.validate(user), "Error for empty first name should be thrown")
        
        do {
            
            _ = try validator.validate(user)
            
        } catch {
            
            guard let validatorError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("Got a wrong type of error. Expecting a create validator error")
                return
            }
            
            XCTAssertEqual(validatorError, CreateValidator.CreateValidatorError.invalidFirstName, "Invalid first name error should be thrown")
        }
    }
    
    func test_with_empty_last_name_error_thrown() {
        let user = NewUser(firstName: "John", job: "Content Creater")
        
        XCTAssertThrowsError(try validator.validate(user), "Error for empty last name should be thrown")
        
        do {
            
            _ = try validator.validate(user)
            
        } catch {
            
            guard let validatorError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("Got a wrong type of error. Expecting a create validator error")
                return
            }
            
            XCTAssertEqual(validatorError, CreateValidator.CreateValidatorError.invalidLastName, "Invalid last name error should be thrown")
        }
    }
    
    func test_with_empty_job_error_thrown() {
        let user = NewUser(firstName: "John", lastName: "Doe")
        
        XCTAssertThrowsError(try validator.validate(user), "Error for empty job name should be thrown")
        
        do {
            
            _ = try validator.validate(user)
            
        } catch {
            
            guard let validatorError = error as? CreateValidator.CreateValidatorError else {
                XCTFail("Got a wrong type of error. Expecting a create validator error")
                return
            }
            
            XCTAssertEqual(validatorError, CreateValidator.CreateValidatorError.invalidJob, "Invalid job error should be thrown")
        }

    }
    
    func test_with_valid_user_error_not_thrown() {
        let user = NewUser(firstName: "John", lastName: "Doe", job: "Content Creater")
        
        XCTAssertNoThrow(try validator.validate(user), "No error should be thrown")

        do {
            _ = try validator.validate(user)
            
        } catch {
            XCTFail("No errors should be thrown, since the user should be a valid object")
        }
    }
}
