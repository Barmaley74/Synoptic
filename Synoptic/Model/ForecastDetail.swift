//
//  ForecastDetail.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 03.08.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct ForecastDetail : Codable {
    
    let dt : Int64
    let main : WeatherMain
    let weather : [WeatherDetail]
    let wind : Wind
    let clouds : Clouds
    let dt_txt : String
    let rain : Precipitation?
    let snow : Precipitation?
    
    init(_ dt : Int64, _ main : WeatherMain, _ weather : [WeatherDetail], _ wind : Wind, _ clouds : Clouds, _ dt_txt : String, _ rain : Precipitation?, _ snow : Precipitation?){
        
        self.dt = dt
        self.main = main
        self.weather = weather
        self.wind = wind
        self.clouds = clouds
        self.dt_txt = dt_txt
        self.rain = rain
        self.snow = snow
        
    }
    
    static func dataFromJSONArray(_ results: NSArray) -> [ForecastDetail] {
        
        var forecastDetails = [ForecastDetail]()
        
        if results.count>0 {
            for result in results {
                let newForecastDetail = dataFromJSONElement(result as! NSDictionary)
                forecastDetails.append(newForecastDetail)
            }
        }
        return forecastDetails
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> ForecastDetail {
        
        let id = dictionary["id"] as? Int64 ?? 0
        var weather = [WeatherDetail]()
        if let _ = dictionary["weather"] as? NSArray { weather = WeatherDetail.dataFromJSONArray(dictionary["weather"] as! NSArray) }
        let main = WeatherMain.dataFromJSONElement(dictionary["main"] as! NSDictionary)
        let wind = Wind.dataFromJSONElement(dictionary["wind"] as! NSDictionary)
        let clouds = Clouds.dataFromJSONElement(dictionary["clouds"] as! NSDictionary)
        let dt_txt = dictionary["dt_txt"] as? String ?? ""
        var rain : Precipitation?
        if let _ = dictionary["rain"] as? NSDictionary { rain = Precipitation.dataFromJSONElement(dictionary["rain"] as! NSDictionary) }
        var snow : Precipitation?
        if let _ = dictionary["snow"] as? NSDictionary { snow = Precipitation.dataFromJSONElement(dictionary["snow"] as! NSDictionary) }
        
        let newForecastDetail = ForecastDetail(id, main, weather, wind, clouds, dt_txt, rain, snow)
        
        return newForecastDetail
    }
}
