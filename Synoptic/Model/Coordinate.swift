//
//  Coordinate.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 31.07.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct Coordinate : Codable {
    
    let lon : Double
    let lat : Double
    
    init(_ lon: Double, _ lat: Double){
        
        self.lon = lon
        self.lat = lat
        
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> Coordinate {
        
        let lon = dictionary["lon"] as? Double ?? 0
        let lat = dictionary["lat"] as? Double ?? 0
        
        let newCoordinate = Coordinate(lon, lat)
        
        return newCoordinate
    }
}
