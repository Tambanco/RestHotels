//
//  ViewController.swift
//  RestHotels
//
//  Created by Tambanco on 24.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class HotelsViewController: UIViewController, Filterable, Informational {
    //MARK:- Properties
    var hotels: [Hotel]                             = []
    var displayOrder: [Int]                         = []
    var filteringOptions: Set<FilteringOption>      = []
    var needRefreshData: Bool                       = false
    var cellHeights: [CGFloat]                      = []
    var urlOfHotelsList                             = "https://raw.githubusercontent.com/Tambanco/HotelsJSON/main/hotels.json"
    var container: UIView                           = UIView()
    var loadingView: UIView                         = UIView()
    var activityIndicator: UIActivityIndicatorView  = UIActivityIndicatorView()
    let visualEffectView: UIVisualEffectView = {
            let blurEffect = UIBlurEffect(style: .dark)
            let view = UIVisualEffectView(effect: blurEffect)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

    //MARK: - Outlets
    @IBOutlet weak var hotelsCollectionView: UICollectionView!
    @IBOutlet weak var filtersButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    //MARK: - Buttons actions
    @IBAction func filtersButtonPressed(_ sender: UIButton) {
        onSortingTapped()
        tapped()
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        tapped()
    }
}

//MARK: - Life cycle
extension HotelsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestData(url: urlOfHotelsList)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshCollectionViewIfNeeded()
    }
}

// MARK:- Fake life cycle
extension HotelsViewController {
    func refreshCollectionViewIfNeeded(){
        if needRefreshData{
            hotelsCollectionView.reloadData()
            needRefreshData = false
        }
    }
}

//MARK:- Setup UI
extension HotelsViewController {
    func setupUI() {
        self.view.translatesAutoresizingMaskIntoConstraints = true
 
        setupHotelsCollectionView()
        setupVisualEffectView()
    }
    
    func setupHotelsCollectionView() {
        hotelsCollectionView.contentInsetAdjustmentBehavior = .never
        hotelsCollectionView.delegate   = self
        hotelsCollectionView.dataSource = self
        
        hotelsCollectionView.register(UINib(nibName: String(describing: HotelCollectionViewCell.self), bundle: nil),
                                      forCellWithReuseIdentifier: String(describing: HotelCollectionViewCell.self))
    }
    
    func setupVisualEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }
}

//MARK: - Networking
extension HotelsViewController {
    func requestData(url: String) {
        showActivityIndicator(uiView: self.view)
        
        AF.request(url).responseJSON { response in
            self.hideActivityIndicator(self.view)

            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.updateHotelsList(jsonData: json)
                case .failure(let error):
                    self.showAlert("\(error)")
            }
        }
    }
}
    
//MARK: - Update Hotels List
extension HotelsViewController {
    func updateHotelsList(jsonData: JSON) {
        if jsonData.exists() {
            let rawHotelsList = jsonData[].arrayValue
            if rawHotelsList.count > 0 {
                parserHotelsList(rawHotelsList: rawHotelsList)
                
                DispatchQueue.main.async {
                    self.cellHeights = self.getCellHeights(self.hotels)
                    self.onDataRecieved(self.hotels)
                    self.hotelsCollectionView.reloadData()
                }
            } else {
                showAlert("No Data Available")
            }
        }
    }
}

//MARK: - Parse JSON
extension HotelsViewController {
    func parserHotelsList(rawHotelsList: [JSON]) {
        rawHotelsList.forEach( { hotels.append( Hotel(id: $0["id"].int ?? 0,
                                                      name: $0["name"].string ?? "",
                                                      address: $0["address"].string ?? "",
                                                      rating: $0["stars"].double ?? 0.0,
                                                      distance: $0["distance"].double ?? 0.0,
                                                      vacantRoomsCount: self.getVacantRoomCount($0["suites_availability"].string ?? "")))
        } )
    }
}

//MARK:- UICollectionView
extension HotelsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellHeights.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HotelCollectionViewCell.self),
                                                         for: indexPath) as? HotelCollectionViewCell {
            cell.initialize(hotels[displayOrder[indexPath.item]])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: cellHeights[displayOrder[indexPath.item]])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(identifier: "HotelInfoViewController") as? HotelInfoViewController
            vc?.id = hotels[displayOrder[indexPath.item]].id
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "HotelInfoViewController") as? HotelInfoViewController
            vc?.id = hotels[displayOrder[indexPath.item]].id
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

// MARK:- Fake collection view
extension HotelsViewController {
    func collectionView(_ displayItemAt: Int) {
        setCollectionViewCell(hotels[displayOrder[displayItemAt]])
    }

