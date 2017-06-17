//
//  CityDetailsViewController.swift
//  Weather
//
//  Created by Anna on 16.06.17.
//  Copyright © 2017 Anna. All rights reserved.
//

import UIKit
import MapKit

class CityDetailsViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var cityName = String()
    var imageName = String()
    var temperature = String()
    
    var latitude = Double()
    var longtitude = Double()
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(imageName)
        backgroundImage.image = UIImage(named: imageName)
        nameLabel?.text = cityName
        temperatureLabel?.text = temperature
        
        print("NAME: \(nameLabel?.text)")
        print("TEMP: \(temperatureLabel?.text)")
        print("LON: \(longtitude)")
        print("LAT: \(latitude)")
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longtitude)
        centerMapOnLocation(location: initialLocation)
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
