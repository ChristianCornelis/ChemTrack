//
//  FirstViewController.swift
//  ChemTrack
//
//  Created by Christian Cornelis on 2018-03-26.
//  Copyright © 2018 Christian Cornelis. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    var theWeather = RetrieveWeather()
    override func viewDidLoad() {
        super.viewDidLoad()
        theWeather.getWeather(Latitude: "43.5448048", Longitude: "-80.2481666")
        // changed by gurjap i wonder if this works
        // gurjap branch test
        //hello from gurjap
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print ("hello world")
        // Dispose of any resources that can be recreated.
        //hello from christian
    }


}