    func setCollectionViewCell(_ dataToDisplay: Hotel?) {
        if let dataToDisplay = dataToDisplay {
            print(dataToDisplay.id)
        }
    }
}

// MARK:- Data handling
extension HotelsViewController {
    func onDataRecieved (_ raw: [Hotel]) {
        hotels             = raw
        displayOrder       = Array(0..<raw.count)
    }
}

//MARK:- Utils
extension HotelsViewController {
    func getCellHeights(_ hotels: [Hotel]) -> [CGFloat] {
        
        return hotels.map{  $0.name.getHight(for: UIScreen.main.bounds.width - HotelCollectionViewCell.Constants.horisontalPaddings, with: UIFont.boldSystemFont(ofSize: 25)) +
                            $0.address.getHight(for: UIScreen.main.bounds.width - HotelCollectionViewCell.Constants.horisontalPaddings) +
                            HotelCollectionViewCell.Constants.verticalSpacing }
    }

    func getHotelIndexById(_ id: Int) -> Int? {
        hotels.enumerated().first{ $0.1.id == id }?.0
    }

    func getVacantRoomCount(_ raw: String) -> Int {
        return raw.split(separator: ":").count
    }
}

// MARK:- Sorting
extension HotelsViewController {
    func getComparator(_ filterOptions: Set<FilteringOption>) -> ((Hotel, Hotel) -> Bool)? {
        switch filterOptions.count {
        case 1:
            return getComparatorForSingleOption(filterOptions.first)
        case 2:
            return getComparatorForTwoOptions(filterOptions)
        default:
            return nil
        }
    }
    
    func getComparatorForSingleOption(_ filteringOption: FilteringOption?) -> ((Hotel, Hotel) -> Bool)? {
        switch filteringOption {
        case .byDistance:
            return { (lhs, rhs) in lhs.distance < rhs.distance }
        case .byRoomAvailability:
            return { (lhs, rhs) in lhs.vacantRoomsCount > rhs.vacantRoomsCount }
        case .none:
            return nil
        }
    }
    
    func getComparatorForTwoOptions(_ filterOptions: Set<FilteringOption>) -> ((Hotel, Hotel) -> Bool)? {
        if filterOptions.contains(.byDistance) && filterOptions.contains(.byRoomAvailability) {
            return { (lhs, rhs) -> Bool in
                if lhs.distance < rhs.distance {
                    return true
                } else if lhs.distance ==  rhs.distance && lhs.vacantRoomsCount > rhs.vacantRoomsCount{
                    return true
                }
                
                return false
            }
        }
        
        return nil
    }
}

// MARK:- Filterable
extension HotelsViewController {
    func filter(by filteringOptions: Set<FilteringOption>) {
        if self.filteringOptions != filteringOptions {
            if filteringOptions.isEmpty{
                displayOrder = Array(0..<hotels.count)
            } else {
                if let comparator = getComparator(filteringOptions) {
                    displayOrder = hotels.sorted(by: comparator).compactMap{ getHotelIndexById($0.id) }
                }
            }
            
            self.filteringOptions = filteringOptions
            
            needRefreshData = true
        }
    }
}

// MARK:- UI handlers
extension HotelsViewController {
    func onSortingTapped() {
        if let hotelsFilterVC = HotelsFiltersViewController.create(filteringOptions) {
            hotelsFilterVC.filterableDegate = self
            hotelsFilterVC.modalPresentationStyle = .formSheet
            present(hotelsFilterVC, animated: true, completion: nil)
            self.visualEffectView.alpha = 1
        }
    }
}

//MARK: - Acvtivity Indicator
extension HotelsViewController {
    func showActivityIndicator(uiView: UIView) {
        let container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(red: 163/255, green: 163/255, blue: 163/255, alpha: 0.3)

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2,
                                           y: loadingView.frame.size.height / 2)
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
        
        self.activityIndicator = activityIndicator
        self.loadingView = loadingView
        self.container = container
    }
    
    func hideActivityIndicator(_ uiView: UIView) {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        loadingView.removeFromSuperview()
        container.removeFromSuperview()
    }
}

//MARK: - Custom buttom
@IBDesignable extension UIButton {
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        } get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        } get {
            return layer.cornerRadius
        }
    }
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        } get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

// MARK:- Error Alert
extension UIViewController {
    func showAlert(_ errorMassage: String) {
        let alert = UIAlertController(title: "An Error occured", message: errorMassage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK:  Haptic
extension HotelsViewController {
    @objc func tapped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
    }
}
