//
//  Config.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 30.07.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import Foundation

struct Config {
    
    static let apiURL = "https://api.openweathermap.org/data/2.5/"
    static let apiKey = "6471185fe4c35229c983fa93162ea84b"
    static let apiIconURL = "http://openweathermap.org/img/w/"
    
    static let apiWeather = apiURL + "weather"
    static let apiForecast = apiURL + "forecast"
    
    static var apiUnits = ["metric", "standart", "imperial"]
    static var apiTimerPeriod = ["1 min", "5 min", "10 min", "30 min", "1 hour", "3 hours", "12 hours"]
    static var apiTimerPeriodSeconds : [Double] = [60, 300, 600, 1800, 3600, 10800, 43200]
    
    static let cityDefaultID : Int64 = 146384
    static let cityDefaultName = "Limassol"
    static let countryDefaultName = "Cyprus"
    static let countryDefaultCode = "CY"
    
    static let timeForWeather = 600  // 10 минут
    static let timeForForecast = 10800  // 3 часа

}
