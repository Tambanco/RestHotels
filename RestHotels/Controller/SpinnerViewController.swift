//
//  SpinnerViewController.swift
//  RestHotels
//
//  Created by Tambanco on 26.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController
{
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
