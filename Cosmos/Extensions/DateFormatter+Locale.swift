//
//  DateFormatter+Locale.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/28/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(locale: Locale, format: String) {
        self.init()
        self.locale = locale
        self.dateFormat = format
    }
}
