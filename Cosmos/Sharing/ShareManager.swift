//
//  ShareManager.swift
//  Cosmos
//
//  Created by Samuel Yanez on 11/21/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

struct Sharing {
    enum Media {
        case image(UIImage?)
        case video(String)
    }
}

protocol ShareManaging {
    func activityViewController(with media: Sharing.Media) -> UIActivityViewController
}

struct ShareManager {
    private struct Constants {
        static let appId = "1481310548"
        static let appStorePath = "https://apps.apple.com/app/"
    }
    
    private let excludedTypes: [UIActivity.ActivityType] = [
        .postToFacebook
    ]
    
    // TODO: Localize strings...
    
    func activityViewController(with media: Sharing.Media) -> UIActivityViewController {
        let activityViewController: UIActivityViewController = {
            switch media {
            case .image(let image):
                let text = """
                Checkout this image I discovered using the Cosmos app.
                
                The Cosmos app is available on the App Store. \(Constants.appStorePath)
                """
                if let image = image {
                    return UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
                } else {
                    return UIActivityViewController(activityItems: [text], applicationActivities: nil)
                }
            case .video(let url):
                let text = """
                Checkout this video I discovered using the Cosmos app: \(url).

                The Cosmos app is available on the App Store. \(Constants.appStorePath)
                """
                return UIActivityViewController(activityItems: [text], applicationActivities: nil)
            }
        }()
        activityViewController.excludedActivityTypes = excludedTypes
        return activityViewController
    }
}
