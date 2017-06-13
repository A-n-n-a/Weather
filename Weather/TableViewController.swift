//
//  TableViewController.swift
//  Weather
//
//  Created by Anna on 10.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=London&APPID=c50391d958cdbde9e137158a91a1c8e3")
    
//    var cityName = String()
//    var temp = Int()
//    var desc = String()
//    var icon = String()
    
    var cities = [String]()
    var temperatures = [Int]()
    var descriptions = [String]()
    var icons = [String]()
    
    var data = ["Dog", "Cat"]
    var filteredData = [String]()
    
    var isSearching = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done

        
        let weatherObject = NSData(contentsOf: url!)
        //if weatherObject != nil {
        print("WEATHER OBJECT:\n \(String(describing: weatherObject))")
        
       
        
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
    
    
    func stringIconToImage (strIcon: String) -> UIImage {
        let iconImage = UIImage(named: strIcon)
//        print(iconImage)
        return iconImage!
    }
    
    func kelvinToCelcius (kelvin: Int) -> Int {
        return Int(Float(kelvin) - 273.15)
    }



    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return cities.count
//    }

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//       print("CITIES COUNT 2: \(self.cities.count)")
//        return self.cities.count
        if isSearching {
            return filteredData.count
        } else {
            return cities.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        var text: String
        if isSearching {
            text = filteredData[indexPath.row]
        } else {
            text = cities[indexPath.row]
        }
        
        cell.cityNameLabel?.text = text
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            tableView.reloadData()
        } else {
            isSearching = true
            filteredData = data.filter({$0 == searchBar.text})
            tableView.reloadData()
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    

}
