//
//  ViewController.swift
//  RestHotels
//
//  Created by Tambanco on 24.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
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
        cell.starsLabel.text = String(hotels[indexPath.row].stars).capitalized
        cell.distanceLabel.text = String(hotels[indexPath.row].distance).capitalized
        cell.suitesAvailabilityLabel.text = String(hotels[indexPath.row].suites_availability).capitalized
        return cell
    }
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFilters", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let filtersVC = segue.destination as! FiltersViewController
        filtersVC.sourceHotels = self.hotels
    }
//    func onUserAction(data: [DataModel]){
//        let vc = FiltersViewController(nibName: "FiltersViewController", bundle: nil)
//        vc.viewConroller = self
//        print(data)
//    }
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