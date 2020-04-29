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
    let mediaURL: URL
    let copyright: String?
    let thumbnailURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case explanation
        case mediaType = "media_type"
        case mediaURL = "url"
        case copyright
        case thumbnailURL = "thumbnail_url"
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
