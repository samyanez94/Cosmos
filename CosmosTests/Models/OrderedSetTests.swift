//
//  OrderedSetTests.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/24/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import XCTest

class OrderedSetTests: XCTestCase {
    
    var set = OrderedSet<String>()
    
    let collection = ["Sheep", "Reindeer", "Polar Bear", "Cat"]
    
    override func setUp() {
        super.setUp()
        set = OrderedSet(fromCollection: collection)
    }
    
    func testSetCount() {
        XCTAssertEqual(4, set.count, "Set should contain 4 elements.")
    }
    
    func testSetIsEmpty() {
        XCTAssertFalse(set.isEmpty, "Set should not be empty.")
    }
    
    func testSetContents() {
        XCTAssertEqual(collection, set.elements, "Contents should match.")
    }
    
    func testGetElement() {
        XCTAssertEqual("Sheep", set.element(at: 0), "Elements should match.")
    }
    
    func testContainsElement() {
        XCTAssert(set.contains("Reindeer"), "Set should contain element.")
    }
    
    func testSetIsEquatable() {
        // Given
        let newSet = OrderedSet(fromCollection: ["Sheep", "Reindeer", "Polar Bear", "Cat"])
        
        // Then
        XCTAssertEqual(set, newSet, "Sets should match.")
    }
    
    func testSetIsNotEquatable() {
        // Given
        let newSet = OrderedSet(fromCollection: ["Reindeer", "Polar Bear", "Mouse", "Cat", "Alpaca"])
        
        // Then
        XCTAssertNotEqual(set, newSet, "Sets should not match.")
    }
    
    func testStartIndex() {
        XCTAssertEqual(set.startIndex, 0, "Indices should match.")
    }
    
    func testEndIndex() {
        XCTAssertEqual(set.endIndex, 4, "Indices should match.")
    }
    
    func testSetRemovesDuplicates() {
        // When
        set.append("Sheep")
        
        // Then
        XCTAssertEqual(4, set.count, "Set count should remain 4.")
    }
    
    func testSetRemainsOrdered() {
        // When
        set.append(contentsOf: ["Puma", "Ant", "Elephant", "Mice"])
        
        // Then
        XCTAssertEqual("Puma", set.element(at: 4), "Elements should match.")
    }
    
    func testSetRemovesElements() {
        // When
        set.remove("Polar Bear")
        
        // Then
        XCTAssertFalse(set.contains("Polar Bear"), "Set should not contain the element.")
    }
    
    func testSubscript() {
        XCTAssertEqual(set[0], "Sheep", "Elements should match.")
    }
}
