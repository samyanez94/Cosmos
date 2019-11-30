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
        
        // Proxy app that can be launched and terminated.
        app = XCUIApplication()
        
        // App launch arguments allow us to mock the client response.
        app.launchArguments.append(Configuration.UITestArgument)
        
        // UI tests must launch the application that they test.
        app.launch()
        
        // Add UI interruption handler.
        addUIInterruptionMonitor(withDescription: "Save to Photos Permission Dialog") { alert -> Bool in
          if alert.labelContains(text: "“Cosmos” Would Like to Add to your Photos") {
            alert.buttons["OK"].tap()
            return true
          }
          return false
        }
        
        // Irrelevant tap to trigger the interruption handler.
        app.tabBars.buttons["Discover"].tap()
    }
    
    func testElementsExist() {
        // Tap on the first cell.
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        
        // Elements are found using their accessibility identifiers.
        let imageView = app.images[DetailViewAccessibilityIdentifier.Image.imageView]
        let favoritesButton = app.images[DetailViewAccessibilityIdentifier.Button.favoritesButton]
        let shareButton = app.images[DetailViewAccessibilityIdentifier.Button.shareButton]
        let saveToPhotosButton = app.images[DetailViewAccessibilityIdentifier.Button.saveToPhotosButton]
        let dateLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.dateLabel]
        let titleLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.titleLabel]
        let explanationLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.explanationLabel]
        
        // Assert elements exists.
        XCTAssert(imageView.exists, "Image should exist.")
        XCTAssert(favoritesButton.exists, "Favorites button should exist.")
        XCTAssert(shareButton.exists, "Share button should exist.")
        XCTAssert(saveToPhotosButton.exists, "Save to photos button should exist.")
        XCTAssert(dateLabel.exists, "Date label should exist.")
        XCTAssert(titleLabel.exists, "Title label should exist.")
        XCTAssert(explanationLabel.exists, "Explanation label should exist.")
        
        // Swipe up to reveal more elements.
        app.swipeUp()
        
        // Elements are found using their accessibility identifiers.
        let copyrightLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.copyrightLabel]
        
        // Assert that elements exists.
        XCTAssert(copyrightLabel.exists, "Copyright should exist.")
    }
    
    func testElementsExistForVideo() {
        // Swipe up once.
        app.swipeUp()
        
        // Tap on the third cell.
         app.collectionViews.children(matching: .cell).element(boundBy: 1).tap()
        
        // Elements are found using their accessibility identifiers.
        let webView = app.webViews[DetailViewAccessibilityIdentifier.WebView.webView]
        let favoritesButton = app.images[DetailViewAccessibilityIdentifier.Button.favoritesButton]
        let shareButton = app.images[DetailViewAccessibilityIdentifier.Button.shareButton]
        let dateLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.dateLabel]
        let titleLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.titleLabel]
        let explanationLabel = app.staticTexts[DetailViewAccessibilityIdentifier.Label.explanationLabel]
        
        // Assert elements exists.
        XCTAssert(webView.exists, "Web view should exist.")
        XCTAssert(favoritesButton.exists, "Favorites button should exist.")
        XCTAssert(shareButton.exists, "Share button should exist.")
        XCTAssert(dateLabel.exists, "Date label should exist.")
        XCTAssert(titleLabel.exists, "Title label should exist.")
        XCTAssert(explanationLabel.exists, "Explanation label should exist.")
        
        // Check element is hittable.
        XCTAssert(favoritesButton.isHittable, "Favorites button should be hittable.")
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
    
    func testTapOnFavorites() {
        // Tap on the first cell.
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        
        // Elements are found using their accessibility identifiers.
        let favoritesButton = app.images[DetailViewAccessibilityIdentifier.Button.favoritesButton]
        
        // Tap on share.
        favoritesButton.tap()
    }
    
    func testTapOnShare() {
        // Tap on the first cell.
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        
        // Elements are found using their accessibility identifiers.
        let shareButton = app.images[DetailViewAccessibilityIdentifier.Button.shareButton]
        
        // Tap on share.
        shareButton.tap()
    }
    
    func testTapOnSavetoPhotos() {
        // Tap on the first cell.
        app.collectionViews.children(matching: .cell).element(boundBy: 0).tap()
        
        // Elements are found using their accessibility identifiers.
        let saveToPhotosButton = app.images[DetailViewAccessibilityIdentifier.Button.saveToPhotosButton]
        
        // Tap on share.
        saveToPhotosButton.tap()
    }
}

extension XCUIElement {
  func labelContains(text: String) -> Bool {
    let predicate = NSPredicate(format: "label CONTAINS %@", text)
    return staticTexts.matching(predicate).firstMatch.exists
  }
}
