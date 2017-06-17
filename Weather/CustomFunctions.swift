//
//  File.swift
//  Weather
//
//  Created by Anna on 14.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import Foundation
import UIKit
import Firebase 

var text = ""
//var weatherService = WeatherService()
var ref: DatabaseReference? = Database.database().reference()



//MARK: convert String to UIImage
func stringIconToImage (strIcon: String) -> UIImage {
    
    let iconImage = UIImage(named: strIcon)
    return iconImage!
}

//MARK: Convert Kelvin to Celcius
func kelvinToCelcius (kelvin: Double) -> Int {
    
    return Int(kelvin - difference)
}

//MARK: Save data to Firebase
func saveDataToFirebase(text: String) {
    
    ref?.child(citiesStr).childByAutoId().setValue(text)
    
}

//MARK: Save data to Firebase with key dictionary
//func saveDataToFirebase(text: String) {
//    
//    let reference = ref?.child(citiesStr).childByAutoId() //.setValue(text)
//    reference?.setValue(text)
//    let item = reference?.key
//    reference?.setValue(item)
//    
//}

//MARK: Retrive data from Firebase
//func retrieveDataFromDatabase() -> String {
//    
//    var item = String()
//    var cityList = [String]()
//    ref?.child(cities).observe(.childAdded, with: { (snapshot) in
//        if let value = snapshot.value as? String {
//            //cityList.append(item)
//            item = value
//            print("RETRIEVED DATA: \(item)")
//            cityList.append(item)
//            print("Internal city list count: \(cityList.count)")
//        }
//    })
//    print("Return: \(item)")
//    return item
//}

//MARK: Set weather
//func setWeather(name: String, temp: Double, description: String, icon: String) -> City {
//    
//    let iconImage = stringIconToImage(strIcon: icon)
//    let celciusTemp = kelvinToCelcius(kelvin: temp)
//    let cityDetails = City(name: name, temp: celciusTemp, desc: description, icon: iconImage, lon: <#Double#>, lat: <#Double#>)
//    
//    return cityDetails
//}


//func setCityDetails(name: String, temp: Int, description: String, icon: String) -> City {
//
//
//}
