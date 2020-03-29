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
    func activityViewController(for media: ShareManager.ShareMedia) -> UIActivityViewController
}

class ShareManager: ShareManaging {
    
    enum ShareMedia {
        case image(UIImage)
        case video(String)
    }
            
    func activityViewController(for media: ShareMedia) -> UIActivityViewController {
        let activityViewController: UIActivityViewController = {
            switch media {
            case .image(let image):
                let message = String(format: ShareStrings.imageShareMessage.localized, AppStoreEndpoint.share.url.absoluteString)
                return UIActivityViewController(activityItems: [image, message], applicationActivities: nil)
            case .video(let url):
                let message = String(format: ShareStrings.videoShareMessage.localized, url, AppStoreEndpoint.share.url.absoluteString)
                return UIActivityViewController(activityItems: [message], applicationActivities: nil)
            }
        }()
        activityViewController.excludedActivityTypes = [.postToFacebook]
        return activityViewController
    }
}
