//
//  ApodViewModel.swift
//  Cosmos
//
//  Created by Samuel Yanez on 10/15/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

struct ApodViewModel {
    let apod: Apod
    
    init(apod: Apod) {
        self.apod = apod
    }
}

extension ApodViewModel {
    var title: String {
         apod.title
     }
     
     var date: String {
        DateFormatter(locale: .current, format: "EEEE, MMM d").string(from: apod.date)
     }
         
     var explanation: String {
        apod.explanation.isEmpty ? DetailViewStrings.missingExplanation.localized : apod.explanation
     }
     
     var mediaType: Apod.MediaType {
         apod.mediaType
     }
     
     var preferredDate: String? {
         if apod.date.isToday {
            return DetailViewStrings.today.localized
         } else if apod.date.isYesterday {
            return DetailViewStrings.yesterday.localized
         } else {
             return nil
         }
     }
     
    var copyright: NSMutableAttributedString? {
         if let author = apod.copyright {
            let string = String(format: DetailViewStrings.copyright.localized, author)
            let attributedText = NSMutableAttributedString(string: string, attributes: [.font: DynamicFont.shared.font(forTextStyle: .body)])
            attributedText.addForegroundColorAttribute(toSubString: "Copyright:", foregroundColor: .label)
            return attributedText
        }
         return nil
    }
    
    var url: URL? {
        URL(string: apod.urlString)
    }
    
    var thumbnailUrl: URL? {
        switch apod.mediaType {
        case .image:
            return URL(string: apod.urlString)
        case .video:
            guard let thumbnailUrlString = apod.thumbnailUrlString else { return nil }
            return URL(string: thumbnailUrlString)
        }
    }
}
