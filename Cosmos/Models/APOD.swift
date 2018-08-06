//
//  APOD.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

struct APOD {
    
    let title: String
    let date: Date
    let description: String
    let url: String
    let hdUrl: String
    
    var prettyDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
}

extension APOD {
    init?(json: [String: Any]) {
        
        struct key {
            static let title = "title"
            static let date = "date"
            static let description = "explanation"
            static let url = "url"
            static let hdUrl = "hdurl"
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let title = json[key.title] as? String,
            let dateString = json[key.date] as? String,
            let date = formatter.date(from: dateString),
            let description = json[key.description] as? String,
            let url = json[key.url] as? String,
            let hdUrl = json[key.hdUrl] as? String else { return  nil }
        
        self.init(title: title, date: date, description: description, url: url, hdUrl: hdUrl)
    }
}
