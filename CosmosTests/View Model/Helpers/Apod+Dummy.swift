//
//  Apod+Dummy.swift
//  CosmosTests
//
//  Created by Samuel Yanez on 3/15/20.
//  Copyright © 2020 Samuel Yanez. All rights reserved.
//

import Foundation

extension Apod {
    static func dummy(title: String = "title", date: Date = Date(), explanation: String = "explanation", mediaType: MediaType = .image, urlString: String = "url_string", copyright: String? = nil, thumbnailUrlString: String? = nil) -> Apod {
        Apod(title: title, date: date, explanation: explanation, mediaType: mediaType, urlString: urlString, copyright: copyright, thumbnailUrlString: thumbnailUrlString)
    }
}
