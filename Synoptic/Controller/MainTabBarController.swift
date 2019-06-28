//
//  MainTabBarController.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 04.08.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController, APIControllerProtocol {

    var api : APIController!
    
    var userDefaults = UserDefaults.standard
    
    var indexPaths = [String:IndexPath]()
    
    var chosenUnit = Config.apiUnits[0]

    var searchMode = 0
    
    var changedSettings = false

    var chosenCityID = Config.cityDefaultID
    var chosenCityName = Config.cityDefaultName
    
    var chosenCountryName = Config.countryDefaultName
    var chosenCountryCode = Config.countryDefaultCode
    var cityKeyword = ""

    var chosenTimerPeriod = Config.apiTimerPeriod[0]
    var enableTimerSwitch = false

    weak var weatherViewController : WeatherViewController?
    weak var forecastViewController : ForecastViewController?
    weak var settingsViewController : SettingsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        api = APIController(delegate: self)
        
        weatherViewController = self.viewControllers![0] as? WeatherViewController
        forecastViewController = self.viewControllers![1] as? ForecastViewController
        settingsViewController = self.viewControllers![2] as? SettingsViewController
        weatherViewController?.main = self
        forecastViewController?.main = self
        settingsViewController?.main = self
        
        loadDataFromUserDefaults()
    }

    func didReceiveAPIResults(_ results: AnyObject, URL: String, key: String ) {
        
        if URL.range(of: Config.apiIconURL) != nil {
            let data = results as! Data
            DispatchQueue.main.async(execute: {
                let chosenImage = UIImage(data: data)
                
                self.userDefaults.set(UIImagePNGRepresentation(chosenImage!), forKey: URL)
                self.userDefaults.synchronize()
                
                if key == "forecast" {
                    let indexPath = self.indexPaths[URL]
                    if let cellToUpdate = self.forecastViewController?.forecastTableView.cellForRow(at: indexPath!) as! ForecastTableViewCell? {
                        cellToUpdate.weatherIcon.iconView.image = chosenImage
                        self.forecastViewController?.forecastTableView.reloadData()
                    }
                } else {
                    self.weatherViewController?.weatherIcon.iconView.image = chosenImage
                }
                
            })
        }
        
        if URL.range(of: Config.apiForecast) != nil {
            DispatchQueue.main.async(execute: {
                let forecast = Forecast.dataFromJSONElement(results as! NSDictionary)
                
                self.userDefaults.set(forecast.city.id, forKey: "lastForecast")
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(forecast) {
                    self.userDefaults.set(encoded, forKey: "forecast\(String(describing: forecast.city.id))")
                }
                self.userDefaults.synchronize()
                
                self.forecastViewController?.showData(forecast)
                
            })
        }
        
        if URL.range(of: Config.apiWeather) != nil {
            DispatchQueue.main.async(execute: {
                let weather = Weather.dataFromJSONElement(results as! NSDictionary)
                
                self.userDefaults.set(weather.id, forKey: "lastWeather")
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(weather) {
                    self.userDefaults.set(encoded, forKey: "weather\(weather.id)")
                }
                self.userDefaults.synchronize()
                
                self.weatherViewController?.showData(weather)
                if let imageData = self.loadIcon(weather.weatherDetail[0].icon, nil) {
                    self.weatherViewController?.weatherIcon.iconView.image = imageData
                }
                
            })

        }
    }
    
    func loadDataFromUserDefaults() {

        searchMode = userDefaults.integer(forKey: "searchMode")

        let cityID = userDefaults.integer(forKey: "chosenCityID")
        if cityID > 0 {
            chosenCityID = Int64(cityID)
        }
        if let cityName = userDefaults.string(forKey: "chosenCityName") {
            chosenCityName = cityName
        }
        
        if let countryCode = userDefaults.string(forKey: "chosenCountryCode") {
            chosenCountryCode = countryCode
        }
        if let countryName = userDefaults.string(forKey: "chosenCountryName") {
            chosenCountryName = countryName
        }
        
        if let savedKeyword = userDefaults.string(forKey: "cityKeyword") {
            cityKeyword = savedKeyword
        }

        if let savedUnit = userDefaults.string(forKey: "chosenUnit") {
            chosenUnit = savedUnit
        }
        
        if let savedTimerPeriod = userDefaults.string(forKey: "chosenTimerPeriod") {
            chosenTimerPeriod = savedTimerPeriod
        }
        
        enableTimerSwitch = userDefaults.bool(forKey: "enableTimerSwitch")
        
    }
    
    func loadIcon(_ iconName: String, _ indexPath: IndexPath?) -> UIImage? {
        
        let iconURL = "\(Config.apiIconURL)\(iconName).png"
        if let imageData = self.userDefaults.object(forKey: iconURL) {
            return UIImage(data: imageData as! Data)!
        } else {
            if indexPath != nil {
                indexPaths[iconURL] = indexPath
                api.get(iconURL, "forecast")
            } else {
                api.get(iconURL, "weather")
            }
        }
        return nil
    }

    func loadWeatherFromUserDefaults(_ weatherKey : String) -> Bool {
        
        if let savedWeather = userDefaults.object(forKey: weatherKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedWeather = try? decoder.decode(Weather.self, from: savedWeather) {
                weatherViewController?.showData(loadedWeather)
                
                let UTCDate = Int64(Date().timeIntervalSince1970)
                if (UTCDate - loadedWeather.dt ) < Config.timeForWeather {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
        
    }
    
    func loadForecastFromUserDefaults(_ forecastKey : String) -> Bool {
        
        if let savedForecast = userDefaults.object(forKey: forecastKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedForecast = try? decoder.decode(Forecast.self, from: savedForecast) {
                forecastViewController?.showData(loadedForecast)
                
                let UTCDate = Int64(Date().timeIntervalSince1970)
                if (UTCDate - loadedForecast.dt ) < Config.timeForForecast {
                    return true
                } else {
                    return false
                }
            }
        }
        
        return false
    }
    
    func loadWeatherFromServer() {
        if searchMode == 0 {
            if !loadWeatherFromUserDefaults("weather\(chosenCityID)") || changedSettings {
                let urlPath = "\(Config.apiWeather)?id=\(chosenCityID)&units=\(chosenUnit)&appid=\(Config.apiKey)"
                api.get(urlPath, "weather")
            }
        } else {
            if !cityKeyword.isEmpty {
                let urlPath = "\(Config.apiWeather)?q=\(cityKeyword),\(chosenCountryCode)&units=\(chosenUnit)&appid=\(Config.apiKey)"
                api.get(urlPath, "weather")
            }
        }
    }
    
    func loadForecastFromServer() {
            if searchMode == 0 {
                if !loadForecastFromUserDefaults("forecast\(chosenCityID)") || changedSettings {
                    let urlPath = "\(Config.apiForecast)?id=\(chosenCityID)&units=\(chosenUnit)&appid=\(Config.apiKey)"
                    api.get(urlPath, "forecast")
                }
            } else {
                if !cityKeyword.isEmpty {
                    let urlPath = "\(Config.apiForecast)?q=\(cityKeyword),\(chosenCountryCode)&units=\(chosenUnit)&appid=\(Config.apiKey)"
                    api.get(urlPath, "weather")
                }
            }
    }
    
}
