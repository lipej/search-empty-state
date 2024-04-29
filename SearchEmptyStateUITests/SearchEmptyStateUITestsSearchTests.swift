//
//  SearchEmptyStateUITestsSearchTests.swift
//  SearchEmptyStateUITests
//
//  Created by Felipe José on 29/04/24.
//

import XCTest

final class SearchEmptyStateUITestsSearchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
      continueAfterFailure = false
      app = XCUIApplication()
      app.launch()
      app.swipeDown()
    }


    func testErrorMessage() throws {
        let searchTerm = "Testing"
        let expectedResultErrorMessage = "No wizards was found with: \(searchTerm), maybe you're looking for a muggle?"
        let search = app.searchFields["Search a Wizard"]
        
        search.tap()
        search.typeText(searchTerm)
        
        let resultError = app.staticTexts["ResultError"]
        XCTAssertTrue(resultError.isHittable)
        XCTAssertEqual(resultError.label, expectedResultErrorMessage)
    }
}
