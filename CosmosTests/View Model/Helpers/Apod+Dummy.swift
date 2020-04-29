//
//  Apod+Dummy.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 3/15/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

extension Apod {
    static func dummy(title: String = "title", date: Date = Date(), explanation: String = "explanation", mediaType: MediaType = .image, mediaURL: URL? = nil, copyright: String? = nil, thumbnailURL: URL? = nil) -> Apod {
        let mediaURL = mediaURL ?? URL(string: "https://apod.nasa.gov/apod")!
        return Apod(title: title, date: date, explanation: explanation, mediaType: mediaType, mediaURL: mediaURL, copyright: copyright, thumbnailURL: thumbnailURL)
    }
}
