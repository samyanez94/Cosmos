//
//  APODViewModel.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/15/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

struct APODViewModel {
    
    let apod: APOD
    
    init(apod: APOD) {
        self.apod = apod
    }
}

extension APODViewModel {
    var title: String {
         apod.title
     }
     
     var date: String {
         String(from: apod.date)
     }
         
     var explanation: String {
        apod.explanation.isEmpty ? DetailViewStrings.missingExplanation.localized : apod.explanation
     }
     
     var mediaType: APOD.MediaType {
         apod.mediaType
     }
     
     var preferredDate: String? {
         if apod.date.isToday() {
            return DetailViewStrings.today.localized
         } else if apod.date.isYesterday() {
            return DetailViewStrings.yesterday.localized
         } else {
             return nil
         }
     }
     
     var copyright: NSMutableAttributedString? {
         if let author = apod.copyright {
            return NSMutableAttributedString(string: String(format: DetailViewStrings.copyright.localized, author), blackString: "Copyright", font: .systemFont(ofSize: 20))
         }
         return nil
     }
     
     var url: URL? {
         apod.url
     }
}
