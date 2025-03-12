//
//  ContentTest.swift
//  TitanUpTests
//
//  Created by Huw Williams on 25/02/2025.
//

import XCTest
@testable import TitanUp

final class ContentViewModelTests: XCTestCase {
    
    var viewModel: ContentViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ContentViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // `isSignedIn` should be false when no user is logged in
    func testIsSignedIn_WhenNoUser_ShouldBeFalse() {
        viewModel.currentUserId = "" // Simulate no user
        XCTAssertFalse(viewModel.isSignedIn)
    }
    
    // `isSignedIn` should be true when a user ID is present
    func testIsSignedIn_WhenUserIsLoggedIn_ShouldBeTrue() {
        viewModel.currentUserId = "123456" // Simulate a user logging in
        XCTAssertTrue(viewModel.isSignedIn)
    }
    
    // Default `currentUserId` should be empty
    func testCurrentUserId_ShouldStartEmpty() {
        XCTAssertEqual(viewModel.currentUserId, "")
    }
    
    // Showing new item view should be false by default
    func testShowingNewItemView_ShouldStartFalse() {
        XCTAssertFalse(viewModel.showingNewItemView)
    }
    
    //`isSheet` should be false by default
    func testIsSheet_ShouldStartFalse() {
        XCTAssertFalse(viewModel.isSheet)
    }
}

