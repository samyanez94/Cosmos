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
        XCTAssertEqual(APIError.requestError.errorDescription, "Request error")
        XCTAssertEqual(APIError.invalidResponse.errorDescription, "Invalid response")
        XCTAssertEqual(APIError.invalidData.errorDescription, "Invalid data")
        XCTAssertEqual(APIError.responseUnsuccessful.errorDescription, "Response unsuccessful")
        XCTAssertEqual(APIError.jsonParsingError.errorDescription, "JSON parsing error")
    }
}
