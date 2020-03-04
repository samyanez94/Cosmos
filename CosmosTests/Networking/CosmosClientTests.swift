//
//  CosmosClientTests.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 10/1/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class CosmosClientTests: XCTestCase {
    
    var session: APISession!
    
    var client: CosmosClient!
        
    var response: HTTPURLResponse! = HTTPURLResponse.dummy()
        
    var apod: Apod?
    
    var apods: [Apod]?
    
    var error: APIError?
        
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
        session = MockSession(data: ResourceType.single.data, response: response, error: nil)
        client = CosmosClient(session: session)

        let promise = expectation(description: "Fetch completed. 🚀")

        // When
        client.fetch { result in
            switch result {
            case .failure(let responseError):
                self.error = responseError
            case .success(let responseApod):
                self.apod = responseApod
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // Then
        XCTAssertNotNil(apod, "Response should not be nil")
    }

    func testSuccessfulDatedRequest() {
        // Given
        session = MockSession(data: ResourceType.single.data, response: response, error: nil)
        client = CosmosClient(session: session)

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
        XCTAssertNotNil(apod, "Response should not be nil")
    }

    func testSuccessfulRandomRequest() {
        // Given
        session = MockSession(data: ResourceType.ranged.data, response: response, error: nil)
        client = CosmosClient(session: session)

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
        XCTAssertNotNil(apods, "Response should not be nil")
    }

    func testSuccessfulRangedRequest() {
        // Given
        session = MockSession(data: ResourceType.ranged.data, response: response, error: nil)
        client = CosmosClient(session: session)

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
        XCTAssertNotNil(apods, "Response should not be nil")
    }
    
    func testSuccessfulListedRequest() {
        // Given
        session = MockSession(data: ResourceType.single.data, response: response, error: nil)
        client = CosmosClient(session: session)

        let promise = expectation(description: "Fetch completed. 🚀")

        // When
        client.fetch(dates: [Date()]) { result in
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
        XCTAssertNotNil(apods, "Response should not be nil")
    }

    func testFailedRequestWithError() {
        // Given
        session = MockSession(data: ResourceType.single.data, response: response, error: ClientError.error)
        client = CosmosClient(session: session)
        
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
        XCTAssertEqual(error, APIError.requestFailedWithError("Response unsuccessful"), "Errors should be equal.")
    }

    func testFailedRequest() {
        // Given
        session = MockSession(data: nil, response: URLResponse(), error: nil)
        client = CosmosClient(session: session)

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
        XCTAssertEqual(error, APIError.requestFailed, "Errors should be equal.")
    }

    func testFailedRangedRequest() {
        // Given
        session = MockSession(data: nil, response: URLResponse(), error: nil)
        client = CosmosClient(session: session)

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
        XCTAssertEqual(error, APIError.requestFailed, "Errors should be equal.")
    }
    
    func testFailedListedRequest() {
        // Given
        session = MockSession(data: ResourceType.invalid.data, response: response, error: nil)
        client = CosmosClient(session: session)

        let promise = expectation(description: "Fetch completed. 🚀")

        // When
        client.fetch(dates: [Date()]) { result in
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
        XCTAssertEqual(error, APIError.invalidData, "Errors should be equal.")
    }

    func testUnsuccessfulResponse() throws {
        // Given
        response = HTTPURLResponse.dummy(statusCode: 400)
        session = MockSession(data: nil, response: response, error: nil)
        client = CosmosClient(session: session)

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
        XCTAssertEqual(error, APIError.responseUnsuccessful, "Errors should be equal.")
    }

    func testInvalidData() throws {
        // Given
        session = MockSession(data: ResourceType.invalid.data, response: response, error: nil)
        client = CosmosClient(session: session)

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
        XCTAssertEqual(error, APIError.invalidData, "Errors should be equal.")
    }

    func testJsonParsingError() throws {
        // Given
        let data = "This is not the expected data.".data(using: .utf32)
        session = MockSession(data: data, response: response, error: nil)
         client = CosmosClient(session: session)

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
        XCTAssertEqual(error, APIError.jsonParsingFailure, "Errors should be equal.")
    }

    func testRangedJsonParsingError() throws {
        // Given
        let data = "This is not the expected data.".data(using: .utf32)
        session = MockSession(data: data, response: response, error: nil)
        client = CosmosClient(session: session)

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
        XCTAssertEqual(error, APIError.jsonParsingFailure, "Errors should be equal.")
    }
}

extension CosmosClientTests {
    
    enum ClientError: Error {
        case error
    }
    
    enum ResourceType {
        case single
        case ranged
        case invalid
        
        var path: String {
            switch self {
            case .single: return "single_response_success"
            case .ranged: return "ranged_response_success"
            case .invalid: return "invalid"
            }
        }
        
        var data: Data? {
            let bundle = Bundle(for: CosmosClientTests.self)
            guard let path = bundle.path(forResource: self.path, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
            return data
        }
    }
}
