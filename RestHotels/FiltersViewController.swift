//
//  FiltersViewController.swift
//  RestHotels
//
//  Created by Tambanco on 27.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController {
    
    
    var sourceHotels = [HotelsInfo]()
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var roomAvailabilityButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
    }
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
        
    }
    
    @IBAction func distanceButtonPressed(_ sender: UIButton) {
        
        if distanceButton.isSelected == true{
            distanceButton.isSelected = false
        }else{
            distanceButton.isSelected = true
        }
        // sort hoytels by distance (ascending)
        
        
        sourceHotels.sort {$0.distance < $1.distance}
        print(sourceHotels)
        
    }
    @IBAction func roomAvailabilityButtonPressed(_ sender: UIButton) {
        
        if roomAvailabilityButton.isSelected == true{
            roomAvailabilityButton.isSelected = false
        }else{
            roomAvailabilityButton.isSelected = true
        }
        
    }
    
}
