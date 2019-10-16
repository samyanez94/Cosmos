//
//  APODViewModel.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/15/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

class APODViewModel {
    
    private let apod: APOD
    
    /// Title
    var title: String {
        apod.title
    }
    
    /// Date
    var date: String {
        String(from: apod.date)
    }
    
    /// Explanation
    var explanation: String {
        apod.explanation.isEmpty ? "There is no description available for this media." : apod.explanation
    }
    
    /// Preferred Date
    var preferredDate: String? {
        if Calendar.current.compare(apod.date, to: Date(), toGranularity: .day) == .orderedSame {
            return "Today"
        } else if Calendar.current.compare(apod.date, to: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, toGranularity: .day) == .orderedSame {
            return "Yesterday"
        } else {
            return nil
        }
    }
    
    /// Copyright
    var copyright: NSAttributedString? {
        if let author = apod.copyright {
            return NSMutableAttributedString(string: "Copyright: \(author)", blackString: "Copyright:", font: scaledFont.font(forTextStyle: .body))
        } else {
            return nil
        }
    }
    
    /// Utility used for dynamic types
    private lazy var scaledFont: ScaledFont = {
         return ScaledFont()
     }()
    
    public init(apod: APOD) {
        self.apod = apod
    }
}
