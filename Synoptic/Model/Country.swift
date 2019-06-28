//
//  Country.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 02/08/2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct Country {
    
    let name : String
    let code : String
    
    init(_ name: String, _ code : String){
        
        self.name = name
        self.code = code
        
    }
    
    static func dataFromJSONFile() -> [Country] {
        
        var countries = [Country]()
        
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [NSDictionary] {
                    if jsonResult.count>0 {
                        for result in jsonResult {
                            let newCountry = dataFromJSONElement(result)
                            countries.append(newCountry)
                        }
                    }
                }
            } catch {
                print(Messages.errorJSON)
            }
        }
        
        return countries
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> Country {
        
        let name = dictionary["Name"] as? String ?? ""
        let code = dictionary["Code"] as? String ?? ""
        
        let newCountry = Country(name, code)
        
        return newCountry
    }
}


