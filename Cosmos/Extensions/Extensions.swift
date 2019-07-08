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

//extension WKWebView {
//    override open var safeAreaInsets: UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//}
