//
//  ApodViewModelTests.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 3/15/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import XCTest

class ApodViewModelTests: XCTestCase {
    
    var viewModel: ApodViewModel!
    
    var apod: Apod = .dummy()
    
    let formatter = DateFormatter(locale: .current, format: "yyyy-MM-dd")
    
    override func setUp() {
        super.setUp()
        viewModel = ApodViewModel(apod: apod)
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testTitle() {
        // Given
        apod = .dummy(title: "The Hydrogen Clouds of M33")
        
        // When
        viewModel = ApodViewModel(apod: apod)
        
        // Then
        XCTAssertEqual(viewModel.title, "The Hydrogen Clouds of M33")
    }
    
    func testDate() throws {
        // Given
        apod = .dummy(date: try XCTUnwrap(formatter.date(from: "2019-10-03")))
        
        // When
        viewModel = ApodViewModel(apod: apod)

        // Then
        XCTAssertEqual(viewModel.date, "Thursday, Oct 3")
    }
    
    func testExplanation() {
        // Given
        apod = .dummy(explanation: "Gorgeous spiral galaxy M33 seems to have more than its fair share of glowing hydrogen gas.")
        
        // When
        viewModel = ApodViewModel(apod: apod)

        // Then
        XCTAssertEqual(viewModel.explanation, "Gorgeous spiral galaxy M33 seems to have more than its fair share of glowing hydrogen gas.")
    }
    
    func testEmptyExplanation() {
        // Given
        apod = .dummy(explanation: "")
        
        // When
        viewModel = ApodViewModel(apod: apod)

        // Then
        XCTAssertEqual(viewModel.explanation, DetailViewStrings.missingExplanation.localized)
    }
    
    func testMediaType() {
        // Given
        apod = .dummy(mediaType: .image)
        
        // When
        viewModel = ApodViewModel(apod: apod)

        // Then
        XCTAssertEqual(viewModel.mediaType, .image)
    }
    
    func testPreferredNilDate() throws {
        // Given
        apod = .dummy(date: try XCTUnwrap(formatter.date(from: "2019-10-03")))
        
        // When
        viewModel = ApodViewModel(apod: apod)

        // Then
        XCTAssertNil(viewModel.preferredDate)
    }
    
    func testPreferredDateToday() throws {
        // Given
        apod = .dummy()
        
        // When
        viewModel = ApodViewModel(apod: apod)

        // Then
        XCTAssertEqual(viewModel.preferredDate, DetailViewStrings.today.localized)
    }
    
    func testNilCopyright() {
        XCTAssertNil(viewModel.copyright)
    }
    
    func testUrl() {
        // Given
        apod = .dummy(urlString: "https://apod.nasa.gov/apod/image/1910/M33-Subaru-Gendler-1024.jpg")
        
        // When
        viewModel = ApodViewModel(apod: apod)

        // Then
        XCTAssertEqual(viewModel.url?.absoluteString, "https://apod.nasa.gov/apod/image/1910/M33-Subaru-Gendler-1024.jpg")
    }
    
    func testImageThumbnailUrl() {
        // Given
        apod = .dummy(urlString: "https://apod.nasa.gov/apod/image/1910/M33-Subaru-Gendler-1024.jpg")
         
        // When
        viewModel = ApodViewModel(apod: apod)

        // Then
        XCTAssertEqual(viewModel.thumbnailUrl?.absoluteString, "https://apod.nasa.gov/apod/image/1910/M33-Subaru-Gendler-1024.jpg")
    }
    
    func testVideoThumbnailUrl() {
        // Given
        apod = .dummy(mediaType: .video, thumbnailUrlString: "https://img.youtube.com/vi/aMTwtb3TVIk/maxresdefault.jpg")
         
        // When
        viewModel = ApodViewModel(apod: apod)

        // Then
        XCTAssertEqual(viewModel.thumbnailUrl?.absoluteString, "https://img.youtube.com/vi/aMTwtb3TVIk/maxresdefault.jpg")
    }
    
    func testNilVideoThumbnailUrl() {
        // Given
        apod = .dummy(mediaType: .video)
         
        // When
        viewModel = ApodViewModel(apod: apod)

        // Then
        XCTAssertNil(viewModel.thumbnailUrl)
    }
}
