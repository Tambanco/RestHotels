//
//  FiltersViewController.swift
//  RestHotels
//
//  Created by Tambanco on 27.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

enum FilteringOption
{
    case byDistance
    case byRoomAvailability
}

protocol Filterable
{
    func filter(by filteringOptions: Set<FilteringOption>)
}

import UIKit

class HotelsFiltersViewController: UIViewController
{
    
    var delegate: Filterable?
    
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
        
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Distance Button Functionality
    @IBAction func distanceIsOn(_ sender: UISwitch) {
        if sender.isOn == true{
            
        }else{
            
        }
    }
    //MARK: - Room Availability Button Functionality
    @IBAction func roomsIsOn(_ sender: UISwitch) {
        
    }
}
// MARK:- Initialization
extension HotelsFiltersViewController
{
    func initialize()
    {
        
    }
}

// MARK:- fake life cycle
extension HotelsFiltersViewController
{
    func viewWillDisappear()
    {
        delegate?.filter(by: [.byDistance])
    }
}

// MARK:- Instantiation
extension HotelsFiltersViewController
{
    static func create() -> HotelsFiltersViewController
    {
        let vc = HotelsFiltersViewController()
        
        return vc
    }
}

