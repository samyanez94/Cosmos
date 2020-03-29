//
//  Array+Extension.swift
//  Cosmos
//
//  Created by Samuel Yanez on 3/23/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

extension Range where Bound == Int {
    var middle: Int? {
        return isEmpty ? nil : lowerBound + count / 2
    }
}

extension Array where Element: Comparable {
    func insertionIndex(for newElement: Element) -> Index {
        return search(for: newElement)
    }
    
    private func search(for element: Element) -> Index {
        return search(for: element, in: startIndex ..< endIndex)
    }

    private func search(for element: Element, in range: Range<Index>) -> Index {
        guard let middle = range.middle else { return range.upperBound }
        if element > self[middle] {
            return search(for: element, in: index(after: middle)..<range.upperBound)
        } else if element < self[middle] {
            return search(for: element, in: range.lowerBound..<middle)
        }
        return middle
    }
}
