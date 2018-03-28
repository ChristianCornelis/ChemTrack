//
//  RetrieveWeather.swift
//  ChemTrack
//
//  Created by Gurjap Singh on 2018-03-27.
//  Copyright © 2018 Christian Cornelis. All rights reserved.
//

import Foundation
class RetrieveWeather{
    private let owmBaseURL = "http://api.openweathermap.org/data/2.5/weather?"
    private let apiKey = "c912e6afe3ddebedf6506cab7a8c4b4c"
    
    func getWeather(Latitude: String,Longitude: String){
        let urlString = URL(string: "\(owmBaseURL)lat=\(Latitude)&lon=\(Longitude)&APPID=\(apiKey)")
        
        if let url = urlString{
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                } else {
                    if let usable = data {
                        print ("usable data size:\n\(usable)\n")
                        
                        do{
                            let thisWeatherData = try JSONSerialization.jsonObject(with: usable, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                            print(thisWeatherData)
                            print("temp: \(thisWeatherData["main"]!["temp"]!!)")
                            print("tempMax: \(thisWeatherData["main"]!["temp_max"]!!)")
//                            print("Latitude: \(thisWeatherData["coord"]!["lat"]!!)")
                            print("tempMin: \(thisWeatherData["main"]!["temp_min"]!!)")
//                            print(thisWeatherData["description"]!)
//                            print(thisWeatherData["wind"]!)
                            print("Wind: \(thisWeatherData["wind"]!["deg"]!!) at \(thisWeatherData["wind"]!["speed"]!!)")
                            //print("weather: \(thisWeatherData["weather"]!["description"]!!)")
                           
                        } catch let error_Json as NSError{
                            print("There was a json error \(error_Json.description)")
                        }
                    }
                }
            })
            task.resume()
        }
    }
}
