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
    let areaData2:[String] = ["acre", "ha"]
    
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
        else if (pickerView.tag == 5){
            return areaData2[row]
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
        else if (pickerView.tag == 5){
            return areaData2.count
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
    let numTanks = Expression<Double>("numTanks")
    let amountOfProduct = Expression<Double>("amountOfProduct")

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
    @IBOutlet weak var humidityInput: UITextField!
    
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
        humidityInput.text = ""
    }
    @IBAction func saveChemical(_ sender: UIButton) {
        createChemical()
        /*let storyBoard: UIStoryboard = UIStoryboard(name: "First", bundle: nil)
        let nextViewCtrl = storyBoard.instantiateViewController(withIdentifier: "First")
        self.presentView*/
    }
    
    
    @IBAction func resetBtnAction(_ sender: Any) {
        clearInputs()
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
            t.column(self.numTanks)
            t.column(self.amountOfProduct)
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
        var fieldSizeToAdd = Double(fieldSizeInput.text!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateToAdd = dateFormatter.string(from: dateInput.date)
        print(date)
        let locationToAdd = locationInput.text
        var rateToAdd = Double(rateInput.text!)
        var weatherToAdd = ""
        let windSpeed = windSpeedInput.text
        let windDirection = Double(windDirectionInput.text!)
        let temperature = tempInput.text
        var tankSizeToAdd = Double(tankSizeInput.text!)
        let humidityToAdd = humidityInput.text
        //checking if some input fields are blank
        if (chemNameToAdd == "" || chemTypeToAdd == "" || fieldToAdd == "" || fieldSizeToAdd == nil || temperature == "")
        {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The error alert occured.")}))
            present(alert, animated: true, completion: nil)
        }
        //checking if EVEN MORE input fields are blank
        else if (dateToAdd == "" || locationToAdd == "" || rateToAdd == nil || tankSizeToAdd == nil)
        {
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The error alert occured.")}))
            present(alert, animated: true, completion: nil)
        }
        //what could this be? YUP YOU GUESSED IT, more input field checking because Swift can't check logical conditions to save its life
        else if (windSpeed == "" || windDirection == nil || humidityToAdd == ""){
            let alert = UIAlertController(title: "Error", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The error alert occured.")}))
            present(alert, animated: true, completion: nil)
        }
        //if all input fields are filled
        else{
            weatherToAdd.append(temperature!)
            weatherToAdd.append(",")
            weatherToAdd.append(windSpeed!)
            weatherToAdd.append(",")
            weatherToAdd.append(String(describing: Int(windDirection!)))
            weatherToAdd.append(",")
            weatherToAdd.append(humidityToAdd!)
            print(weatherToAdd)
            let fieldUnits = areaData[fieldSizePicker.selectedRow(inComponent: 0)]
            let rateAreaUnits = areaData[ratePicker2.selectedRow(inComponent: 0)]
            let rateLiquidUnits = liquidData[ratePicker1.selectedRow(inComponent: 0)]
            let tankUnits = liquidData[tankPicker.selectedRow(inComponent: 0)]
            
            if tankUnits == "gal"{
                tankSizeToAdd = tankSizeToAdd! * 3.78541
            }
            
            if (rateLiquidUnits == "gals per" && rateAreaUnits == "acre"){
                rateToAdd = rateToAdd! * 9.35396
            }
            else if (rateLiquidUnits == "L per" && rateAreaUnits == "acre"){
                rateToAdd = rateToAdd! * 2.47105381
            }
            else if (rateLiquidUnits == "gals per" && rateAreaUnits == "ha"){
                rateToAdd = rateToAdd! * 3.78541178
            }
            
            if fieldUnits == "acres"{
                fieldSizeToAdd = fieldSizeToAdd! * 2.47105
            }
            
            let liquidUsedToAdd:Double = Double(fieldSizeToAdd!) * Double(rateToAdd!)
            let numTanksToAdd:Double = liquidUsedToAdd/Double(tankSizeToAdd!)
            print(fieldUnits)
            print(rateAreaUnits)
            print(rateLiquidUnits)
            print(tankUnits)
            
            
            let insertChemical = self.chemicalsTable.insert(self.chemName <- chemNameToAdd!, self.chemType <- chemTypeToAdd, self.field <- fieldToAdd!, self.fieldSize <- fieldSizeToAdd!, self.date <- dateToAdd, self.location <- locationToAdd!, self.rate <- rateToAdd!, self.weather <- weatherToAdd, self.tankSize <- tankSizeToAdd!, self.numTanks <- numTanksToAdd, self.amountOfProduct <- liquidUsedToAdd)
            
            do{
                try self.db.run(insertChemical)
                print("Chemical inserted successfully")
                let chemicals = try self.db.prepare(self.chemicalsTable)
                for chemical in chemicals{
                    print("chemical: \(chemical[self.chemName])")
                    print("date: \(chemical[self.date])")
                    print("weather: \(chemical[self.weather])")
                    print("id: \(chemical[self.rowID])")
                    print("type: \(chemical[self.chemType])")
                    print("numTanks: \(chemical[self.numTanks])")
                    print("productUsed: \(chemical[self.amountOfProduct])")
                
                }
                clearInputs()
//                self.navigationController?.pushViewController(FirstViewController, animated: true)
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

