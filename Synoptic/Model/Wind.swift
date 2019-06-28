//
//  Wind.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 31.07.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct Wind : Codable {
    
    let speed : Double
    let deg : Int64
    
    init(_ speed: Double, _ deg: Int64){
        
        self.speed = speed
        self.deg = deg
        
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> Wind {
        
        let speed = dictionary["speed"] as? Double ?? 0
        let deg = dictionary["deg"] as? Int64 ?? 0
        
        let newWind = Wind(speed, deg)
        
        return newWind
    }
}
