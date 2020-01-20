//
//  EnvironmentTests.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 10/15/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class EnvironmentTests: XCTestCase {
    
    var enviromentManager: EnvironmentManager!

    override func setUp() {
        super.setUp()
        
        enviromentManager = EnvironmentManager()
    }

    func testDescription() {
        XCTAssertEqual(enviromentManager.description, "Stage")
    }

}
