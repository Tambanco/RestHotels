//
//  FiltersViewController.swift
//  RestHotels
//
//  Created by Tambanco on 27.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//


protocol Filterable
{
    func filter(by filteringOptions: Set<FilteringOption>)
}

import UIKit

enum FilteringOption
{
    case byDistance
    case byRoomAvailability
}

class HotelsFiltersViewController: UIViewController
{
    //MARK: - Properties
    var selectedFilteringOptions: Set<FilteringOption> = []
    
    //MARK: - Delegation
    var filterableDegate: Filterable?
    
    //MARK: - Outlets
    @IBOutlet weak var doneButtonLbl: UIButton!
    @IBOutlet weak var resetButtonLbl: UIButton!
    @IBOutlet weak var sortDistanceLbl: UILabel!
    @IBOutlet weak var sortRoomsLbl: UILabel!
    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var roomsSwitch: UISwitch!
}

//MARK: - Initialization
extension HotelsFiltersViewController
{
    func initialize(_ options: Set<FilteringOption>)
    {
        selectedFilteringOptions = options
    }
}

//MARK: - Life cycle
extension HotelsFiltersViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupUI()
        customizeSwitch()
    }
}

//MARK: - Setup UI
extension HotelsFiltersViewController
{
    func setupUI()
    {
        setupFilteringOptions()
    }
    
    func setupFilteringOptions()
    {
        let switchSettings: [(UISwitch, Bool)] = [(distanceSwitch, selectedFilteringOptions.contains(.byDistance)),
                                                  (roomsSwitch, selectedFilteringOptions.contains(.byRoomAvailability))]
        
        switchSettings.forEach{ $0.0.isOn = $0.1 }
    }
}

//MARK: - UI handlers
extension HotelsFiltersViewController
{
    //MARK: - Done Button Functionality
    @IBAction func doneButtonPressed(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Reset Button Functionality
    @IBAction func resetButtonPressed(_ sender: UIButton)
    {
        selectedFilteringOptions.removeAll()
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Distance Button Functionality
    @IBAction func distanceIsOn(_ sender: UISwitch)
    {
        toggleFilteringOptions(.byDistance)
    }
    
    //MARK: - Room Availability Button Functionality
    @IBAction func roomsIsOn(_ sender: UISwitch)
    {
        toggleFilteringOptions(.byRoomAvailability)
    }
    
    func toggleFilteringOptions(_ filteringOption: FilteringOption)
    {
        if selectedFilteringOptions.contains(filteringOption)
        {
            selectedFilteringOptions.remove(filteringOption)
        }
        else
        {
            selectedFilteringOptions.insert(filteringOption)
        }
    }
}

// MARK:- Fake life cycle
extension HotelsFiltersViewController
{
    override func viewWillDisappear(_ animated: Bool)
    {
        filterableDegate?.filter(by: selectedFilteringOptions)
    }
}

// MARK:- Instantiation
extension HotelsFiltersViewController
{
    static func create(_ selectedOptions: Set<FilteringOption>) -> HotelsFiltersViewController?
    {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HotelsFiltersViewController") as? HotelsFiltersViewController
        {
            vc.initialize(selectedOptions)
            
            return vc
        }
        
        return nil
    }
}

//MARK: - Switch constructor
extension HotelsFiltersViewController
{
    func customizeSwitch()
    {
        distanceSwitch.backgroundColor = UIColor.lightGray
        distanceSwitch.layer.cornerRadius = 16.0
        roomsSwitch.backgroundColor = UIColor.lightGray
        roomsSwitch.layer.cornerRadius = 16.0
    }
}
