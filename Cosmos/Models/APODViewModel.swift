//
//  APODViewModel.swift
//  Cosmos
//
//  Created by Samuel Yanez on 12/23/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

struct APODViewModel {
    let title: String
    let date: String
    let preferredDate: String?
    let explanation: String
    var copyright: String?
        
    init(with apod: APOD) {
        title = apod.title
        date = String(from: apod.date)
        preferredDate = APODViewModel.preferredDate(for: apod)
        
        explanation = apod.explanation.isEmpty ? "There is no description available for this media." : apod.explanation
        
        if let author = apod.copyright {
            copyright = "Copyright: \(author)"
        }
    }
    
    private static func preferredDate(for apod: APOD) -> String? {
        if Calendar.current.compare(apod.date, to: Date(), toGranularity: .day) == .orderedSame {
            return "Today"
        } else if Calendar.current.compare(apod.date, to: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, toGranularity: .day) == .orderedSame {
            return "Yesterday"
        } else {
            return nil
        }
    }
}
