//
//  City.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 03.08.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct City : Codable {
    
    let id : Int64
    let name : String
    let coord : Coordinate
    let country : String
    
    init(_ id: Int64, _ name: String, _ coord : Coordinate, _ country : String){
        
        self.id = id
        self.name = name
        self.coord = coord
        self.country = country
        
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> City {
        
        let id = dictionary["id"] as? Int64 ?? 0
        let name = dictionary["name"] as? String ?? ""
        let coordinate = Coordinate.dataFromJSONElement(dictionary["coord"] as! NSDictionary)
        let country = dictionary["country"] as? String ?? ""
        
        let newCity = City(id, name, coordinate, country)
        
        return newCity
    }
}
