//
//  BetterProfessorUITests.swift
//  BetterProfessorUITests
//
//  Created by Stephanie Ballard on 6/24/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import XCTest
@testable import BetterProfessor

class BetterProfessorUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        app.launchArguments = ["UITesting"]
        app.launch()
    }
    func testLoginButtonTapped() {
        app.buttons["Log In"].tap()
        XCTAssertNotNil(app.buttons["Log In"])
}
    func testUserLoginButtonTapped() {
        app.buttons["Log In"].tap()
        app.textFields["Username:"].tap()
        app.secureTextFields["Password:"].tap()
        app.buttons.containing(.staticText, identifier:"Log In").element.tap()
    }
    func testLaunchPerformance() throws {
      if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
        measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
          XCUIApplication().launch()
        }
      }
    }
    func testUserNameTextFieldText() {
        app.buttons["Log In"].tap()
        app.textFields["Username:"].tap()
        app.textFields["Username:"].typeText("Stephanie")
        XCTAssertNotNil(app.textFields)
    }
    func testNewUserCanSignUp() {
        let usernameTextField = app.textFields["Username:"]
        usernameTextField.tap()
        app.secureTextFields["Password:"].tap()
        app.secureTextFields["Confirm Password:"].tap()
        app.textFields["Email:"].tap()
        app.textFields["Department:"].tap()
        app.staticTexts["Sign Up"].tap()
    }
}
