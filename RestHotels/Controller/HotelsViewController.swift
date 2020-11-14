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

class HotelsViewController: UIViewController, Filterable
{
//MARK: - Outlets
   
    @IBOutlet weak var hotelsCollectionView: UICollectionView!
    @IBOutlet weak var filtersButton: UIButton!
    
//MARK:- Stateful
    var hotels: [Hotel]                        = []
    var displayOrder: [Int]                    = []
    var filteringOptions: Set<FilteringOption> = []
    var needRefreshData: Bool                  = false
    var cellHeights: [CGFloat]                 = []
    
    
//MARK: - Buttons actions
    @IBAction func filtersButtonPressed(_ sender: UIButton)
    {
        onSortingTapped()
    }
}

//MARK: - Life cycle
extension HotelsViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        requestData()
        //createSpinnerView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        refreshCollectionViewIfNeeded()
    }
}
//MARK:- Setup UI
extension HotelsViewController
{
    func setupUI()
    {
        self.view.translatesAutoresizingMaskIntoConstraints = false
 
        setupHotelsCollectionView()
    }
    
    func setupHotelsCollectionView()
    {
        hotelsCollectionView.contentInsetAdjustmentBehavior = .never
        hotelsCollectionView.delegate   = self
        hotelsCollectionView.dataSource = self
        
        hotelsCollectionView.register(UINib(nibName: String(describing: HotelCollectionViewCell.self), bundle: nil),
                                      forCellWithReuseIdentifier: String(describing: HotelCollectionViewCell.self))
    }
}

//MARK: - Networking
extension HotelsViewController
{
    func requestData()
    {
        AF.request("https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json")
            .responseJSON { response in
            switch response.result
            {
                case .success(let value):
                    let json = JSON(value)
                    self.updateHotelsList(jsonData: json)
                   
                case .failure(let error):
                    print(error)
            }
        }
    }
}
    
//MARK: - Update Hotels List
extension HotelsViewController
{
    func updateHotelsList(jsonData: JSON)
    {
        if jsonData.exists()
        {
            let rawHotelsList = jsonData[].arrayValue
            if rawHotelsList.count > 0
            {
                rawHotelsList.forEach({ hotels.append( Hotel(id: $0["id"].int ?? 0,
                                                             name: $0["name"].string ?? "no name",
                                                             address: $0["address"].string ?? "no address",
                                                             rating: $0["stars"].double ?? 0.0,
                                                             distance: $0["distance"].double ?? 0.0,
                                                             vacantRoomsCount: self.getVacantRoomCount($0["suites_availability"].string ?? "no vacant rooms")))
                    DispatchQueue.main.async
                    {
                        self.cellHeights = self.getCellHeights(self.hotels)
                        self.onDataRecieved(self.hotels)
                        self.hotelsCollectionView.reloadData()
                    }
                })
            }
            else
            {
                print("No Data Available")
            }
        }
    }
}

//MARK:- UICollectionView
extension HotelsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return cellHeights.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HotelCollectionViewCell.self),
                                                         for: indexPath) as? HotelCollectionViewCell
        {
            cell.initialize(hotels[displayOrder[indexPath.item]])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: cellHeights[displayOrder[indexPath.item]])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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


//MARK:- Utils
extension HotelsViewController
{
    func getCellHeights(_ hotels: [Hotel]) -> [CGFloat]
    {
        
        return hotels.map{  $0.name.getHight(for: UIScreen.main.bounds.width - HotelCollectionViewCell.Constants.horisontalPaddings, with: UIFont.boldSystemFont(ofSize: 25)) +
                            $0.address.getHight(for: UIScreen.main.bounds.width - HotelCollectionViewCell.Constants.horisontalPaddings) +
                            HotelCollectionViewCell.Constants.verticalSpacing }
    }
}

// MARK:- Fake life cycle
extension HotelsViewController
{
    func refreshCollectionViewIfNeeded()
    {
        if needRefreshData
        {
            hotelsCollectionView.reloadData()
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
            return getComparatorForTwoOptions(filterOptions)
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
            return { (lhs, rhs) in lhs.vacantRoomsCount > rhs.vacantRoomsCount }
        case .none:
            return nil
        }
    }
    
    func getComparatorForTwoOptions(_ filterOptions: Set<FilteringOption>) -> ((Hotel, Hotel) -> Bool)?
    {
        if filterOptions.contains(.byDistance) && filterOptions.contains(.byRoomAvailability)
        {
            return { (lhs, rhs) -> Bool in
                if lhs.distance < rhs.distance
                {
                    return true
                }
                else if lhs.distance ==  rhs.distance && lhs.vacantRoomsCount > rhs.vacantRoomsCount
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
        if self.filteringOptions != filteringOptions
        {
            if filteringOptions.isEmpty
            {
                displayOrder = Array(0..<hotels.count)
            }
            else
            {
                if let comparator = getComparator(filteringOptions)
                {
                    displayOrder = hotels.sorted(by: comparator).compactMap{ getHotelIndexById($0.id) }
                }
            }
            
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
        if let hotelsFilterVC = HotelsFiltersViewController.create(filteringOptions)
        {
            hotelsFilterVC.filterableDegate = self
            hotelsFilterVC.modalPresentationStyle = .fullScreen
            present(hotelsFilterVC, animated: true)
        }
    }
}
//MARK: - Spinner View Function
extension HotelsViewController
{
    func createSpinnerView()
    {
//        let child = SpinnerViewController()
//        addChild(child)
//        child.view.backgroundColor = .white
////        child.view.frame = CGRect(x: view.layer.frame.width / 2, y: view.layer.frame.height / 2, width: 70, height: 70)
//        child.view.frame = CGRect(x: 187.5, y: 406.0, width: 70, height: 70)
//        view.addSubview(child.view)
//        child.didMove(toParent: self)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            child.willMove(toParent: nil)
//            child.view.removeFromSuperview()
//            child.removeFromParent()
//        }
    }
}
//MARK: - Custom buttom
@IBDesignable extension UIButton
{
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
extension HotelsViewController
{
    func getVacantRoomCount(_ raw: String) -> Int
    {
        return raw.split(separator: ":").count
    }
}
