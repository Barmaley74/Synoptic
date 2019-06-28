//
//  WeatherDetail.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 31.07.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct WeatherDetail : Codable {
    
    let id : Int64
    let main : String
    let description : String
    let icon : String
    
    init(_ id : Int64, _ main : String, _ description : String, _ icon : String){
        
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
        
    }
    
    static func dataFromJSONArray(_ results: NSArray) -> [WeatherDetail] {
        
        var weatherDetails = [WeatherDetail]()
        
        if results.count>0 {
            for result in results {
                let newWeatherDetail = dataFromJSONElement(result as! NSDictionary)
                weatherDetails.append(newWeatherDetail)
            }
        }
        return weatherDetails
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> WeatherDetail {
        
        let id = dictionary["id"] as? Int64 ?? 0
        let main = dictionary["main"] as? String ?? ""
        let description = dictionary["description"] as? String ?? ""
        let icon = dictionary["icon"] as? String ?? ""

        let newWeatherDetail = WeatherDetail(id, main, description, icon)
        
        return newWeatherDetail
    }
}
