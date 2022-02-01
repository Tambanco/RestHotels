//
//  StringExtentsion.swift
//  RestHotels
//
//  Created by Tambanco on 08.11.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

extension String {
    func getHight(for width: CGFloat, with font: UIFont = UIFont.systemFont(ofSize: 17.0)) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        
        label.font          = font
        label.numberOfLines = 0
        label.text = self
        label.sizeToFit()

        return label.frame.height
    }
}
