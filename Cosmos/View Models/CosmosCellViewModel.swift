//
//  CosmosCellViewModel.swift
//  Cosmos
//
//  Created by Samuel Yanez on 8/7/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

struct CosmosCellViewModel {
    
    let title: String
    let date: String
    let image: UIImage
}

extension CosmosCellViewModel {
    init(apod: APOD) {
        self.title = apod.title
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "EEEE, MMM d"
        
        self.date = formatter.string(from: apod.date)
        
        self.image = apod.image ?? #imageLiteral(resourceName: "Sample")
    }
}
