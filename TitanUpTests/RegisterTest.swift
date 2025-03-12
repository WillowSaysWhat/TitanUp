//
//  RegisterTest.swift
//  TitanUpTests
//
//  Created by Huw Williams on 25/02/2025.
//

import XCTest
@testable import TitanUp

final class RegisterViewModelTests: XCTestCase {
    
    var viewModel: RegisterViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = RegisterViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // Empty fields should fail validation
    func testValidationFailsWhenFieldsAreEmpty() {
        viewModel.name = ""
        viewModel.email = ""
        viewModel.password = ""
        viewModel.checkPassword = ""
        
        XCTAssertFalse(viewModel.validate()) // Should fail
        XCTAssertEqual(viewModel.errorMessage, "please enter login details.")
    }
    
    // Invalid email should fail validation
    func testValidationFailsForInvalidEmail() {
        viewModel.name = "John Doe"
        viewModel.email = "invalidEmail"
        viewModel.password = "password123"
        viewModel.checkPassword = "password123"
        
        XCTAssertFalse(viewModel.validate()) // Should fail
        XCTAssertEqual(viewModel.errorMessage, "Please enter a valid email.")
    }
    
    // Password too short should fail validation
    func testValidationFailsForShortPassword() {
        viewModel.name = "John Doe"
        viewModel.email = "test@example.com"
        viewModel.password = "123"
        viewModel.checkPassword = "123"
        
        XCTAssertFalse(viewModel.validate()) // Should fail
        XCTAssertEqual(viewModel.errorMessage, "Please enter a Password 6 or more characters.")
    }
    
    // Passwords do not match should fail validation
    func testValidationFailsForMismatchedPasswords() {
        viewModel.name = "John Doe"
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        viewModel.checkPassword = "password321"
        
        XCTAssertFalse(viewModel.validate()) // Should fail
        XCTAssertEqual(viewModel.errorMessage, "Passwords do not match. Try again.")
    }
    
    // Valid input should pass validation
    func testValidationSucceedsForValidInput() {
        viewModel.name = "John Doe"
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        viewModel.checkPassword = "password123"
        
        XCTAssertTrue(viewModel.validate()) // Should pass
        XCTAssertEqual(viewModel.errorMessage, "") // No error message
    }
}
