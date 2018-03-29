//
//  customDisplayCell.swift
//  ChemTrack
//
//  Created by Gurjap Singh on 2018-03-27.
//  Copyright © 2018 Christian Cornelis. All rights reserved.
//

import UIKit

class customDisplayCell: UITableViewCell {

    @IBOutlet var cellView: UIView!
    @IBOutlet var name_lbl: UILabel!
    @IBOutlet var fieldName_lbl: UILabel!
    @IBOutlet var fieldSize_lbl: UILabel!
    @IBOutlet var date_lbl: UILabel!
//    @IBOutlet var weather_lbl: UILabel!
    @IBOutlet var chemicalType_lbl: UILabel!
    @IBOutlet var AmtChemicalUsed_lbl: UILabel!
    @IBOutlet var rateOfApplication_lbl: UILabel!
    @IBOutlet var numTanks_lbl: UILabel!
    @IBOutlet var tankSize_lbl: UILabel!
    @IBOutlet var temp_lbl: UILabel!
    @IBOutlet var windSpeed_lbl: UILabel!
    @IBOutlet var windDirection_lbl: UILabel!
    @IBOutlet var humidityLevel_lbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
