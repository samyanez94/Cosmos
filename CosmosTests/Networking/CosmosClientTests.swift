//
//  CosmosClientTests.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 10/1/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class CosmosClientTests: XCTestCase {
    
    // Mock client
    var client: MockClient!
    
    // APOD for single response
    var apod: APOD?
    
    // APODs for ranged response
    var apods: [APOD]?
    
    // Error from response
    var error: APIError?
    
    // URL used in the request
    var url: URL? {
        URL(string: "https://cosmos-app-staging.herokuapp.com")
    }
        
    // Mock error
    enum MockError: Error {
        case mockError
    }
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        client = nil
        apod = nil
        apods = nil
        error = nil
        
        super.tearDown()
    }
    
    func testSuccessfulRequest() {
        // Given
        client = MockClient(withResource: "apod-single-response", ofType: "json")
                
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
        client.fetch { result in
            switch result {
            case .failure(let errorFromResponse):
                self.error = errorFromResponse
            case .success(let apodFromResponse):
                self.apod = apodFromResponse
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertNil(error, "Error should be nil.")
        XCTAssertNotNil(apod, "Response should not be nil. 😱")
    }
    
    func testSuccessfulDatedRequest() {
        // Given
        client = MockClient(withResource: "apod-single-response", ofType: "json")
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
        client.fetch(date: Date()) { result in
            switch result {
            case .failure(let errorFromResponse):
                self.error = errorFromResponse
            case .success(let apodFromResponse):
                self.apod = apodFromResponse
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertNil(error, "Error should be nil.")
        XCTAssertNotNil(apod, "Response should not be nil. 😱")
    }
    
    func testSuccessfulRandomRequest() {
        // Given
        client = MockClient(withResource: "apod-ranged-response", ofType: "json")
        
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
        XCTAssertNil(error, "Error should be nil.")
        XCTAssertNotNil(apods, "Response should not be nil. 😱")
    }
    
    func testSuccessfulRangedRequest() {
        // Given
        client = MockClient(withResource: "apod-ranged-response", ofType: "json")
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
        client.fetch(count: 10, offset: 0) { result in
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
        XCTAssertNil(error, "Error should be nil.")
        XCTAssertNotNil(apods, "Response should not be nil. 😱")
    }
    
    func testFailedRequestWithError() {
        // Given
        let clientError = MockError.mockError
        
        client = MockClient(data: nil, response: nil, error: clientError)
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
         client.fetch { result in
             switch result {
             case .failure(let errorFromResponse):
                self.error = errorFromResponse
             case .success(let apodFromResponse):
                self.apod = apodFromResponse
             }
             promise.fulfill()
         }
         wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.requestFailedWithError("Response unsuccessful"), "Request should fail.")
        XCTAssertNil(apod, "Response should be nil.")
    }
    
    func testFailedRequest() {
        // Given
        let response = URLResponse()
        client = MockClient(data: nil, response: response, error: nil)
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
         client.fetch { result in
             switch result {
             case .failure(let errorFromResponse):
                self.error = errorFromResponse
             case .success(let apodFromResponse):
                self.apod = apodFromResponse
             }
             promise.fulfill()
         }
         wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.requestFailed, "Request should fail.")
        XCTAssertNil(apod, "Response should be nil.")
    }
    
    func testFailedRangedRequest() {
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
        XCTAssertNil(apods, "Response should be nil.")
    }
    
    func testUnsuccessfulResponse() throws {
        // Given
        let url = try require(self.url)
        let response = HTTPURLResponse(url: url, statusCode: 400, httpVersion: nil, headerFields: nil)
        client = MockClient(data: nil, response: response, error: nil)
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
         client.fetch { result in
             switch result {
             case .failure(let errorFromResponse):
                self.error = errorFromResponse
             case .success(let apodFromResponse):
                self.apod = apodFromResponse
             }
             promise.fulfill()
         }
         wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.responseUnsuccessful, "Request should fail.")
        XCTAssertNil(apod, "Response should be nil.")
    }
    
    func testInvalidData() throws {
        // Given
        let url = try require(self.url)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        client = MockClient(data: nil, response: response, error: nil)
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
         client.fetch { result in
             switch result {
             case .failure(let errorFromResponse):
                self.error = errorFromResponse
             case .success(let apodFromResponse):
                self.apod = apodFromResponse
             }
             promise.fulfill()
         }
         wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.invalidData, "Request should fail.")
        XCTAssertNil(apod, "Response should be nil.")
    }
    
    func testJsonParsingError() throws {
        // Given
        let url = try require(self.url)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let data = "This is not the expected data.".data(using: .utf32)
        client = MockClient(data: data, response: response, error: nil)
        
        let promise = expectation(description: "Fetch completed. 🚀")
        
        // When
         client.fetch { result in
             switch result {
             case .failure(let errorFromResponse):
                self.error = errorFromResponse
             case .success(let apodFromResponse):
                self.apod = apodFromResponse
             }
             promise.fulfill()
         }
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.jsonParsingFailure, "Request should fail.")
        XCTAssertNil(apod, "Response should be nil.")
    }
    
    func testRangedJsonParsingError() throws {
        // Given
        let url = try require(self.url)
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
        XCTAssertNil(apods, "Response should be nil.")
    }
    
    func testIncorrectResourceForMockClient() {
        // Given
        client = MockClient(withResource: "wrong-resource", ofType: ".json")
        
        let promise = expectation(description: "Fetch completed. 🚀")

        // When
        client.fetch { result in
            switch result {
            case .failure(let errorFromResponse):
                self.error = errorFromResponse
            case .success(let apodFromResponse):
                self.apod = apodFromResponse
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertEqual(error, APIError.requestFailed, "Request should fail.")
        XCTAssertNil(apod, "Response should be nil.")
    }
    
    func testSuccessfulResponsePerformance() {
        let client = MockClient(withResource: "apod-single-response", ofType: "json")
        measure {
            client.fetch()
        }
    }
}
