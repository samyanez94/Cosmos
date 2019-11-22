//
//  DiscoverViewUITests.swift
//  CosmosUITests
//
//  Created by Samuel Yanez on 10/13/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class DiscoverViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // Proxy app that can be launched and terminated.
        app = XCUIApplication()
        
        // App launch arguments allow us to mock the client response.
        app.launchArguments.append(Configuration.UITestArgument)
        
        // UI tests must launch the application that they test.
        app.launch()
    }
    
    func testElementsExist() {
        // Get the first element.
        let cell = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        
        // Assert element exists.
        XCTAssertTrue(cell.exists, "At least one cell should exist.")
        
        // Assert element is hittable.
        XCTAssertTrue(cell.isHittable, "Cell should be hittable.")
    }
    
    func testTapOnTapBar() {
        // Swipe up.
        app.swipeUp()
        
        // Test tab on tab bar.
        app.tabBars.buttons["Discover"].tap()
    }
    
    func testLongPressOnCell() {
        // Get the first element.
        let cell = app.collectionViews.children(matching: .cell).element(boundBy: 0)
        
        // Test long press on cell.
        cell.press(forDuration: 2)
    }
}
