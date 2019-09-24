//
//  Extensions.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/25/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit
import WebKit

extension DateFormatter {
    convenience init(locale: Locale, format: String) {
        self.init()
        self.locale = locale
        self.dateFormat = format
    }
}

extension JSONDecoder {
    convenience init(dateDecodingStrategy: DateDecodingStrategy) {
        self.init()
        self.dateDecodingStrategy = dateDecodingStrategy
    }
}

extension String {
    init(from date: Date) {
        self.init()
        self.write(DateFormatter(locale: .current, format: "EEEE, MMM d").string(from: date))
    }
}
