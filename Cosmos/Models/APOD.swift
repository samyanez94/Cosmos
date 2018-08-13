//
//  APOD.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

enum MediaType {
    case image
    case video
    
    init?(type: String) {
        switch type {
        case "image": self = .image
        case "video": self = .video
        default: return nil
        }
    }
}

class APOD {
    
    let title: String
    let date: Date
    let explanation: String
    let mediaType: MediaType
    let copyright: String?
    var image: UIImage?
    var url: String
    
    init(title: String, date: Date, explanation: String, mediaType: MediaType, copyright: String?, url: String) {
        self.title = title
        self.date = date
        self.explanation = explanation
        self.mediaType = mediaType
        self.copyright = copyright
        self.url = url
    }
    
    convenience init?(title: String, date: String, explanation: String, mediaType: String, copyright: String?, url: String) {
        
        let formatter = DateFormatter(locale: .current, format: "yyyy-MM-dd")
        
        guard let date = formatter.date(from: date) else { return nil}
        guard let mediaType = MediaType(type: mediaType) else { return nil }
        
        self.init(title: title, date: date, explanation: explanation, mediaType: mediaType, copyright: copyright, url: url)
    }
}

extension APOD {
    convenience init?(json: [String: Any]) {
        
        struct key {
            static let title = "title"
            static let date = "date"
            static let explanation = "explanation"
            static let mediaType = "media_type"
            static let copyright = "copyright"
            static let url = "url"
        }
        
        guard let title = json[key.title] as? String,
            let dateString = json[key.date] as? String,
            let explanation = json[key.explanation] as? String,
            let mediaTypeString = json[key.mediaType] as? String,
            let copyright = json[key.copyright] as? String?,
            let url = json[key.url] as? String else { return  nil }

        self.init(title: title, date: dateString, explanation: explanation, mediaType: mediaTypeString, copyright: copyright, url: url)
    }
}

extension DateFormatter {
    convenience init(locale: Locale, format: String) {
        self.init()
        self.locale = locale
        self.dateFormat = format
    }
}
