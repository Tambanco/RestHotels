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
    var urlHotelInfo = "https://raw.githubusercontent.com/iMofas/ios-android-test/master/"
    var urlImage = "https://github.com/iMofas/ios-android-test/raw/master/"
    var id = 0
    var imageID = ""

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
        
        requestData(url: createIdURL(urlHotelInfo: urlHotelInfo, id: id))
        loadImage(urlImage: createImageURL(urlImage: urlImage, imageID: imageID))
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
    
    func loadImage(urlImage: String)
    {
        AF.request(urlImage, method: .get).response{ response in
            switch response.result
            {
            case .success(let responseData):
                self.hotelImageView.image = UIImage(data: responseData!, scale: 1)
                
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
        if jsonData.exists()
        {
            let rawHotelInfo = jsonData[].dictionaryValue
            if rawHotelInfo.count > 0
            {
                imageID = rawHotelInfo["image"]?.stringValue ?? "no image ID"
                titleView.text = rawHotelInfo["name"]?.stringValue ?? "no name"
                addressView.text = rawHotelInfo["address"]?.stringValue ?? "no address"
                starsLabel.text = rawHotelInfo["stars"]?.stringValue ?? "no stars"
                distanceLabel.text = String(format: "%.2f", rawHotelInfo["distance"]?.doubleValue as! CVarArg) ?? "no distance"
                vacantRoomsLabel.text = rawHotelInfo["suites_availability"]?.stringValue ?? "no vacant rooms"
            }
        }
    }
}

//MARK: - Create URL
extension HotelInfoViewController
{
    func createIdURL(urlHotelInfo: String, id: Int) -> String
    {
        let urlForRequest = "\(urlHotelInfo)" + "\(id)" + ".json"
        
        return urlForRequest
    }
    
    func createImageURL(urlImage: String, imageID: String) -> String
    {
        let urlForImage = "\(urlImage)" + "\(imageID)"
        
        return urlForImage
    }
}
