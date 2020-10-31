//
//  FiltersViewController.swift
//  RestHotels
//
//  Created by Tambanco on 27.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//


import UIKit

protocol CanReceive{
    
    func dataReceived(data: [DataModel])
}

class FiltersViewController: UIViewController {
    
    var delegate: CanReceive?
    var sourceHotels = [DataModel]()
    
    @IBOutlet weak var doneButtonLbl: UIButton!
    @IBOutlet weak var resetButtonLbl: UIButton!
    @IBOutlet weak var sortDistanceLbl: UILabel!
    @IBOutlet weak var sortRoomsLbl: UILabel!
    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var roomsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        distanceSwitch.backgroundColor = UIColor.lightGray
        distanceSwitch.layer.cornerRadius = 16.0
        roomsSwitch.backgroundColor = UIColor.lightGray
        roomsSwitch.layer.cornerRadius = 16.0
    }
    //MARK: - Done Button Functionality
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    //MARK: - Reset Button Functionality
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        distanceSwitch.isOn = false
        roomsSwitch.isOn = false
        
        self.delegate?.dataReceived(data: self.sourceHotels)
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Distance Button Functionality
    @IBAction func distanceIsOn(_ sender: UISwitch) {
        if sender.isOn == true{
            
            var sortedDistance = self.sourceHotels
            
            sortedDistance.sort {$0.distance < $1.distance}
            self.delegate?.dataReceived(data: sortedDistance)
        }else{
            
        }
    }
    //MARK: - Room Availability Button Functionality
    @IBAction func roomsIsOn(_ sender: UISwitch) {
        
        
        //sourceHotels[0].suites_availability.components(separatedBy: ":").count
        
    }
    
    
}

