//
//  String+Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/5/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

extension String {
    init(from date: Date) {
        self.init()
        self.write(DateFormatter(locale: .current, format: "EEEE, MMM d").string(from: date))
    }
}
