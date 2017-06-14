//
//  TableViewController.swift
//  Weather
//
//  Created by Anna on 10.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    // connect up to Firebase
    var ref: DatabaseReference? = Database.database().reference()
    
    
    //var city = ""
    // var cityEscaped = city.stringByAddingEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
    
    //    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&APPID=c50391d958cdbde9e137158a91a1c8e3")
    
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=London&APPID=c50391d958cdbde9e137158a91a1c8e3")
    
//    var cityName = String()
//    var temp = Int()
//    var desc = String()
//    var icon = String()
    
    var cityList = [String]()
    var cities = [String]()
    var temperatures = [Int]()
    var descriptions = [String]()
    var icons = [String]()
    
    var text = String()
    
    var data = ["Dog", "Cat"]
    var filteredData = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let weatherObject = NSData(contentsOf: url!)
        //if weatherObject != nil {
        //print("WEATHER OBJECT:\n \(String(describing: weatherObject))")
        
        //JSON Open Weather Map
        let session = URLSession.shared.dataTask(with: url!) { (data, response, error) in
        //let session = URLSession.shared.downloadTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print("Error: \(String(describing: error))")
            } else {
                if let content = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        //print(json)
                        let dict = json as! [String:AnyObject]
                        let city = City(dictionary: dict)
                        self.cities.append(city.name)
                        print("CITIES COUNT: \(self.cities.count)")
                        self.temperatures.append(city.temp)
                        self.descriptions.append(city.desc)
                        self.icons.append(city.icon)
                        
                        self.tableView.reloadData()
                        
//                        self.cityName = city.name   //dict["name"] as! String
//                        //print(self.cityName)
//                        self.temp = city.temp  //main["temp"] as! Int
//                        print(self.temp)
//                        self.desc = city.desc
//                        print(self.desc)
//                        self.icon = city.icon
//                        print(self.icon)
//                        self.stringIconToImage(strIcon: self.icon)
                        
                        
                    } catch {
                      print("ERROR: \(error)")
                    }
                }
                
                
            }
            
        }
        session.resume()
    }
    
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        openCityAddAlert()
    }
    
    func stringIconToImage (strIcon: String) -> UIImage {
        let iconImage = UIImage(named: strIcon)
//        print(iconImage)
        return iconImage!
    }
    
    func kelvinToCelcius (kelvin: Int) -> Int {
        return Int(Float(kelvin) - 273.15)
    }
    
    func openCityAddAlert() {
        let alert = UIAlertController(title: "Add city", message: "Enter city name", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            print("OK")
            let textField = alert.textFields?[0]  //.first
            self.text = (textField?.text!)!
            //self.cityList.append(text!)
            
            self.saveDataToFirebase(text: self.text)
            
            print(self.text)
        }
            alert.addAction(ok)
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = "City Name"
        }
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func saveDataToFirebase(text: String) {
        self.ref?.child("cities").childByAutoId().setValue(text)
        
//        let cityItemRef = self.ref?.child(text)
//        //let cityItemRef = self.ref?.child("cityList").childByAutoId()
//        cityItemRef?.setValue(text)

    }
    
    func retrieveDataFromDatabase() {
        //self.cityList.append(text!)
        var handle: DatabaseHandle = (ref?.child("cities").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String {
                self.cityList.append(item)
                self.tableView.reloadData()
            }
        }))!
    }
    



    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return cities.count
//    }

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       print("CITIES COUNT 2: \(self.cities.count)")
        
        return self.cities.count

        //return cityList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        

        
        cell.cityNameLabel?.text = cities[indexPath.row] //cityName
        cell.descriptionLabel?.text = descriptions[indexPath.row]
        let temp = kelvinToCelcius(kelvin: temperatures[indexPath.row])
        var tempString = ""
        if temp > 0 {
            tempString = "+" + String(temp) + "\u{00B0}C"
        } else {
            tempString = String(temp) + "\u{00B0}C"
        }
        cell.temperatureLabel?.text = tempString
        cell.iconImageView?.image = self.stringIconToImage(strIcon: icons[indexPath.row])
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    

}
