//
//  ViewController.swift
//  RestHotels
//
//  Created by Tambanco on 24.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

class HotelsViewController: UIViewController, UICollectionViewDataSource, Filterable
{
    
    //MARK:- Stateful
    var hotels: [HotelParameters]              = []
    var displayOrder: [Int]                    = []
    var filteringOptions: Set<FilteringOption> = []
    var needRefreshData: Bool                  = false
    
    var hotelsList = [StructHotelJSON]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filtersButton: UIButton!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.nameLabel.text = hotels[indexPath.row].name.capitalized
        //cell.addressLabel.text = hotels[indexPath.row].address.capitalized
        //cell.starsLabel.text = String("Stars: \(hotels[indexPath.row].stars)")
        cell.distanceLabel.text = String("Distance: \(hotels[indexPath.row].distance)")
        cell.suitesAvailabilityLabel.text = "Vacant Room: \(hotels[indexPath.row].availableRoomsCount)"
        return cell
    }
    
    @IBAction func filtersButtonPressed(_ sender: UIButton) {
        onSortingTapped()
    }
}

//MARK: - Life cycle
extension HotelsViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        createSpinnerView()
        collectionView.dataSource = self
        
        requestData()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshCollectionViewIfNeeded()
        
        
    }
}

//MARK: - Networking
extension HotelsViewController
{
    func requestData()
    {
        let url = URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do{
                    self.hotelsList = try JSONDecoder().decode([StructHotelJSON].self, from: data!)
                    print("Data download successfully")
                    self.hotels = self.hotelsList.map{
                        HotelParameters(id: $0.id,
                                        name: $0.name,
                                        distance: $0.distance,
                                        availableRoomsCount: self.getVacantRoomCount($0.suites_availability))
                    }
                }catch{
                    print("Download failure. Error: \(error)")
                }
                DispatchQueue.main.async
                {
//                    self.collectionView.reloadData()
                }
            }
        }.resume()
    }
}
// MARK:- Data handling
extension HotelsViewController
{
    func onDataRecieved (_ raw: [HotelParameters])
    {
        hotels             = raw
        displayOrder       = Array(0..<raw.count)
    }
}

// MARK:- Fake life cycle
//extension HotelsViewController
//{
//    func onViewWillAppear()
//    {
//        refreshCollectionViewIfNeeded()
//    }
//}

extension HotelsViewController
{
    func refreshCollectionViewIfNeeded()
    {
        if needRefreshData
        {
            collectionView.reloadData()
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
    
    func setCollectionViewCell(_ dataToDisplay: HotelParameters?)
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
    func getComparator(_ filterOptions: Set<FilteringOption>) -> ((HotelParameters, HotelParameters) -> Bool)?
    {
        switch filterOptions.count
        {
        case 1:
            return getComparatorForSingleOption(filterOptions.first)
        case 2:
            return getComparatorForTwoOptions(filterOptions)
        default:
            return nil
        }
    }
    
    func getComparatorForSingleOption(_ filteringOption: FilteringOption?) -> ((HotelParameters, HotelParameters) -> Bool)?
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
    
    func getComparatorForTwoOptions(_ filterOptions: Set<FilteringOption>) -> ((HotelParameters, HotelParameters) -> Bool)?
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
        performSegue(withIdentifier: "goToFilters", sender: nil)
    }
}
//MARK: - Spinner View Function
extension HotelsViewController
{
    func createSpinnerView() {
        let child = SpinnerViewController()
        addChild(child)
        child.view.backgroundColor = .white
        child.view.frame = CGRect(x: 170, y: 250, width: 70, height: 70)
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

//MARK: - Utils
extension HotelsViewController{
    func getVacantRoomCount(_ raw: String) -> Int
    {
        return raw.split(separator: ":").count
    }
}
