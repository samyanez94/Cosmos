//
//  OrderedSet.swift
//  Cosmos
//
//  Created by Samuel Yanez on 9/7/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

public struct OrderedSet<E>: Collection where E: Hashable, E: Comparable {
    public typealias Element = E
    public typealias Index = Int
    public typealias Indices = CountableRange<Int>

    private var array: [Element]
    
    private var set: Set<Element>

    public init() {
        self.array = []
        self.set = Set()
    }
    
    public init(withCollection collection: [Element]) {
        self.array = []
        self.set = Set()
        self.append(collection)
    }
    
    public var count: Int {
        array.count
    }

    public var isEmpty: Bool {
        array.isEmpty
    }

    public var contents: [Element] {
        array
    }
    
    public func element(at index: Int) -> Element {
        array[index]
    }

    public func contains(_ element: Element) -> Bool {
        set.contains(element)
    }

    public mutating func append(_ element: Element) {
        if set.insert(element).inserted {
            array.append(element)
        }
    }
    
    public mutating func append(_ collection: [Element]) {
        for element in collection {
            append(element)
        }
    }
    
    @discardableResult public mutating func remove(_ element: Element) -> Element? {
        if let element = set.remove(element) {
            array.removeAll { $0 == element }
            return element
        }
        return nil
    }
}

extension OrderedSet: Equatable {
    static public func == <T>(lhs: OrderedSet<T>, rhs: OrderedSet<T>) -> Bool {
        return lhs.contents == rhs.contents
    }
}

extension OrderedSet: RandomAccessCollection {
    public var startIndex: Int {
        contents.startIndex
    }
    
    public var endIndex: Int {
        contents.endIndex
    }
    
    public subscript(index: Int) -> Element {
        contents[index]
    }
}
