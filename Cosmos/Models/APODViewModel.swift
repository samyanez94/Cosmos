//
//  APODViewModel.swift
//  Cosmos
//
//  Created by Samuel Yanez on 12/23/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation

struct APODViewModel {
    let title: String
    let date: String
    let explanation: String
    var copyright: String?
        
    init(with apod: APOD) {
        let formatter = DateFormatter(locale: .current, format: "EEEE, MMM d")
        
        title = apod.title
        date = formatter.string(from: apod.date)
        explanation = apod.explanation
        
        if let author = apod.copyright {
            copyright = "Copyright: \(author)"
        }
    }
}
