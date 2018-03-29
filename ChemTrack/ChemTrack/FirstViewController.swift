//
//  FirstViewController.swift
//  ChemTrack
//
//  Created by Christian Cornelis on 2018-03-26.
//  Copyright © 2018 Christian Cornelis. All rights reserved.
//

import UIKit
import SQLite
struct saveContent {
    let windSpeed: Double?
    let windDirection: Int?
    let temp: Double?
    let description: String?
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var db: Connection!
    let chemicalsTable = Table("chemicals")
    var rowID = Expression<Int>("rowID")
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
    var sprays = [SprayClass]()
    var numRows = 0
    
    @IBOutlet var theTableView: UITableView!
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
    override func viewDidLoad() {
        super.viewDidLoad()
//        let anObj1 = SprayClass(Name: "Spray 1", fieldName: "Birch Street Field", fieldSize: "2 acres", date: "somedate", weather: "24C", tank: 2)
//        let anObj2 = SprayClass(Name: "Spray 2", fieldName: "Birch Street Field", fieldSize: "2 acres", date: "somedate", weather: "24C", tank: 2)
        
        
//        sprays.append(anObj1)
//        sprays.append(anObj2)
        
        theTableView.delegate = self
        theTableView.dataSource = self
        do{
            let docDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileName = docDirectory.appendingPathComponent("chemicals").appendingPathExtension("sqlite3")
            let db = try Connection(fileName.path)
            self.db = db
            //THIS CLEARS THE DATABASE USE WITH CAUTION
            //try self.db.run(chemicalsTable.drop())
        } catch{
            print(error)
        }
        createDB()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        print("now looking at data")
        do{
            let chemicals = try self.db.prepare(self.chemicalsTable)
            sprays.removeAll()
            for chemical in chemicals{
                sprays.append(SprayClass(Name: chemical[self.chemName],fieldName: chemical[self.field], fieldSize: String(chemical[self.fieldSize]), date: chemical[self.date], weather: chemical[self.weather], tank: Int(chemical[self.tankSize]), numTanks: Double(chemical[self.numTanks]),chemical: chemical[self.chemType], howMuchChemUsed: Double(chemical[self.amountOfProduct]), applicationRate: Double(chemical[self.rate]), rowID: Int(chemical[self.rowID])))
//                print("chemical: \(chemical[self.chemName])")
//                print("date: \(chemical[self.date])")
            }
            sprays = sprays.reversed()
            theTableView.reloadData()
        }
        catch{
            print(error)
        }
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sprays.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = theTableView.dequeueReusableCell(withIdentifier: "customCell") as! customDisplayCell
        cell.cellView.layer.cornerRadius = 8
        cell.name_lbl.text = sprays[indexPath.row].Name
        cell.fieldName_lbl.text = sprays[indexPath.row].fieldName
        cell.fieldSize_lbl.text = sprays[indexPath.row].fieldSize
        cell.date_lbl.text = sprays[indexPath.row].Date
        cell.chemicalType_lbl.text = sprays[indexPath.row].chemType
        cell.AmtChemicalUsed_lbl.text = String(describing: sprays[indexPath.row].AmtChemUsed!)
        cell.rateOfApplication_lbl.text = String(describing: sprays[indexPath.row].rateOfApp!)
        cell.numTanks_lbl.text = String(describing: sprays[indexPath.row].numTanks!)
//        cell.weather_lbl.text = sprays[indexPath.row].weather
        let weatherString:String = sprays[indexPath.row].weather!
        var weatherInfo = weatherString.split(separator: ",")
        if weatherInfo.count == 3 {
            cell.temp_lbl.text = String(weatherInfo[0])
            cell.windSpeed_lbl.text = String(weatherInfo[1])
            cell.windDirection_lbl.text = String(weatherInfo[2])
        }
        
        cell.tankSize_lbl.text = String(sprays[indexPath.row].tankSize)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    @IBOutlet var editButton: UIButton!
    @IBAction func editCell(_ sender: Any) {
        theTableView.isEditing = !theTableView.isEditing
        if theTableView.isEditing {
            editButton.setTitle("Done", for: .normal)
        } else {
            editButton.setTitle("Edit", for: .normal)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDel = chemicalsTable.filter(rowID == sprays[indexPath.row].idOfRow!)
            do {
                try self.db.run(toDel.delete())
            }catch{
                print(error)
            }
            /*let thisDelete = toDel.delete()
            if let changes = thisDelete.changes where changes > 0 {
                print("removed \(changes) record(s) for Alice")
            } else if delete.statement.failed {
                print("delete failed: \(delete.statement.reason)")
            }*/
//            theTableView.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
        //hello from christian
    }


}

