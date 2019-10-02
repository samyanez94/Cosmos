//
//  CosmosClientTest.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 10/1/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class CosmosClientTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testSuccessfulResponse() {
        
        let client = MockClient()
        var apods: [APOD]?
        let promise = expectation(description: "Successful response.")
        
        client.fetch(count: 10) { result in
            switch result {
            case .failure:
                XCTFail("Error found.")
            case .success(let apodsFromResponse):
                apods = apodsFromResponse
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        XCTAssert(apods != nil)
    }
    
    func testSuccessfulResponsePerformance() {
        let client = MockClient()
        measure {
            client.fetch(count: 10)
        }
    }
}
