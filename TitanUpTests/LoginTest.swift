//
//  LoginTest.swift
//  TitanUpTests
//
//  Created by Huw Williams on 25/02/2025.
//

import XCTest
@testable import TitanUp

final class LoginViewModelTests: XCTestCase {
    //gets the login model
    var viewModel: LoginViewModel!
    
    // initialises login model before each test
    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
    }
    
    // clears viewModel after each test
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // Empty email and password should fail validation
    func testValidationFailsWhenFieldsAreEmpty() {
        viewModel.email = ""
        viewModel.password = ""
        
        viewModel.login()
        XCTAssertEqual(viewModel.errorMessage, "please enter login details.")
    }
    
    // Invalid email format should fail validation
    func testValidationFailsForInvalidEmail() {
        viewModel.email = "invalidEmail"
        viewModel.password = "password123"
        
        viewModel.login()
        XCTAssertEqual(viewModel.errorMessage, "please enter a valid email.")
    }
    
    // Valid email and password should pass validation
    func testValidationSucceedsForValidEmailAndPassword() {
        viewModel.email = "test@example.com"
        viewModel.password = "password123"
        
        viewModel.login()// Validation should pass
        XCTAssertEqual(viewModel.errorMessage, "") // No error message
    }
}

