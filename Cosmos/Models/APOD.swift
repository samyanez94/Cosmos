//
//  Apod.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

struct Apod: Codable {
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

extension Apod: Equatable {
    static func == (lhs: Apod, rhs: Apod) -> Bool {
        lhs.date == rhs.date
    }
}

extension Apod: Comparable {
    static func < (lhs: Apod, rhs: Apod) -> Bool {
        lhs.date < rhs.date
    }
}

extension Apod: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(date.hashValue)
    }
}
