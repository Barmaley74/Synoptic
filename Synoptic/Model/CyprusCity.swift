//
//  CyprusCity.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 02.08.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct CyprusCity {
    
    let id : Int64
    let name : String
    let country : String
    let coord : Coordinate
    
    init(_ id: Int64, _ name: String, _ country : String, _ coord : Coordinate){
        
        self.id = id
        self.name = name
        self.country = country
        self.coord = coord
        
    }
    
    static func dataFromJSONFile() -> [CyprusCity] {
        
        var cyprusCities = [CyprusCity]()
        
        if let path = Bundle.main.path(forResource: "citycypruslist", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [NSDictionary] {
                    if jsonResult.count>0 {
                        for result in jsonResult {
                            let newCyprusCity = dataFromJSONElement(result)
                            cyprusCities.append(newCyprusCity)
                        }
                    }
                }
            } catch {
                print(Messages.errorJSON)
            }
        }
        
        return cyprusCities
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> CyprusCity {
        
        let id = dictionary["id"] as? Int64 ?? 0
        let name = dictionary["name"] as? String ?? ""
        let country = dictionary["country"] as? String ?? ""
        let coordinate = Coordinate.dataFromJSONElement(dictionary["coord"] as! NSDictionary)
        
        let newCyprusCity = CyprusCity(id, name, country, coordinate)
        
        return newCyprusCity
    }
}


