//
//  FiltersViewController.swift
//  RestHotels
//
//  Created by Tambanco on 27.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//


import UIKit

protocol CanReceive{
    
   // func dataReceived(data: [DataModel])
}

class FiltersViewController: UIViewController {
    
//    var viewConroller: ViewController?
    var sourceHotels = [DataModel]()
    
   
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var roomAvailabilityButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK: - Done button functionality
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true) {
//            self.viewConroller?.onUserAction(data: self.sourceHotels)
            print(self.sourceHotels)
        }
    }
    //MARK: - Distance Button Functionality
    @IBAction func distanceButtonPressed(_ sender: UIButton) {
        if distanceButton.isSelected == true{
            distanceButton.isSelected = false
        }else{
            distanceButton.isSelected = true
        }
        // sort hotels by distance (ascending)
        sourceHotels.sort {$0.distance < $1.distance}
        
    }
    //MARK: - Room Availability Button Functionality
    @IBAction func roomAvailabilityButtonPressed(_ sender: UIButton) {
        if roomAvailabilityButton.isSelected == true{
            roomAvailabilityButton.isSelected = false
        }else{
            roomAvailabilityButton.isSelected = true
        }
        
    }
    
}
