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
    //MARK: - Distance Button Functionality
    @IBAction func distanceIsOn(_ sender: UISwitch) {
        
        if sender.isOn == true{
            self.delegate?.dataReceived(data: self.sourceHotels)
        }else{
            
        }
        
        
    }
    //MARK: - Room Availability Button Functionality
    @IBAction func roomsIsOn(_ sender: UISwitch) {
        
        //sourceHotels[0].suites_availability.components(separatedBy: ":").count
        
    }
    
    
}

