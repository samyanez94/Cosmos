//
//  APOD.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

class APOD: Codable {
    var id: String {
        return UUID().uuidString
    }
    
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
}
