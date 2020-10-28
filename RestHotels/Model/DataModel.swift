//
//  DataModel.swift
//  RestHotels
//
//  Created by Tambanco on 28.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

struct DataModel: Decodable{
    
    var id: Int = 0
    var name: String = ""
    var address: String = ""
    var stars: Double = 0.0
    var distance: Double = 0.0
    var suites_availability: String = ""
    
}
