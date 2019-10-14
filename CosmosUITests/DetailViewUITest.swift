//
//  DetailViewUITest.swift
//  CosmosUITests
//
//  Created by Samuel Yanez on 10/13/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class DetailViewUITest: XCTestCase {

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
        // Tap on the first cell.
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        
        // Elements are found using their accessibility identifiers.
        let imageView = app.images[DetailViewAccessibilityIdentifier.Image.imageView]
        let dateLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.dateLabel]
        let titleLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.titleLabel]
        let explanationLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.explanationLabel]
        
        // Assert elements exists.
        XCTAssert(imageView.exists, "Image should exist.")
        XCTAssert(dateLabel.exists, "Date label should exist.")
        XCTAssert(titleLabel.exists, "Title label should exist.")
        XCTAssert(explanationLabel.exists, "Explanation label should exist.")
        
        // Swipe up to reveal more elements.
        app.swipeUp()
        
        // Elements are found using their accessibility identifiers.
        let copyrightLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.copyrightLabel]
        let shareButton = app.buttons[DetailViewAccessibilityIdentifier.Button.shareButton]
        
        // Assert that elements exists.
        XCTAssert(copyrightLabel.exists, "Copyright should exist.")
        XCTAssert(shareButton.exists, "Share button should exist.")
        
        // Check element is hittable.
        XCTAssert(shareButton.isHittable, "Share button should be hittable.")
    }
    
    func testTapOnImage() {
        // Tap on the first cell.
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        
        // Elements are found using their accessibility identifiers.
        let imageView = app.images[DetailViewAccessibilityIdentifier.Image.imageView]
        
        // Tap on image.
        imageView.tap()
        
        // Tap on close button.
        app.buttons["xmark.circle"].tap()
    }
    
    func testTapOnShare() {
        // Tap on the first cell.
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        
        // Swipe up to reveal more elements.
        app.swipeUp()
        
        // Elements are found using their accessibility identifiers.
        let shareButton = app.buttons[DetailViewAccessibilityIdentifier.Button.shareButton]
        
        // Tap on share.
        shareButton.tap()
    }
}
