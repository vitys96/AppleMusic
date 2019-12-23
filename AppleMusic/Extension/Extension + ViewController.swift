//
//  Extension + ViewController.swift
//  AppleMusic
//
//  Created by TOOK on 06.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import JGProgressHUD
import SPAlert

extension UIViewController {
    func showErrorAlert(labelText: String? = nil, detailText: String?) {
        let errorAlert = JGProgressHUD(style: .dark)
        errorAlert.indicatorView = JGProgressHUDErrorIndicatorView()
        errorAlert.textLabel.text = labelText
        errorAlert.detailTextLabel.text = detailText
        errorAlert.show(in: self.view)
        errorAlert.dismiss(afterDelay: 4, animated: true)
        errorAlert.tapOutsideBlock = { (hud) in
            hud.dismiss()
        }
    }
    
    func showSuccessAlert(labelText: String? = nil, detailText: String?) {
        let errorAlert = JGProgressHUD(style: .dark)
        errorAlert.indicatorView = JGProgressHUDSuccessIndicatorView()
        errorAlert.textLabel.text = labelText
        errorAlert.detailTextLabel.text = detailText
        errorAlert.show(in: self.view, animated: true)
        errorAlert.dismiss(afterDelay: 4, animated: true)
        errorAlert.tapOutsideBlock = { (hud) in
            hud.dismiss()
        }
    }
    
    func startLoading() {
        let hud = JGProgressHUD(style: .dark)
        hud.tag = 100
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
    }
    
    func stopLoading() {
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func showClosedErrorAlert(labelText: String?, detailText: String?, closedAction: @escaping (() -> Void)) {
        let errorAlert = JGProgressHUD(style: .dark)
        errorAlert.indicatorView = JGProgressHUDErrorIndicatorView()
        errorAlert.textLabel.text = labelText
        errorAlert.detailTextLabel.text = detailText
        errorAlert.show(in: view)
        errorAlert.tapOnHUDViewBlock = { (hud) in
            closedAction()
        }
        errorAlert.tapOutsideBlock = { (hud) in
            closedAction()
        }
    }
    
    func showAddedToLibraryAlert(title: String) {
        let alertView = SPAlertView(title: title, message: nil, preset: SPAlertPreset.done)
        alertView.duration = 1
        alertView.dismissByTap = false
        alertView.haptic = .success
        alertView.present()
    }
}
