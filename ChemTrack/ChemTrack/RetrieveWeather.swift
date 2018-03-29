//
//  RetrieveWeather.swift
//  ChemTrack
//
//  Created by Gurjap Singh on 2018-03-27.
//  Copyright © 2018 Christian Cornelis. All rights reserved.
//

import Foundation
typealias successfulyGotWeather      = (_ isSuccess: Bool, _ strings: [String]) -> Void
class RetrieveWeather{
    private let owmBaseURL = "http://api.openweathermap.org/data/2.5/weather?"
    private let apiKey = "c912e6afe3ddebedf6506cab7a8c4b4c"
    
    func getWeather(Latitude: String,Longitude: String, completion: @escaping successfulyGotWeather){
        var returnTemp:String = ""
        var returnHumidity:String = ""
        var returnTempMin:String = ""
        var returnWindSpeed:String = ""
        var returnWindDegree:String = ""
        var returnLocatoin:String = ""
        
        let urlString = URL(string: "\(owmBaseURL)lat=\(Latitude)&lon=\(Longitude)&units=metric&APPID=\(apiKey)")
        
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
                            returnTemp = String(describing: thisWeatherData["main"]!["temp"]!!)
                            returnHumidity = String(describing: thisWeatherData["main"]!["humidity"]!!)
                            returnTempMin = String(describing: thisWeatherData["main"]!["temp_min"]!!)
                            returnWindSpeed = String(describing: thisWeatherData["wind"]!["speed"]!!)
                            returnWindDegree = String(describing: thisWeatherData["wind"]!["deg"]!!)
                            returnLocatoin = String(describing: thisWeatherData["name"]!)
                            completion(true,[returnTemp,returnHumidity,returnTempMin,returnWindSpeed,returnWindDegree,returnLocatoin])
                           
                        } catch let error_Json as NSError{
                            print("There was a json error \(error_Json.description)")
                            completion(false,[returnTemp,returnHumidity,returnTempMin,returnWindSpeed,returnWindDegree])
                        }
                    }
                }
            })
            task.resume()
        }
    }
}
