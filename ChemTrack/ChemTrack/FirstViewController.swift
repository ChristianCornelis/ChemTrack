//
//  FirstViewController.swift
//  ChemTrack
//
//  Created by Christian Cornelis on 2018-03-26.
//  Copyright © 2018 Christian Cornelis. All rights reserved.
//

import UIKit
import CoreLocation

struct saveContent {
    let windSpeed: Double?
    let windDirection: Int?
    let dailyMax: Double?
    let dailyMin: Double?
    let temp: Double?
    let description: String?
}
class FirstViewController: UIViewController, CLLocationManagerDelegate {
    var theWeather = RetrieveWeather()
    let lctn = CLLocationManager()
    
    @IBAction func weatherFunc(_ sender: Any) {
        lctn.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            lctn.delegate = self
            lctn.desiredAccuracy = kCLLocationAccuracyKilometer
            lctn.startUpdatingLocation()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        var currentLocation: CLLocation!
//        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
//            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
//
//            currentLocation = lctn.location
//
//        }
//        print("currentlocation = lat:\(currentLocation.coordinate.latitude) long: \(currentLocation.coordinate.longitude)")
//        theWeather.getWeather(Latitude: "43.5448048", Longitude: "-80.2481666")
        // changed by gurjap i wonder if this works
        // gurjap branch test
        //hello from gurjap
        // Do any additional setup after loading the view, typically from a nib.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            lctn.stopUpdatingLocation()
            theWeather.getWeather(Latitude: String(location.coordinate.latitude), Longitude: String(location.coordinate.latitude))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print ("hello world")
        // Dispose of any resources that can be recreated.
        //hello from christian
    }


}

