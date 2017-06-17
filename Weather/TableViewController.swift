//
//  TableViewController.swift
//  Weather
//
//  Created by Anna on 10.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TableViewController: UITableViewController {
    
 
    //var cityList = [City]()
    var cities = [String]()
    var item = String()
    var text = String()
    var id = String()
    var idArray = [String]()
    var weatherDetails: City?
    var descriptionsArray = [String]()
    var temperaturesArray = [String]()
    var latitudesArray = [Double]()
    var longtitudesArray = [Double]()

    
    
    var selectedRow = UITableViewCell()
    


    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //resets descriptions array when returns from Details View Controller
        self.descriptionsArray = []
        self.tableView.reloadData()
        
        
        //MARK: RETRIEVE DATA FROM FIREBASE
        ref?.child(citiesStr).observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? String {
                self.item = value
                self.cities.append(self.item)
                self.id = snapshot.key
                self.idArray.append(self.id)
                self.tableView.reloadData()
            }
        })

    }
    
    @IBAction func addCity(_ sender: UIBarButtonItem) {
        openCityAddAlert()
    }
    
    //MARK: ALERT
    func openCityAddAlert() {
        let alert = UIAlertController(title: addCityStr, message: enterCityName, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancel = UIAlertAction(title: cancelStr, style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: okStr, style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            
            let textField = alert.textFields?[0]  //.first
            self.text = (textField?.text!)!
            
            saveDataToFirebase(text: self.text)
            
        }
            alert.addAction(ok)
        
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = cityNameStr
        }
        self.present(alert, animated: true, completion: nil)
        
    }

    
    //MARK: number of rows
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.cities.count

    }

    //MARK: row content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cityName = String()
        var temp = Double()
        var description = String()
        var icon = String()
        var latitude = Double()
        var longtitude = Double()
        
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        
        print("Cities Array COUNT: \(cities.count)")
        
        
        cityName = cities[indexPath.row]

            let cityAddingPercentEncoding = cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            
            let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityAddingPercentEncoding!)&APPID=c50391d958cdbde9e137158a91a1c8e3")
            
            
            
            //JSON Open Weather Map with SwiftyJSON
            let session = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                if error != nil {
                    print("Error: \(String(describing: error))")
                } else {
                    
                    let json = JSON(data)
                    cityName = json[nameStr].stringValue
                    //print("CITY: \(cityName)")
                    temp = json[mainStr][tempStr].double!
                    let celcTemp = kelvinToCelcius(kelvin: temp)
                    var tempString = emptyStr
                            if celcTemp > 0 {
                                tempString = plusStr + String(celcTemp) + degreeStr
                            } else {
                                tempString = String(celcTemp) + degreeStr
                            }
                    latitude = json[coordStr][latStr].double!
                    self.latitudesArray.append(latitude)
                    longtitude = json[coordStr][lonStr].double!
                    self.longtitudesArray.append(longtitude)

                   
                    //print("TEMP: \(tempString)")
                    self.temperaturesArray.append(tempString)
                    description = json[weatherStr][0][descriptionStr].stringValue
                    self.descriptionsArray.append(description)
                    //print("DESCRIPTION: \(description)")
                    icon = json[weatherStr][0][iconStr].stringValue
                    let iconImage = stringIconToImage(strIcon: icon)
                    //print("ICON: \(icon)")
                    
                    
                    self.weatherDetails = City(name: cityName, temp: celcTemp, desc: description, icon: iconImage, lon: longtitude, lat: longtitude)
                    
                    DispatchQueue.main.async {
                        //city Name displays as it was input by user
                        cell.cityNameLabel?.text = self.cities[indexPath.row]
                        //city name displays as it is in JSON
                        //cell.cityNameLabel?.text = weatherDetails?.name
                        cell.descriptionLabel?.text = self.weatherDetails?.desc
                        cell.temperatureLabel?.text = tempString
                        cell.iconImageView?.image = self.weatherDetails?.icon
                    }
                    
                }
                
            }
            session.resume()
       
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
        //delete row by swiping
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let singleId = self.idArray[indexPath.row]
            //remove data from Firebase
            ref?.child(citiesStr).child(singleId).removeValue()
           
            //remove data from table
            self.cities.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    //MARK: PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destViewController = segue.destination as! CityDetailsViewController
        
        //парсим массив на структуры, индекс элемента массива - номер выбранной строки
        
        let selectedRowIndex = self.tableView.indexPathForSelectedRow
        selectedRow = self.tableView.cellForRow(at: selectedRowIndex!)!
//        let descr = selectedRow.description
//        print("DESCR: \(descr)")
//        let selectedCell = Cell[selectedRowIndex?.row]
//        print(selectedCell.descriptionLabel?.text)
        
        var n = 0
        print("Description count: \(descriptionsArray.count)")
        for i in descriptionsArray {
            
            print("\(n) - \(i)")
            let singleDescription = descriptionsArray[(selectedRowIndex?.row)!]
            if i == singleDescription {
                destViewController.imageName = singleDescription                   //selectedRow.description //.descriptionLabel?.text//(weatherDetails?.desc)!  //self.cell.descriptionLabel?.text
            }  else if singleDescription.range(of: rainStr) != nil {
                destViewController.imageName = rainStr
            }  else if singleDescription.range(of: cloudsStr) != nil {
                destViewController.imageName = cloudsStr
            }
            
            n += 1
        }
        n = 0
        for i in cities {
            print("\(n) - \(i)")
             n += 1
        }
        let singleCity = cities[(selectedRowIndex?.row)!]
        print("SINGLE CITY: \(singleCity)")
        destViewController.cityName = singleCity
        destViewController.temperature = self.temperaturesArray[(selectedRowIndex?.row)!]
        destViewController.latitude = self.latitudesArray[(selectedRowIndex?.row)!]
        destViewController.longtitude = self.longtitudesArray[(selectedRowIndex?.row)!]
        
//        print(channels.count)
//        print(channelsArray.count)
        
        
//        let newChannel = channelsArray[(selectedRowIndex?.row)!]
//        destViewController.textMessagesArray = textMessagesArray
//        //destViewController.sender = interlocutorsArray[(selectedRowIndex?.row)!]
//        
//        destViewController.senderDisplayName = interlocutorsArray[(selectedRowIndex?.row)!]
//        destViewController.channel = newChannel
//        destViewController.channelRef = channelRef.child(String(newChannel.channelID))
//        destViewController.avatarImage = newChannel.photo
//        destViewController.dateArray = messageDateArray
//        destViewController.sendersNameArray = sendersArray
    }
    


    

}
