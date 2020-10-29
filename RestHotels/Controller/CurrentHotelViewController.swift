//
//  CurrentHotelViewController.swift
//  RestHotels
//
//  Created by Tambanco on 28.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

class CurrentHotelViewController: UIViewController {

    var currentHotel = [CurrentModel]()
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var starsLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var suitesAvailabilityLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initURL = URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/")
        let fullURL = URL(string: "\(initURL!)13100.json")
        URLSession.shared.dataTask(with: fullURL!) { (data, response, error) in
            if error == nil {
                    do{
                        self.currentHotel = try JSONDecoder().decode([CurrentModel].self, from: data!)
                        print(self.currentHotel)
                    }catch{
                        print(error)
                    }
                    DispatchQueue.main.async {
                    }
                }
            }.resume()
        }
}

