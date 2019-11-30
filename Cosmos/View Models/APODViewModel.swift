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
         apod.explanation.isEmpty ? "There is no description available for this media." : apod.explanation
     }
     
     var mediaType: APOD.MediaType {
         apod.mediaType
     }
     
     var preferredDate: String? {
         if apod.date.isToday() {
             return "Today"
         } else if apod.date.isYesterday() {
             return "Yesterday"
         } else {
             return nil
         }
     }
     
     var copyright: String? {
         if let author = apod.copyright {
             return "Copyright: \(author)"
         }
         return nil
     }
     
     var url: URL? {
         apod.url
     }
}
