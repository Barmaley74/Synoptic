//
//  WeatherSys.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 31.07.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct WeatherSys : Codable {
    
    let type : Int64
    let id : Int64
    let message : Double
    let country : String
    let sunrise : Int64
    let sunset : Int64
    
    init(_ type : Int64, _ id : Int64, _ message : Double, _ country : String, _ sunrise : Int64, _ sunset : Int64){
        
        self.type = type
        self.id = id
        self.message = message
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
        
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> WeatherSys {
        
        let type = dictionary["type"] as? Int64 ?? 0
        let id = dictionary["id"] as? Int64 ?? 0
        let message = dictionary["message"] as? Double ?? 0
        let country = dictionary["country"] as? String ?? ""
        let sunrise = dictionary["sunrise"] as? Int64 ?? 0
        let sunset = dictionary["sunset"] as? Int64 ?? 0
        
        let newWeatherSys = WeatherSys(type, id, message, country, sunrise, sunset)
        
        return newWeatherSys
    }
}
