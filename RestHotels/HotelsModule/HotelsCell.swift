//
//  HotelsCell.swift
//  RestHotels
//
//  Created by tambanco 🥳 on 01.02.2022.
//  Copyright © 2022 Tambanco. All rights reserved.
//

import Foundation
import UIKit

class HotelsCell: UICollectionViewCell {
    //reuseId
    static let reuseId = "HotelsCell"
    
    //staic labels
    let assessment: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let distance: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let vacantRooms: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //dinamic labels
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let starsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let vacantRoomsCountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameLabel)
        addSubview(addressLabel)
        addSubview(assessment)
        addSubview(starsLabel)
        addSubview(distance)
        addSubview(distanceLabel)
        addSubview(vacantRooms)
        addSubview(vacantRoomsCountLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        
        assessment.translatesAutoresizingMaskIntoConstraints = false
        assessment.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        assessment.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20).isActive = true
        
        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        starsLabel.leadingAnchor.constraint(equalTo: assessment.trailingAnchor, constant: 20).isActive = true
        starsLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20).isActive = true
        
        distance.translatesAutoresizingMaskIntoConstraints = false
        distance.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        distance.topAnchor.constraint(equalTo: assessment.bottomAnchor, constant: 20).isActive = true
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.leadingAnchor.constraint(equalTo: distance.trailingAnchor, constant: 20).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: starsLabel.bottomAnchor, constant: 20).isActive = true
        
        vacantRooms.translatesAutoresizingMaskIntoConstraints = false
        vacantRooms.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        vacantRooms.topAnchor.constraint(equalTo: distance.bottomAnchor, constant: 20).isActive = true
        
        vacantRoomsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        vacantRoomsCountLabel.leadingAnchor.constraint(equalTo: vacantRooms.trailingAnchor, constant: 20).isActive = true
        vacantRoomsCountLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
