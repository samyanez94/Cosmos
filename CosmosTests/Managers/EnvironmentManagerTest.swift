//
//  EnvironmentManagerTests.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 10/15/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class EnvironmentManagerTests: XCTestCase {
    
    var enviromentManager: EnvironmentManager!

    override func setUp() {
        super.setUp()
        enviromentManager = EnvironmentManager()
    }

    func testEnvironmentName() {
        XCTAssertEqual(enviromentManager.environment.name, "Debug")
    }
    
    func testEnvironmentUrl() {
        XCTAssertEqual(enviromentManager.environment.url, "https://cosmos-app-staging.herokuapp.com")
    }
}
