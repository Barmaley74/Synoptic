//
//  Precipitation.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 04.08.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct Precipitation : Codable {
    
    let hours3 : Double
    
    init(_ hours3: Double){
        
        self.hours3 = hours3
        
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> Precipitation {
        
        let hours3 = dictionary["3h"] as? Double ?? 0
        
        let newPrecipitation = Precipitation(hours3)
        
        return newPrecipitation
    }
}
