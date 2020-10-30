//
//  ViewController.swift
//  RestHotels
//
//  Created by Tambanco on 24.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, CanReceive {
    
    var hotels = [DataModel]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filtersButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createSpinnerView()
        collectionView.dataSource = self
    //MARK: - Networking
        
        let url = URL(string: "https://raw.githubusercontent.com/iMofas/ios-android-test/master/0777.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do{
                    self.hotels = try JSONDecoder().decode([DataModel].self, from: data!)
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
        cell.starsLabel.text = String("Stars: \(hotels[indexPath.row].stars)")
        cell.distanceLabel.text = String("Distance: \(hotels[indexPath.row].distance)")
        cell.suitesAvailabilityLabel.text = String("Vacant Room: \(hotels[indexPath.row].suites_availability)")
        return cell
    }
    
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFilters", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToFilters"{
            let filtersVC = segue.destination as! FiltersViewController
            filtersVC.sourceHotels = self.hotels
            filtersVC.delegate = self
        }
    }
    func dataReceived(data: [DataModel]) {
        hotels.sort {$0.distance < $1.distance}
        self.collectionView.reloadData()
        
    }
    //MARK: - Spinner View Function
    
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
