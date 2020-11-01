//
//  ViewController.swift
//  RestHotels
//
//  Created by Tambanco on 24.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Hotel
{
    let id: Int
    let name: String
    let distance: Double
    let availableRoomsCount: Int
}

class HotelsViewController: UIViewController, Filterable
{
    
    //MARK:- Stateful
    var hotels: [Hotel]                        = []
    var displayOrder: [Int]                    = []
    var filteringOptions: Set<FilteringOption> = []
    var needRefreshData: Bool                  = false
    
    let dataURL = "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filtersButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getJSONData(url: dataURL)
        createSpinnerView()
    }
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToFilters", sender: nil)
    }
    
//MARK: - Networking

    func getJSONData(url: String)
    {
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.updateData(json: json)
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }

//MARK: - JSON Parsing

    func updateData(json: JSON)
    {
        if json["results"].exists()
        {
            let rawItems = json["results"].arrayValue
            if rawItems.count > 0
            {
                rawItems.forEach( { hotels.append(Hotel( id: $0["id"].int ?? 0,
                                                         name: $0["name"].string ?? "issues with name",
                                                         distance: $0["distance"].double ?? 0.0,
                                                         availableRoomsCount: $0["AailableRomms"].int ?? 0))})
                }
            self.collectionView.reloadData()
        }else
        {
            print("Data doesn't available")
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.nameLabel.text = hotels[indexPath.row].name.capitalized
        cell.distanceLabel.text = String("Distance: \(hotels[indexPath.row].distance)")
        return cell
    }
}


// MARK:- Data handling
extension HotelsViewController
{
    func onDataRecieved (_ raw: [Hotel])
    {
        hotels             = raw
        displayOrder       = Array(0..<raw.count)
    }
}

// MARK:- Fake life cycle
extension HotelsViewController
{
    func onViewWillAppear()
    {
        refreshCollectionViewIfNeeded()
    }
}

extension HotelsViewController
{
    func refreshCollectionViewIfNeeded()
    {
        if needRefreshData
        {
            // reloaCollectionView
            needRefreshData = false
        }
    }
}

// MARK:- Fake collection view
extension HotelsViewController
{
    func collectionView(_ displayItemAt: Int)
    {
        setCollectionViewCell(hotels[displayOrder[displayItemAt]])
    }
    
    func setCollectionViewCell(_ dataToDisplay: Hotel?)
    {
        if let dataToDisplay = dataToDisplay
        {
            // Do smth
            print(dataToDisplay.id)
        }
    }
}

// MARK:- Sorting
extension HotelsViewController
{
    func getComparator(_ filterOptions: Set<FilteringOption>) -> ((Hotel, Hotel) -> Bool)?
    {
        switch filterOptions.count
        {
        case 1:
            return getComparatorForSingleOption(filterOptions.first)
        case 2:
            return getComparatorForThoOptions(filterOptions)
        default:
            return nil
        }
    }
    
    func getComparatorForSingleOption(_ filteringOption: FilteringOption?) -> ((Hotel, Hotel) -> Bool)?
    {
        switch filteringOption
        {
        case .byDistance:
            return { (lhs, rhs) in lhs.distance < rhs.distance }
        case .byRoomAvailability:
            return { (lhs, rhs) in lhs.availableRoomsCount > rhs.availableRoomsCount }
        case .none:
            return nil
        }
    }
    
    func getComparatorForThoOptions(_ filterOptions: Set<FilteringOption>) -> ((Hotel, Hotel) -> Bool)?
    {
        if filterOptions.contains(.byDistance) && filterOptions.contains(.byRoomAvailability)
        {
            return { (lhs, rhs) -> Bool in
                if lhs.distance < rhs.distance
                {
                    return true
                }
                else if lhs.distance ==  rhs.distance && lhs.availableRoomsCount > rhs.availableRoomsCount
                {
                    return true
                }
                
                return false
            }
        }
        
        return nil
    }
}

// MARK:- Filterable
extension HotelsViewController
{
    func filter(by filteringOptions: Set<FilteringOption>)
    {
        if self.filteringOptions != filteringOptions, let comparator = getComparator(filteringOptions)
        {
            displayOrder = filteringOptions.isEmpty ? Array(0..<hotels.count) : hotels.sorted(by: comparator).compactMap{ getHotelIndexById($0.id) }
            
            self.filteringOptions = filteringOptions
            
            needRefreshData = true
        }
    }
}

// MARK:- Utls
extension HotelsViewController
{
    func getHotelIndexById(_ id: Int) -> Int?
    {
        hotels.enumerated().first{ $0.1.id == id }?.0
    }
}

// MARK:- UI handlers
extension HotelsViewController
{
    func onSortingTapped()
    {
        let hotelsFilterVC = HotelsFiltersViewController.create()
        
        hotelsFilterVC.delegate = self
        
        
        // present hotelsFilterVC
    }
}
//MARK: - Spinner View Function
extension HotelsViewController
{
    func createSpinnerView() {
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}
//MARK: - Custom buttom
@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
