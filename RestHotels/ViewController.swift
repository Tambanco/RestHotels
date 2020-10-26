//
//  ViewController.swift
//  RestHotels
//
//  Created by Tambanco on 24.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

struct HotelsInfo: Decodable{
    
    var id: Int
    var name: String
    var address: String
    var stars: Double
    var distance: Double
    var suites_availability: String
    
}

class ViewController: UIViewController, UICollectionViewDataSource {

    var hotels = [HotelsInfo]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSpinnerView()
        collectionView.dataSource = self
        
        let url = URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                
                do{
                    self.hotels = try JSONDecoder().decode([HotelsInfo].self, from: data!)
                }catch{
                
                    print(error)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    
                }
            }
        }.resume()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.nameLabel.text = hotels[indexPath.row].name.capitalized
        cell.addressLabel.text = hotels[indexPath.row].address.capitalized
        cell.starsLabel.text = String(hotels[indexPath.row].stars).capitalized
        cell.distanceLabel.text = String(hotels[indexPath.row].distance).capitalized
        cell.suitesAvailabilityLabel.text = String(hotels[indexPath.row].suites_availability).capitalized
        return cell
    }
    
//MARK: - Create Spinner View Function
    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
}

