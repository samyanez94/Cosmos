//
//  EnvironmentTests.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 10/15/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class EnvironmentTests: XCTestCase {
    
    var enviroment: Environment!

    override func setUp() {
        super.setUp()
        
        enviroment = Environment()
    }

    func testDescription() {
        XCTAssertEqual(enviroment.description, "Stage")
    }

}
