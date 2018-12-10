//
//  APOD.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

enum MediaType: String, Codable {
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

class APOD: Codable {
    
    let title: String
    let date: Date
    let explanation: String
    let mediaType: MediaType
    let copyright: String?
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case explanation
        case mediaType = "media_type"
        case copyright
        case url
    }
    
    init(title: String, date: Date, explanation: String, mediaType: MediaType, copyright: String?, url: String) {
        self.title = title
        self.date = date
        self.explanation = explanation
        self.mediaType = mediaType
        self.copyright = copyright
        self.url = url
    }
}

struct APODViewModel {
    let title: String
    let date: String
    let explanation: String
    var copyright: String?
}

extension APODViewModel {
    init(for apod: APOD) {
        let formatter = DateFormatter(locale: .current, format: "EEEE, MMM d")
        
        title = apod.title
        date = formatter.string(from: apod.date)
        explanation = apod.explanation
        
        if let author = apod.copyright {
            copyright = "Copyright: \(author)"
        }
    }
}
