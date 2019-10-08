//
//  SortedSetTests.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 10/5/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import XCTest

class SortedSetTests: XCTestCase {
    
    var set = SortedSet<String>()
    
    let collection = ["Sheep", "Reindeer", "Polar Bear", "Cat"]
    
    override func setUp() {
        set = SortedSet(withCollection: collection)
        
        super.setUp()
    }

    override func tearDown() {
        set = SortedSet(withCollection: collection)
        
        super.tearDown()
    }
    
    func testSetCount() {
        XCTAssertEqual(6, set.count, "Set should contain 4 elements.")
    }
    
    func testSetIsEmpty() {
        XCTAssertFalse(set.isEmpty, "Set should not be empty.")
    }
    
    func testSetContents() {
        XCTAssertEqual(collection, set.contents, "Contents should match.")
    }
    
    func testGetElement() {
        XCTAssertEqual("Sheep", set.element(at: 0), "Elements should match.")
    }
    
    func testContainsElement() {
        XCTAssertTrue(set.contains("Reindeer"), "Set should contain element.")
    }
    
    func testSetIsEquatable() {
        // Given
        let newSet = SortedSet(withCollection: ["Sheep", "Reindeer", "Polar Bear", "Cat"])
        
        // Then
        XCTAssertEqual(set, newSet, "Sets should match.")
    }
    
    func testSetIsNotEquatable() {
        // Given
        let newSet = SortedSet(withCollection: ["Reindeer", "Polar Bear", "Mouse", "Cat", "Alpaca"])
        
        // Then
        XCTAssertNotEqual(set, newSet, "Sets should not match.")
    }
    
    func testSetIsRandomAccessCollection() {
        XCTAssertEqual(set.startIndex, 0, "Indices should match.")
        XCTAssertEqual(set.endIndex, 4, "Indices should match.")
    }
    
    func testSetRemovesDuplicates() {
        // When
        set.append("Sheep")
        
        // Then
        XCTAssertEqual(4, set.count, "Set count should remain 4.")
    }
    
    func testSetRemainsSorted() {
        // When
        set.append(["Puma", "Ant", "Elephant", "Mice"])
        
        // Then
        XCTAssertEqual("Puma", set.element(at: 2), "Elements should match.")
    }
    
}
