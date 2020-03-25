//
//  Date+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/21/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

extension Date {
    var isToday: Bool {
        Calendar.current.compare(self, to: Date(), toGranularity: .day) == .orderedSame
    }
    
    var isYesterday: Bool {
        guard let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            fatalError("Unable to calculate date by substracting 1 day to current date")
        }
        return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
    }
}
