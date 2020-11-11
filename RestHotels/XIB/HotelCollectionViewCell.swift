//
//  CustomCollectionViewCell.swift
//  RestHotels
//
//  Created by Tambanco on 24.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

class HotelCollectionViewCell: UICollectionViewCell
{
    //MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var vacantRoomsCountLabel: UILabel!
        
}

extension HotelCollectionViewCell
{
    func initialize(_ hotel: Hotel)
    {
        nameLabel.text = hotel.name
        addressLabel.text = hotel.address
        starsLabel.text = String(format: "%.2f", hotel.rating)
        distanceLabel.text = String(format: "%.2f", hotel.distance)
        vacantRoomsCountLabel.text = String(format: "%d", hotel.vacantRoomsCount)
    }
}

extension HotelCollectionViewCell
{
    struct Constants
    {
        static let verticalSpacing = CGFloat(115)
        static let horisontalPaddings = CGFloat(32)
    }
}
