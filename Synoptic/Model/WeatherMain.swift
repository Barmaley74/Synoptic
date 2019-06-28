//
//  WeatherMain.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 31.07.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct WeatherMain : Codable {
    
    let temp : Double
    let pressure : Double
    let humidity : Int64
    let temp_min : Double
    let temp_max : Double
    let sea_level : Double
    let grnd_level : Double
    
    init(_ temp : Double, _ pressure : Double, _ humidity : Int64, _ temp_min : Double, _ temp_max : Double, _ sea_level : Double, _ grnd_level : Double){
        
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.sea_level = sea_level
        self.grnd_level = grnd_level
        
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> WeatherMain {
        
        let temp = dictionary["temp"] as? Double ?? 0
        let pressure = dictionary["pressure"] as? Double ?? 0
        let humidity = dictionary["humidity"] as? Int64 ?? 0
        let temp_min = dictionary["temp_min"] as? Double ?? 0
        let temp_max = dictionary["temp_max"] as? Double ?? 0
        let sea_level = dictionary["sea_level"] as? Double ?? 0
        let grnd_level = dictionary["grnd_level"] as? Double ?? 0

        let newWeatherMain = WeatherMain(temp, pressure, humidity, temp_min, temp_max, sea_level,  grnd_level)
        
        return newWeatherMain
    }
}
