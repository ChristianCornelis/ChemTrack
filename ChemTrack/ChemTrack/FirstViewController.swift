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

class FirstViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{
    var theWeather = RetrieveWeather()
    let lctn = CLLocationManager()
    let elements = ["horse", "cat", "dog", "potato","horse", "cat", "dog", "potato","horse", "cat", "dog", "potato"]
    var sprays = [SprayClass]()
    
    
    @IBOutlet var theTableView: UITableView!
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
        let anObj1 = SprayClass(Name: "Spray 1", fieldName: "Birch Street Field", fieldSize: "2 acres", date: "somedate", weather: "24C", tank: 2)
        let anObj2 = SprayClass(Name: "Spray 2", fieldName: "Birch Street Field", fieldSize: "2 acres", date: "somedate", weather: "24C", tank: 2)
        
        
        sprays.append(anObj1)
        sprays.append(anObj2)
        
        theTableView.delegate = self
        theTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = theTableView.dequeueReusableCell(withIdentifier: "customCell") as! customDisplayCell
        //cell.name_lbl.text = sprays[indexPath.row].Name
        //cell.name_lbl.text = sprays[indexPath.row].Name
        /*cell.fieldName_lbl.text = sprays[indexPath.row].fieldName
        cell.fieldSize_lbl.text = sprays[indexPath.row].fieldSize
        cell.date_lbl.text = sprays[indexPath.row].Date
        cell.weather_lbl.text = sprays[indexPath.row].weather
        cell.tanks_lbl.text = String(sprays[indexPath.row].tank)*/
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
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

