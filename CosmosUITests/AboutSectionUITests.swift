//
//  AboutSectionUITests.swift
//  AboutSectionUITests
//
//  Created by Samuel Yanez on 10/8/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class AboutSectionUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // Proxy for application that can be launched and terminated.
        app = XCUIApplication()
        
        // App launch arguments allow us to mock the client response.
        app.launchArguments.append(Configuration.UITestArgument)
        
        // UI tests must launch the application that they test.
        app.launch()
    }
    
    func testAboutSectionExist() {
        app.tabBars.buttons["About"].tap()
        
        // Elements are found using their accessibility identifiers.
        let aboutTitleLabel = app.staticTexts[AboutAccessibilityIdentifier.Label.aboutTitleLabel]
        let aboutBodyLabel = app.staticTexts[AboutAccessibilityIdentifier.Label.aboutBodyLabel]
        let acknowledgementsTitleLabel = app.staticTexts[AboutAccessibilityIdentifier.Label.acknowledgementsTitleLabel]
        let acknowledgementsBodyLabel = app.staticTexts[AboutAccessibilityIdentifier.Label.acknowledgementsBodyLabel]
        let visitButton = app.buttons[AboutAccessibilityIdentifier.Button.visitButton]
        
        XCTAssertTrue(aboutTitleLabel.exists, "About title label should exitst.")
        XCTAssertTrue(aboutBodyLabel.exists, "About body label should exitst.")
        XCTAssertTrue(acknowledgementsTitleLabel.exists, "Acknowledgements title label should exitst.")
        XCTAssertTrue(acknowledgementsBodyLabel.exists, "Acknowledgements body label should exitst.")
        XCTAssertTrue(visitButton.exists, "Visit button should exitst.")
    }
}
