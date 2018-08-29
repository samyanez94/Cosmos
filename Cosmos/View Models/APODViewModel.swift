//
//  CosmosCellViewModel.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/7/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

struct APODViewModel {
    let title: String
    let date: String
    let explanation: String
    var copyright: String?
}

extension APODViewModel {
    init(apod: APOD) {
        let formatter = DateFormatter(locale: .current, format: "EEEE, MMM d")
        
        self.title = apod.title
        self.date = formatter.string(from: apod.date)
        self.explanation = apod.explanation

        if let author = apod.copyright {
            self.copyright = "Copyright: \(author)"
        }
        

    }
}
