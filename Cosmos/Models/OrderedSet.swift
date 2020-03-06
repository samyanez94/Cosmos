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

    private(set) var elements: [Element]
    
    private var set: Set<Element>

    public init() {
        self.elements = []
        self.set = Set()
    }
    
    public init(fromCollection collection: [Element]) {
        self.elements = []
        self.set = Set()
        self.append(collection)
    }
    
    public var count: Int {
        elements.count
    }

    public var isEmpty: Bool {
        elements.isEmpty
    }
    
    public func element(at index: Int) -> Element {
        elements[index]
    }

    public func contains(_ element: Element) -> Bool {
        set.contains(element)
    }

    public mutating func append(_ element: Element) {
        if set.insert(element).inserted {
            elements.append(element)
        }
    }
    
    public mutating func append(_ collection: [Element]) {
        for element in collection {
            append(element)
        }
    }
    
    @discardableResult public mutating func remove(_ element: Element) -> Element? {
        if let element = set.remove(element) {
            elements.removeAll { $0 == element }
            return element
        }
        return nil
    }
    
    @discardableResult public mutating func removeAt(_ index: Int) -> Element? {
        let element = elements.remove(at: index)
        set.remove(element)
        return element
        
    }
}

extension OrderedSet: Equatable {
    static public func == <T>(lhs: OrderedSet<T>, rhs: OrderedSet<T>) -> Bool {
        return lhs.elements == rhs.elements
    }
}

extension OrderedSet: RandomAccessCollection {
    public var startIndex: Int {
        elements.startIndex
    }
    
    public var endIndex: Int {
        elements.endIndex
    }
    
    public subscript(index: Int) -> Element {
        elements[index]
    }
}
