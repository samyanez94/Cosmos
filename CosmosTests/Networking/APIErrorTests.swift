//
//  APIErrorTests.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 1/19/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import XCTest

class APIErrorTests: XCTestCase {
    func testErrorDescription() {
        XCTAssertEqual(APIError.incorrectParameters.errorDescription, "Incorrect parameters for request")
        XCTAssertEqual(APIError.requestFailedWithError("🎃").errorDescription, "Request failed with error: 🎃")
        XCTAssertEqual(APIError.requestFailed.errorDescription, "Request failed")
        XCTAssertEqual(APIError.invalidData.errorDescription, "Invalid data")
        XCTAssertEqual(APIError.responseUnsuccessful.errorDescription, "Response unsuccessful")
        XCTAssertEqual(APIError.jsonParsingFailure.errorDescription, "JSON parsing failure")
    }

}
