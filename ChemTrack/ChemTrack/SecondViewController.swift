//
//  SecondViewController.swift
//  ChemTrack
//
//  Created by Christian Cornelis on 2018-03-26.
//  Copyright © 2018 Christian Cornelis. All rights reserved.
//

import UIKit
import SQLite
class SecondViewController: UIViewController {
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
    @IBOutlet weak var chemTypeInput: UITextField!
    @IBOutlet weak var fieldInput: UITextField!
    @IBOutlet weak var fieldSizeInput: UITextField!
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var rateInput: UITextField!
    @IBOutlet weak var weatherInput: UITextField!
    @IBOutlet weak var tankSizeInput: UITextField!
    
    @IBAction func saveChemical(_ sender: UIButton) {
        print(chemNameInput.text!)
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
    
    func createChemical(){
        let chemNameToAdd = chemNameInput.text
        let chemTypeToAdd = chemTypeInput.text
        let fieldToAdd = fieldInput.text
        let fieldSizeToAdd = Double(fieldSizeInput.text!)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateToAdd = dateFormatter.string(from: dateInput.date)
        print(date)
        let locationToAdd = locationInput.text
        let rateToAdd = Double(rateInput.text!)
        let weatherToAdd = weatherInput.text
        let tankSizeToAdd = Double(tankSizeInput.text!)
        
        /*print(chemNameToAdd)
        print(chemTypeToAdd)
        print(fieldToAdd)
        if (chemNameToAdd == "" || chemTypeToAdd == "" || fieldToAdd == "" || fieldSizeToAdd == nil)
        {
            let alert = UIAlertController(title: "ErrorHandle", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")}))
            present(alert, animated: true, completion: nil)
        }
        else if (dateToAdd == "" || locationToAdd == "" || rateToAdd == nil || weatherToAdd == "" || tankSizeToAdd == nil)
        {
            let alert = UIAlertController(title: "ErrorHandle", message: "Please fill in all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")}))
            present(alert, animated: true, completion: nil)
        }
        else{*/
        let insertChemical = self.chemicalsTable.insert(self.chemName <- chemNameToAdd!, self.chemType <- chemTypeToAdd!, self.field <- fieldToAdd!, self.fieldSize <- fieldSizeToAdd!, self.date <- dateToAdd, self.location <- locationToAdd!, self.rate <- rateToAdd!, self.weather <- weatherToAdd!, self.tankSize <- tankSizeToAdd!)
        
        do{
            try self.db.run(insertChemical)
            print("Chemical inserted successfully")
            let chemicals = try self.db.prepare(self.chemicalsTable)
            for chemical in chemicals{
                print("chemical: \(chemical[self.chemName])")
                print("date: \(chemical[self.date])")
            }
        }
        catch{
            print(error)
        }
        //}
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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

