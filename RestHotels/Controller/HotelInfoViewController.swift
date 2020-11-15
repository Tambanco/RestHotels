//
//  HotelFilterViewController.swift
//  RestHotels
//
//  Created by Tambanco on 15.11.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol Informational {
    
}

class HotelInfoViewController: UIViewController
{
    
    //MARK: - Properties
    var urlHotelInfo = "https://raw.githubusercontent.com/iMofas/ios-android-test/master/40611.json"
    var id = 0

    //MARK: - Outlets
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var addressView: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var vacantRoomsLabel: UILabel!
}

//MARK: - Life cycle
extension HotelInfoViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}

//MARK: - Networking
extension HotelInfoViewController
{
    func requestData(url: String)
    {
        AF.request(url)
            .responseJSON { response in
            switch response.result
            {
                case .success(let value):
                    let json = JSON(value)
                    self.updateUI(jsonData: json)
                   
                case .failure(let error):
                    print(error)
            }
        }
    }
}

//MARK: - Update UI
extension HotelInfoViewController
{
    func updateUI(jsonData: JSON)
    {
        
    }
}
