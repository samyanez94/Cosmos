//
//  AppDelegate.swift
//  Cosmos
//
//  Created by Samuel Yanez on 7/21/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit
import Lightbox
import Toast_Swift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureLightbox()
        configureToasts()
        return true
    }
    
    // MARK: Configuration
    
    private func configureLightbox() {
        LightboxConfig.CloseButton.text = ""
        LightboxConfig.CloseButton.image = UIImage(systemName: "xmark.circle.fill")?.withTintColor(UIColor.white.withAlphaComponent(0.5), renderingMode: .alwaysOriginal)
        LightboxConfig.CloseButton.size = CGSize(width: 35, height: 35)
        LightboxConfig.PageIndicator.enabled = false
    }
    
    // TODO: Consider removing pod by implementing own toast
    
    private func configureToasts() {
        var style = ToastStyle()
        style.backgroundColor = UIColor(named: "Accent Color") ?? .black
        style.messageFont = .boldSystemFont(ofSize: 16)
        style.verticalPadding = 14.0
        style.horizontalPadding = 16.0
        ToastManager.shared.style = style
        ToastManager.shared.isQueueEnabled = true
    }
}
