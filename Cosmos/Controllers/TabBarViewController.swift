//
//  TabBarViewController.swift
//  Cosmos
//
//  Created by Samuel Yanez on 12/8/18.
//  Copyright © 2018 Samuel Yanez. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    /// Previous selected view controller
    private var previousSelectedViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        previousSelectedViewController = selectedViewController
    }
}

// MARK: UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == previousSelectedViewController, let navigationController = viewController as? UINavigationController {
            if let discoverViewController = navigationController.topViewController as? DiscoverViewController {
                discoverViewController.scrollToTop()
            } else if let favoritesViewController = navigationController.topViewController as? FavoritesViewController {
                favoritesViewController.scrollToTop()
            }
        }
        previousSelectedViewController = viewController
    }
}
