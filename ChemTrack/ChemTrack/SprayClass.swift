//
//  SprayClass.swift
//  ChemTrack
//
//  Created by Gurjap Singh on 2018-03-27.
//  Copyright © 2018 Christian Cornelis. All rights reserved.
//

import Foundation
class SprayClass{
    let Name: String?
    let fieldName: String?
    let fieldSize: String?
    let Date: String?
    let weather: String?
    let tankSize: Int
    let chemType: String?
    let numTanks: Double?
    let AmtChemUsed: Double?
    let rateOfApp: Double?
    let idOfRow: Int?
    init(Name:String,fieldName:String,fieldSize:String,date:String,weather:String,tank:Int,numTanks:Double,chemical: String, howMuchChemUsed: Double, applicationRate: Double, rowID: Int) {
        self.Name = Name
        self.fieldName = fieldName
        self.fieldSize = fieldSize
        self.Date = date
        self.weather = weather
        self.tankSize = tank
        self.chemType = chemical
        self.AmtChemUsed = howMuchChemUsed.trunc(numDecimalDigits: 2)
        self.numTanks = numTanks.trunc(numDecimalDigits: 2)
        self.rateOfApp = applicationRate
        self.idOfRow = rowID
    }
}
extension Double
{
    func trunc(numDecimalDigits : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(numDecimalDigits)) * self)/pow(10.0, Double(numDecimalDigits)))
    }
}
