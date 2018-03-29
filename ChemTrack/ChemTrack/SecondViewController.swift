//
//  SecondViewController.swift
//  ChemTrack
//
//  Created by Christian Cornelis on 2018-03-26.
//  Copyright © 2018 Christian Cornelis. All rights reserved.
//

import UIKit
import SQLite
import CoreLocation

class SecondViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let areaData:[String] = ["acres", "ha"]
    let rateData:[String] = ["L per", "gals per"]
    let liquidData:[String] = ["L", "gal"]
    let chemicalTypes:[String] = ["Herbicide", "Fertilizer", "Pesticide", "Fungicide"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return areaData[row]
        }
        else if (pickerView.tag == 3){
            return rateData[row]
        }
        else if (pickerView.tag == 4){
            return chemicalTypes[row]
        }
        else{
            return liquidData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1{
            return areaData.count
        }
        else if pickerView.tag == 3{
            return rateData.count
        }
        else if pickerView.tag == 4{
            return chemicalTypes.count
        }
        else{
            return liquidData.count
        }
    }
    
    var db: Connection!
    let chemicalsTable = Table("chemicals")
    let rowID = Expression<Int>("rowID")
    let chemName = Expression<String>("chemName")
    let chemType = Expression<String>("chemType")
    let field = Expression<String>("field")
    let fieldSize = Expression<Double>("fieldSize")
    let date = Expression<String>("date")
    let location = Expression<String>("location")
    let rate = Expression<Double>("rate")
    let weather = Expression<String>("weather")
    let tankSize = Expression<Double>("tankSize")

    //input field declarations
    @IBOutlet weak var chemNameInput: UITextField!
    @IBOutlet weak var fieldInput: UITextField!
    @IBOutlet weak var fieldSizeInput: UITextField!
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var rateInput: UITextField!
    @IBOutlet weak var tankSizeInput: UITextField!
    @IBOutlet var humidity: UITextField!
    @IBOutlet weak var windDirectionInput: UITextField!
    @IBOutlet weak var windSpeedInput: UITextField!
    @IBOutlet weak var tempInput: UITextField!
    @IBOutlet weak var fieldSizePicker: UIPickerView!
    @IBOutlet weak var ratePicker1: UIPickerView!
    @IBOutlet weak var ratePicker2: UIPickerView!
    @IBOutlet weak var tankPicker: UIPickerView!
    @IBOutlet weak var chemicalTypePicker: UIPickerView!
    
    func clearInputs(){
        tankSizeInput.text = ""
        windDirectionInput.text = ""
        windSpeedInput.text = ""
        tempInput.text = ""
        rateInput.text = ""
        chemNameInput.text = ""
        fieldInput.text = ""
        fieldSizeInput.text = ""
        locationInput.text = ""
    }
    @IBAction func saveChemical(_ sender: UIButton) {
        createChemical()
    }
    
    func createDB(){
        let toCreate = self.chemicalsTable.create { (t) in
            t.column(self.rowID, primaryKey: true)
            t.column(self.chemName)
            t.column(self.chemType)
            t.column(self.field)
            t.column(self.fieldSize)
            t.column(self.date)
            t.column(self.location)
            t.column(self.rate)
            t.column(self.weather)
            t.column(self.tankSize)
        }
        
        do{
            try self.db.run(toCreate)
            print("Created table!")
        }
        catch{
            print(error)
        }
    }
    
    //function to retrieve all data from user input and send it in a query to the database if it is complete
    func createChemical(){
        let chemNameToAdd = chemNameInput.text
        let chemTypeToAdd = chemicalTypes[chemicalTypePicker.selectedRow(inComponent: 0)]
        print(chemTypeToAdd)
        let fieldToAdd = fieldInput.text
        let fieldSizeToAdd = Double(fieldSizeInput.text!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateToAdd = dateFormatter.string(from: dateInput.date)
        print(date)
        let locationToAdd = locationInput.text
        let rateToAdd = Double(rateInput.text!)
        var weatherToAdd = ""
        let windSpeed = windSpeedInput.text
        let windDirection = Double(windDirectionInput.text!)
        let temperature = tempInput.text
        weatherToAdd.append(temperature!)
        weatherToAdd.append(",")
        weatherToAdd.append(windSpeed!)
        weatherToAdd.append(",")
        weatherToAdd.append(String(describing: Int(windDirection!)))
        let tankSizeToAdd = Double(tankSizeInput.text!)
        
        if (chemNameToAdd == "" || chemTypeToAdd == "" || fieldToAdd == "" || fieldSizeToAdd == nil || temperature == "")
        {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The error alert occured.")}))
            present(alert, animated: true, completion: nil)
        }
        else if (dateToAdd == "" || locationToAdd == "" || rateToAdd == nil || weatherToAdd == "" || tankSizeToAdd == nil)
        {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The error alert occured.")}))
            present(alert, animated: true, completion: nil)
        }
        else if (windSpeed == "" || windDirection == nil){
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The error alert occured.")}))
            present(alert, animated: true, completion: nil)
        }
        else{
            let insertChemical = self.chemicalsTable.insert(self.chemName <- chemNameToAdd!, self.chemType <- chemTypeToAdd, self.field <- fieldToAdd!, self.fieldSize <- fieldSizeToAdd!, self.date <- dateToAdd, self.location <- locationToAdd!, self.rate <- rateToAdd!, self.weather <- weatherToAdd, self.tankSize <- tankSizeToAdd!)
            
            do{
                try self.db.run(insertChemical)
                print("Chemical inserted successfully")
                let chemicals = try self.db.prepare(self.chemicalsTable)
                for chemical in chemicals{
                    print("chemical: \(chemical[self.chemName])")
                    print("date: \(chemical[self.date])")
                    print("weather: \(chemical[self.weather])")
                    print("id: \(chemical[self.rowID])")
                clearInputs()
                }
            }
            catch{
                print(error)
            }
        }
    }
    /******functions for getting the weather*******/
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            lctn.stopUpdatingLocation()
            theWeather.getWeather(Latitude: String(location.coordinate.latitude), Longitude: String(location.coordinate.latitude)) { (isSuccess, weatherInfo) in
                if isSuccess {
//                    print("Success: \(weatherInfo)")
                    DispatchQueue.main.async {
                        self.tempInput.text = weatherInfo[0]
                        self.humidity.text = weatherInfo[1]
                        self.windSpeedInput.text = weatherInfo[3]
                        self.windDirectionInput.text = weatherInfo[4]
                    }
                    
                }else {
                    print("Failure: Unable To Get String")
                }
            }
        }
    }
    /******End of weather functions*******/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldSizePicker.delegate = self
        ratePicker1.delegate = self
        ratePicker2.delegate = self
        tankPicker.delegate = self
        chemicalTypePicker.delegate = self
        ratePicker1.dataSource = self
        fieldSizePicker.dataSource = self
        ratePicker2.dataSource = self
        tankPicker.dataSource = self
        chemicalTypePicker.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        do{
            let docDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileName = docDirectory.appendingPathComponent("chemicals").appendingPathExtension("sqlite3")
            let db = try Connection(fileName.path)
            self.db = db
        } catch{
            print(error)
        }
        createDB()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //TODO: Add layout.
        //need to import from Sketch.
    }


}

