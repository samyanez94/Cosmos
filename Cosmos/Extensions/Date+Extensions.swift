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
        if let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
            return Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
        }
        return false
    }
}
