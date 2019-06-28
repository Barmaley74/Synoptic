//
//  Weather.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 31.07.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct Weather : Codable {
    
    let coordinate : Coordinate
    let weatherDetail : [WeatherDetail]
    let base : String
    let weatherMain : WeatherMain
    let visibility : Int64
    let wind : Wind
    let clouds : Clouds
    let dt : Int64
    let weatherSys : WeatherSys
    let id : Int64
    let name : String
    let cod : Int64
        
    init(_ coordinate : Coordinate, _ weatherDetail : [WeatherDetail], _ base : String, _ weatherMain : WeatherMain, _ visibility : Int64, _ wind : Wind, _ clouds : Clouds, _ dt : Int64, _ weatherSys : WeatherSys, _ id : Int64, _ name : String, _ cod : Int64){
            
        self.coordinate = coordinate
        self.weatherDetail = weatherDetail
        self.base = base
        self.weatherMain = weatherMain
        self.visibility = visibility
        self.wind = wind
        self.clouds = clouds
        self.dt = dt
        self.weatherSys = weatherSys
        self.id = id
        self.name = name
        self.cod = cod
            
        }
        
        static func dataFromJSONElement(_ dictionary: NSDictionary) -> Weather {
            
            let coordinate = Coordinate.dataFromJSONElement(dictionary["coord"] as! NSDictionary)
            var weatherDetail = [WeatherDetail]()
            if let _ = dictionary["weather"] as? NSArray { weatherDetail = WeatherDetail.dataFromJSONArray(dictionary["weather"] as! NSArray) }
            let base = dictionary["base"] as? String ?? ""
            let weatherMain = WeatherMain.dataFromJSONElement(dictionary["main"] as! NSDictionary)
            let visibility = dictionary["visibility"] as? Int64 ?? 0
            let wind = Wind.dataFromJSONElement(dictionary["wind"] as! NSDictionary)
            let clouds = Clouds.dataFromJSONElement(dictionary["clouds"] as! NSDictionary)
            let dt = dictionary["dt"] as? Int64 ?? 0
            let weatherSys = WeatherSys.dataFromJSONElement(dictionary["sys"] as! NSDictionary)
            let id = dictionary["id"] as? Int64 ?? 0
            let name = dictionary["name"] as? String ?? ""
            let cod = dictionary["cod"] as? Int64 ?? 0
            
            let newWeather = Weather(coordinate, weatherDetail, base, weatherMain, visibility, wind, clouds, dt, weatherSys, id, name, cod)
            
            return newWeather
        }
    
}
