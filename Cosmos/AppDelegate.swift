//
//  AppDelegate.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit
import Lightbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureLightbox()
        return true
    }
    
    // MARK: Configuration
    
    private func configureLightbox() {
        LightboxConfig.CloseButton.text = ""
        LightboxConfig.CloseButton.image = UIImage(named: "close-icon")
        LightboxConfig.CloseButton.size = CGSize(width: 40, height: 40)
        LightboxConfig.PageIndicator.enabled = false
    }
}
