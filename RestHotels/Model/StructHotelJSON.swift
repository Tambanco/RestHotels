//
//  DataModel.swift
//  RestHotels
//
//  Created by Tambanco on 28.10.2020.
//  Copyright © 2020 Tambanco. All rights reserved.
//

import UIKit

struct StructHotelJSON: Decodable
{
    var id: Int
    var name: String
    var address: String
    var stars: Double
    var distance: Double
    var suites_availability: String
}
