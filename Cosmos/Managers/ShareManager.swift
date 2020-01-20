//
//  ShareManager.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/21/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

protocol ShareManaging {
    func activityViewController(with media: ShareManager.ShareMedia) -> UIActivityViewController
}

class ShareManager: ShareManaging {
    
    static let shared: ShareManaging = ShareManager()
    
    private struct Constants {
        static let appStoreLink = "https://apps.apple.com/app/1481310548"
    }
    
    private let excludedTypes: [UIActivity.ActivityType] = [
        .postToFacebook
    ]
        
    func activityViewController(with media: ShareMedia) -> UIActivityViewController {
        let activityViewController: UIActivityViewController = {
            switch media {
            case .image(let image):
                let message = String(format: ShareStrings.imageShareMessage.localized, Constants.appStoreLink)
                return UIActivityViewController(activityItems: [image, message], applicationActivities: nil)
            case .video(let url):
                let message = String(format: ShareStrings.videoShareMessage.localized, url, Constants.appStoreLink)
                return UIActivityViewController(activityItems: [message], applicationActivities: nil)
            }
        }()
        activityViewController.excludedActivityTypes = excludedTypes
        return activityViewController
    }
}

extension ShareManager {
    enum ShareMedia {
        case image(UIImage)
        case video(String)
    }
}