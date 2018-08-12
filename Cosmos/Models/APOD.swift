//
//  APOD.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

class APOD {
    
    let title: String
    let date: Date
    let explanation: String
    let copyright: String?
    let url: String
    var image: UIImage?
    var imageState = APODImageState.placeholder
    
    init(title: String, date: Date, description: String, copyright: String?, url: String) {
        self.title = title
        self.date = date
        self.explanation = description
        self.copyright = copyright
        self.url = url
    }
}

extension APOD {
    convenience init?(json: [String: Any]) {
        
        struct key {
            static let title = "title"
            static let date = "date"
            static let description = "explanation"
            static let copyright = "copyright"
            static let url = "url"
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let title = json[key.title] as? String,
            let dateString = json[key.date] as? String,
            let date = formatter.date(from: dateString),
            let description = json[key.description] as? String,
            let copyright = json[key.copyright] as? String?,
            let url = json[key.url] as? String else { return  nil }
        
        self.init(title: title, date: date, description: description, copyright: copyright, url: url)
    }
}

enum APODImageState {
    case placeholder
    case downloaded
    case failed
}
