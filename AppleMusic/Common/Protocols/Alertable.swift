//
//  Alertable.swift
//  AppleMusic
//
//  Created by TOOK on 06.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
protocol Alertable {
    func showErrorAlert(labelText: String?, detailText: String?)
    func showClosedErrorAlert(labelText: String?, detailText: String?, closedAction: @escaping (() -> Void))
    func showSuccessAlert(labelText: String?, detailText: String?)
    func showAddedToLibraryAlert(title: String)
}
