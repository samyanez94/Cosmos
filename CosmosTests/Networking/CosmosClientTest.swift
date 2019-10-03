//
//  CosmosClientTest.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 10/1/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class CosmosClientTest: XCTestCase {
    
    // Mock error
    enum MockError: Error {
        case mockError
    }
    
    // Mock client
    var client: MockClient!
    
    // APODs from response
    var apods: [APOD]?
    
    // Error from response
    var error: APIError?
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        client = nil
        apods = nil
        error = nil
        
        super.tearDown()
    }
    
    func testSuccessfulResponse() {
        
        // Given
        client = MockClient()
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
        client.fetch(count: 10) { result in
            switch result {
            case .failure(let errorFromResponse):
                self.error = errorFromResponse
            case .success(let apodsFromResponse):
                self.apods = apodsFromResponse
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssert(error == nil, "Error should be nil.")
        XCTAssert(apods != nil, "Response should not be nil. 😱")
    }
    
    func testFailedRequestWithError() {
        
        // Given
        let mockError = MockError.mockError
        client = MockClient(data: nil, response: nil, error: mockError)
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
         client.fetch(count: 10) { result in
             switch result {
             case .failure(let errorFromResponse):
                self.error = errorFromResponse
             case .success(let apodsFromResponse):
                self.apods = apodsFromResponse
             }
             promise.fulfill()
         }
         wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.requestFailedWithError("Response unsuccessful"), "Request should fail.")
        XCTAssert(apods == nil, "Response should be nil.")
    }
    
    func testFailedRequest() {
        
        // Given
        let response = URLResponse()
        client = MockClient(data: nil, response: response, error: nil)
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
         client.fetch(count: 10) { result in
             switch result {
             case .failure(let errorFromResponse):
                self.error = errorFromResponse
             case .success(let apodsFromResponse):
                self.apods = apodsFromResponse
             }
             promise.fulfill()
         }
         wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.requestFailed, "Request should fail.")
        XCTAssert(apods == nil, "Response should be nil.")
    }
    
    func testUnsuccessfulResponse() throws {
        
        // Given
        let url = try require(URL(string: "https://cosmos-app-staging.herokuapp.com"))
        let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        client = MockClient(data: nil, response: response, error: nil)
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
         client.fetch(count: 10) { result in
             switch result {
             case .failure(let errorFromResponse):
                self.error = errorFromResponse
             case .success(let apodsFromResponse):
                self.apods = apodsFromResponse
             }
             promise.fulfill()
         }
         wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.responseUnsuccessful, "Request should fail.")
        XCTAssert(apods == nil, "Response should be nil.")
    }
    
    func testInvalidData() throws {
        
        // Given
        let url = try require(URL(string: "https://cosmos-app-staging.herokuapp.com"))
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        client = MockClient(data: nil, response: response, error: nil)
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
         client.fetch(count: 10) { result in
             switch result {
             case .failure(let errorFromResponse):
                self.error = errorFromResponse
             case .success(let apodsFromResponse):
                self.apods = apodsFromResponse
             }
             promise.fulfill()
         }
         wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.invalidData, "Request should fail.")
        XCTAssert(apods == nil, "Response should be nil.")
    }
    
    func testJsonParsingError() throws {
        
        // Given
        let url = try require(URL(string: "https://cosmos-app-staging.herokuapp.com"))
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = "This is not the expected data.".data(using: .utf32)
        client = MockClient(data: data, response: response, error: nil)
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
         client.fetch(count: 10) { result in
             switch result {
             case .failure(let errorFromResponse):
                self.error = errorFromResponse
             case .success(let apodsFromResponse):
                self.apods = apodsFromResponse
             }
             promise.fulfill()
         }
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.jsonParsingFailure, "Request should fail.")
        XCTAssert(apods == nil, "Response should be nil.")
    }
    
    func testSuccessfulResponsePerformance() {
        let client = MockClient()
        measure {
            client.fetch(count: 10)
        }
    }
}
