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
    @IBOutlet var weather_lbl: UILabel!
    @IBOutlet var tanks_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
