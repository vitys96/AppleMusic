//
//  MainTabBarController.swift
//  AppleMusic
//
//  Created by Vitaly on 24.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
class MainTabBarController: UITabBarController {
    
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    var isFirst: Bool = true
    
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()!
    let searchVC: SearchViewController = SearchConfigurator.createModule() as! SearchViewController
    let libraryVC: LibraryViewController = LibraryConfigurator.createModule() as! LibraryViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        setupTrackDetailView()
        
        searchVC.tabBarDelegate = self
        libraryVC.tabBarDelegate = self
        viewControllers = [
            generateViewControllers(rootVC: searchVC, image: #imageLiteral(resourceName: "search"), title: "Search"),
            generateViewControllers(rootVC: libraryVC, image: #imageLiteral(resourceName: "library"), title: "Library")
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
    
    private func setupTrackDetailView() {
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        trackDetailView.delegate = libraryVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = true

        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    func maximizeTrackDetailController(viewModel: SearchCell.ViewModel?) {
        
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 0
                        self.trackDetailView.miniTrackView.alpha = 0
                        self.trackDetailView.maximizedStackView.alpha = 1
        },
                       completion: nil)
        guard let viewModel = viewModel else { return }
        self.trackDetailView.configure(with: viewModel)
    }
    
    func minimazeTrackDetailController() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 1
                        self.trackDetailView.miniTrackView.alpha = 1
                        self.trackDetailView.maximizedStackView.alpha = 0
        },
                       completion: nil)
    }
}
