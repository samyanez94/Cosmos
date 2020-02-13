//
//  APOD.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

struct APOD: Codable {
    let title: String
    let date: Date
    let explanation: String
    let mediaType: MediaType
    let urlString: String
    let copyright: String?
    let thumbnailUrlString: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case explanation
        case mediaType = "media_type"
        case urlString = "url"
        case copyright
        case thumbnailUrlString = "thumbnail_url"
    }
    
    enum MediaType: String, Codable {
        case image
        case video
    }
}

extension APOD: Equatable {
    static func == (lhs: APOD, rhs: APOD) -> Bool {
        lhs.date == rhs.date
    }
}

extension APOD: Comparable {
    static func < (lhs: APOD, rhs: APOD) -> Bool {
        lhs.date < rhs.date
    }
}

extension APOD: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(date.hashValue)
    }
}
