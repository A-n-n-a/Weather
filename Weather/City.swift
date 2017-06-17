//
//  File.swift
//  Weather
//
//  Created by Anna on 10.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import Foundation
import UIKit

struct City {
    var name: String
    var temp: Int
    var desc: String
    var icon: UIImage
    var lon: Double
    var lat: Double
    
    init(name: String, temp: Int, desc: String, icon: UIImage, lon: Double, lat: Double) {
        
        self.name = name  
        self.temp = temp
        self.desc = desc
        self.icon = icon
        self.lon = lon
        self.lat = lat
        
    }

}
