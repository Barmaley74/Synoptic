//
//  Clouds.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 31.07.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct Clouds : Codable {
    
    let all : Int64
    
    init(_ all: Int64){
        
        self.all = all
        
    }
    
    static func dataFromJSONElement(_ dictionary: NSDictionary) -> Clouds {
        
        let all = dictionary["all"] as? Int64 ?? 0
        
        let newClouds = Clouds(all)
        
        return newClouds
    }
}
