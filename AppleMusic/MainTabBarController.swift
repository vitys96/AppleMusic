//
//  MainTabBarController.swift
//  AppleMusic
//
//  Created by Vitaly on 24.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            generateViewControllers(rootVC: SearchConfigurator.createModule(), image: #imageLiteral(resourceName: "search"), title: "Search"),
            generateViewControllers(rootVC: LibraryConfigurator.createModule(), image: #imageLiteral(resourceName: "library"), title: "Library"),
        ]
        
    }
    
    private func generateViewControllers(rootVC: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.tabBarItem.image = image
        navVC.tabBarItem.title = title
        rootVC.navigationItem.title = title
        navVC.navigationBar.prefersLargeTitles = true
        return navVC
    }
    
}
