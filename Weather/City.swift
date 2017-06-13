//
//  File.swift
//  Weather
//
//  Created by Anna on 10.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import Foundation

struct City {
    var name: String
    var temp: Int
    var desc: String
    var icon: String
    //var clouds: Int
    //var rain: Int?
    //var snow: Int?

    
    /*init(name: String, temp: Int, desc: String, icon: String) { // clouds: Int, rain: Int?, snow: Int?) {
        self.name = name
        self.temp = temp
        self.desc = desc
        self.icon = icon
        //self.clouds = clouds
        //self.rain = rain
        //self.snow = snow
    }*/
    init(dictionary: [String : AnyObject]) {
        
        let main = dictionary["main"] as! [String:AnyObject]
        let weatherArray = dictionary["weather"] as! [AnyObject]
        let weatherDict = weatherArray[0] as! [String:AnyObject]
        
        //let cloud = dictionary["clouds"] as! [String : AnyObject]
        //if dictionary["rain"] != nil {
        //    let r = dictionary["rain"] as! [String : AnyObject]
        //    self.rain = r["3h"] as? Int
        //}
        //if dictionary["snow"] != nil {
        //    let s = dictionary["snow"] as! [String : AnyObject]
        //    self.snow = s["3h"] as? Int
        //}
        
        self.name = dictionary["name"] as! String
        self.temp = main["temp"] as! Int
        self.desc = weatherDict["description"] as! String
        self.icon = weatherDict["icon"] as! String
        
        
        //self.clouds = cloud["all"] as! Int
        
        
    }

}
