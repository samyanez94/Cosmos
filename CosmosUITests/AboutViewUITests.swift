//
//  AboutViewUITests.swift
//  CosmosUITests
//
//  Created by Samuel Yanez on 10/8/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class AboutViewUITests: XCTestCase {
    
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
    
    func testElementsExist() {
        app.tabBars.buttons["About"].tap()
        
        // Elements are found using their accessibility identifiers.
        let aboutTitleLabel = app.staticTexts[AboutViewAccessibilityIdentifier.Label.aboutTitleLabel]
        let aboutBodyLabel = app.staticTexts[AboutViewAccessibilityIdentifier.Label.aboutBodyLabel]
        let acknowledgementsTitleLabel = app.staticTexts[AboutViewAccessibilityIdentifier.Label.acknowledgementsTitleLabel]
        let acknowledgementsBodyLabel = app.staticTexts[AboutViewAccessibilityIdentifier.Label.acknowledgementsBodyLabel]
        let visitButton = app.buttons[AboutViewAccessibilityIdentifier.Button.visitButton]
        let versionLabel = app.staticTexts[AboutViewAccessibilityIdentifier.Label.versionLabel]
        
        // Assert that elements exists.
        XCTAssertTrue(aboutTitleLabel.exists, "About title label should exist.")
        XCTAssertTrue(aboutBodyLabel.exists, "About body label should exist.")
        XCTAssertTrue(acknowledgementsTitleLabel.exists, "Acknowledgements title label should exist.")
        XCTAssertTrue(acknowledgementsBodyLabel.exists, "Acknowledgements body label should exist.")
        XCTAssertTrue(visitButton.exists, "Visit button should exist.")
        XCTAssert(versionLabel.exists, "Version label should exist")
        
        // Check element is hittable.
        XCTAssert(visitButton.isHittable, "Visit button should be hittable.")
    }
    
    func testTapOnVisitButton() {
        app.tabBars.buttons["About"].tap()
        
        app.swipeUp()
        
        app.buttons[AboutViewAccessibilityIdentifier.Button.visitButton].tap()
    }
}
