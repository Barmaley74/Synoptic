//
//  Forecast.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 03.08.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct Forecast : Codable {
    
    let cod : String
    let message : Double
    let count : Int64
    let list : [ForecastDetail]
    let city : City
    let dt : Int64
    
    
    init(_ cod: String, _ message: Double, _ count : Int64, _ list : [ForecastDetail], _ city : City){
        
        self.cod = cod
        self.message = message
        self.count = count
        self.list = list
        self.city = city
        self.dt = Int64(Date().timeIntervalSince1970)
        
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> Forecast {
        
        let cod = dictionary["cod"] as? String ?? ""
        let message = dictionary["message"] as? Double ?? 0
        let count = dictionary["count"] as? Int64 ?? 0
        var list = [ForecastDetail]()
        if let _ = dictionary["list"] as? NSArray { list = ForecastDetail.dataFromJSONArray(dictionary["list"] as! NSArray) }
        let city = City.dataFromJSONElement(dictionary["city"] as! NSDictionary)

        let newForecast = Forecast(cod, message, count, list, city)
        
        return newForecast
    }
}

