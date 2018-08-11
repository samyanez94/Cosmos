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
    let image: UIImage
}

extension APODViewModel {
    init(apod: APOD) {
        self.title = apod.title
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE, MMM d"
        
        self.date = formatter.string(from: apod.date)
        
        if let author = apod.copyright {
            self.copyright = "Copyright: \(author)"
        }
        
        self.explanation = apod.description
        
        self.image = apod.image ?? #imageLiteral(resourceName: "lunar-eclipse")
    }
}
