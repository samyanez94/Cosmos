//
//  APOD.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

class APOD: Codable {
    
    let title: String
    let date: Date
    let explanation: String
    let mediaType: MediaType
    let copyright: String?
    let url: String
    let thumbnailUrl: String?
    
    var dateString: String {
        String(from: date)
    }
    
    var preferredDateString: String? {
        preferredDate()
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case explanation
        case mediaType = "media_type"
        case copyright
        case url
        case thumbnailUrl = "thumbnail_url"
    }
    
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
    
    private func preferredDate() -> String? {
        if Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame {
            return "Today"
        } else if Calendar.current.compare(date, to: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, toGranularity: .day) == .orderedSame {
            return "Yesterday"
        } else {
            return nil
        }
    }
}

extension APOD: Equatable {
    static func == (lhs: APOD, rhs: APOD) -> Bool {
        return lhs.date == rhs.date
    }
}

extension APOD: Comparable {
    static func < (lhs: APOD, rhs: APOD) -> Bool {
        return lhs.date < rhs.date
    }
}

extension APOD: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(date.hashValue)
    }
}
