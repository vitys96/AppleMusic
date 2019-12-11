//
//  SearchConfigurator.swift
//  AppleMusic
//
//  Created Vitaly on 24.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//
//  Template generated by Sakhabaev Egor @Banck
//  https://github.com/Banck/Swift-viper-template-for-xcode
//

import UIKit

struct SearchConfigurator {

	static func createModule() -> UIViewController {
        var view: SearchViewController!

        let viewController = UIStoryboard.init(name: "Search", bundle: Bundle.main).instantiateInitialViewController()
        if viewController == nil {
            fatalError("Seems there is no initial view controller in Search.storyboard")
        }

        if viewController is UINavigationController {
            view = (viewController as! UINavigationController).viewControllers.first as? SearchViewController
        } else {
            view = viewController as? SearchViewController
        }
        

        let interactor = SearchInteractor()
        let router = SearchRouter()
        let presenter = SearchPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return viewController!
    }
}
