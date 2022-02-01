//
//  ErrorAlert.swift
//  RestHotels
//
//  Created by tambanco 🥳 on 01.02.2022.
//  Copyright © 2022 Tambanco. All rights reserved.
//

import Foundation
import UIKit
// MARK:- Error Alert
extension UIViewController {
    func showAlert(_ errorMassage: String) {
        let alert = UIAlertController(title: "An Error occured", message: errorMassage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
