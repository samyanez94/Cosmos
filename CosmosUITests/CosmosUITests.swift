//
//  CosmosUITests.swift
//  CosmosUITests
//
//  Created by Samuel Yanez on 10/8/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class CosmosUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test.
        app = XCUIApplication()
        app.launch()
    }
    
    func testTabBarExist() {
        XCTAssertTrue(app.tabBars.element.exists)
    }
    
    func testAboutSectionExist() {
        app.tabBars.buttons["About"].tap()
        
        // Elements are found using their accessibility identifiers.
        let aboutTitleLabel = app.staticTexts["AboutTitleLabel"]
        let aboutBodyLabel = app.staticTexts["AboutBodyLabel"]
        let acknowledgementsTitleLabel = app.staticTexts["AcknowledgementsTitleLabel"]
        let acknowledgementsBodyLabel = app.staticTexts["AcknowledgementsBodyLabel"]
        let visitButton = app.buttons["VisitButton"]
        
        XCTAssertTrue(aboutTitleLabel.exists)
        XCTAssertTrue(aboutBodyLabel.exists)
        XCTAssertTrue(acknowledgementsTitleLabel.exists)
        XCTAssertTrue(acknowledgementsBodyLabel.exists)
        XCTAssertTrue(visitButton.exists)
    }
    
    func testVisitButtonIsTappable() {
        app.tabBars.buttons["About"].tap()
        
        let visitButton = app.buttons["VisitButton"]
        
        XCTAssertTrue(visitButton.isHittable)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
