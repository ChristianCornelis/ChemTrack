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
    let tank: Int
    let chemType: String?
    
    init(Name:String,fieldName:String,fieldSize:String,date:String,weather:String,tank:Int,chemical: String) {
        self.Name = Name
        self.fieldName = fieldName
        self.fieldSize = fieldSize
        self.Date = date
        self.weather = weather
        self.tank = tank
        self.chemType = chemical
    }
}
