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
import SDWebImage

protocol Informational
{
    
}

class HotelInfoViewController: UIViewController
{
    //MARK: - Properties
    var urlHotelInfo = "https://raw.githubusercontent.com/iMofas/ios-android-test/master/"
    var urlImage 	 = "https://github.com/iMofas/ios-android-test/raw/master/"
    var id: Int 	 = 0
    var imageID 	 = ""

    //MARK: - Outlets
    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var addressView: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var vacantRoomsLabel: UILabel!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
}

//MARK: - Life cycle
extension HotelInfoViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        requestData(url: createIdURL(urlHotelInfo: urlHotelInfo, id: id))
    }
}

//MARK: - Networking
extension HotelInfoViewController
{
    func requestData(url: String)
    {
        AF.request(url).responseJSON { response in
            switch response.result
            {
                case .success(let value):
                    let json = JSON(value)
                    self.updateUI(jsonData: json)
                case .failure(let error):
                    print(error)
                    self.showAlert("\(error)")
            }
        }
    }
    
    func loadImage(urlImage: String)
    {
        hotelImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
        hotelImageView.sd_setImage(with: URL(string: urlImage)) { (image, error, cache, urls) in
        self.hotelImageView.layer.cornerRadius = 20
        self.hotelImageView.clipsToBounds = true
            
            if (error != nil)
            {
                self.hotelImageView.image = UIImage(named: "placeholder.jpg")
            }
            else
            {
                self.hotelImageView.image = self.cropToBounds(image: (image ?? UIImage(named: "placeholder.jpg"))!, width: 350, height: 200)
            }
        }
    }
}

//MARK: - Crop Image
extension HotelInfoViewController
{
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        if contextSize.width > contextSize.height
        {
            posX = 1.0
            posY = 1.0
            cgwidth = contextSize.width
            cgheight = contextSize.height
        }
        else
        {
            posX = 1.0
            posY = 1.0
            cgwidth = contextSize.width
            cgheight = contextSize.height
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth - 2.0, height: cgheight - 2.0)
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
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
                parserHotelInfo(rawHotelInfo: rawHotelInfo)
            }
        }
    }
    
    func setupLabels()
    {
        titleView.font = UIFont.boldSystemFont(ofSize: 25.0)
        titleView.lineBreakMode = .byWordWrapping
        titleView.numberOfLines = 2
        
        addressView.font = UIFont.boldSystemFont(ofSize: 17.0)
        addressView.lineBreakMode = .byWordWrapping
        addressView.numberOfLines = 2
    }
}

//MARK: - Parse JSON
extension HotelInfoViewController
{
    func parserHotelInfo(rawHotelInfo: [String : JSON])
    {
        titleView.text = rawHotelInfo["name"]?.stringValue ?? ""
        addressView.text = rawHotelInfo["address"]?.stringValue ?? ""
        starsLabel.text = rawHotelInfo["stars"]?.stringValue ?? ""
        distanceLabel.text = String(format: "%.2f", rawHotelInfo["distance"]?.doubleValue ?? 0)
        vacantRoomsLabel.text = rawHotelInfo["suites_availability"]?.stringValue ?? ""
        
        imageID = rawHotelInfo["image"]?.stringValue ?? ""
        loadImage(urlImage: createImageURL(urlImage: urlImage, imageID: imageID))
        setupLabels()
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
