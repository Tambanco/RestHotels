//
//  FiltersViewController.swift
//  RestHotels
//
//  Created by Tambanco on 27.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

protocol Filterable {
    func filter(by filteringOptions: Set<FilteringOption>)
}

enum FilteringOption {
    case byDistance
    case byRoomAvailability
}

class HotelsFiltersViewController: UIViewController {
    //MARK: - Properties
    var selectedFilteringOptions: Set<FilteringOption> = []
    
    //MARK: - Outlets
    @IBOutlet weak var doneButtonLbl: UIButton!
    @IBOutlet weak var resetButtonLbl: UIButton!
    @IBOutlet weak var sortDistanceLbl: UILabel!
    @IBOutlet weak var sortRoomsLbl: UILabel!
    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var roomsSwitch: UISwitch!

    //MARK: - Delegation
    var filterableDegate: Filterable?
}

//MARK: - Initialization
extension HotelsFiltersViewController {
    func initialize(_ options: Set<FilteringOption>)
    {
        selectedFilteringOptions = options
    }
}

//MARK: - Life cycle
extension HotelsFiltersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        customizeSwitch()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.frame = CGRect(x: 0, y: self.view.frame.height - 220, width: self.view.frame.size.width, height: 220)
        self.view.layer.cornerRadius = 10.0
        self.view.clipsToBounds = true
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

// MARK:- Fake life cycle
extension HotelsFiltersViewController {
    override func viewWillDisappear(_ animated: Bool) {
        filterableDegate?.filter(by: selectedFilteringOptions)
    }
}

//MARK: - Setup UI
extension HotelsFiltersViewController {
    func setupUI() {
        setupFilteringOptions()
    }
    
    func setupFilteringOptions() {
        let switchSettings: [(UISwitch, Bool)] = [(distanceSwitch, selectedFilteringOptions.contains(.byDistance)),
                                                  (roomsSwitch, selectedFilteringOptions.contains(.byRoomAvailability))]
        
        switchSettings.forEach{ $0.0.isOn = $0.1 }
    }
}

//MARK: - UI handlers
extension HotelsFiltersViewController {
    //MARK: - Done Button Functionality
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Reset Button Functionality
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        selectedFilteringOptions.removeAll()
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Distance Button Functionality
    @IBAction func distanceIsOn(_ sender: UISwitch) {
        toggleFilteringOptions(.byDistance)
    }
    
    //MARK: - Room Availability Button Functionality
    @IBAction func roomsIsOn(_ sender: UISwitch) {
        toggleFilteringOptions(.byRoomAvailability)
    }
    
    func toggleFilteringOptions(_ filteringOption: FilteringOption) {
        if selectedFilteringOptions.contains(filteringOption) {
            selectedFilteringOptions.remove(filteringOption)
        }
        else {
            selectedFilteringOptions.insert(filteringOption)
        }
    }
}

// MARK:- Instantiation
extension HotelsFiltersViewController {
    static func create(_ selectedOptions: Set<FilteringOption>) -> HotelsFiltersViewController? {
        if #available(iOS 13.0, *) {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HotelsFiltersViewController") as? HotelsFiltersViewController {
                vc.initialize(selectedOptions)
                
                return vc
            }
        } else {
            // Fallback on earlier versions
        }
        
        return nil
    }
}

//MARK: - Switch constructor
extension HotelsFiltersViewController {
    func customizeSwitch()
    {
        distanceSwitch.backgroundColor = UIColor.lightGray
        distanceSwitch.layer.cornerRadius = 16.0
        roomsSwitch.backgroundColor = UIColor.lightGray
        roomsSwitch.layer.cornerRadius = 16.0
    }
}
