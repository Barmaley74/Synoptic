//
//  WeatherViewController.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 31.07.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    weak var main : MainTabBarController?
    
    var lastWeatherID : Int64 = Config.cityDefaultID

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: WeatherIcon!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedWeather = main?.userDefaults.integer(forKey: "lastWeather") {
            lastWeatherID = Int64(savedWeather)
        }
        
        _ = main?.loadWeatherFromUserDefaults("weather\(lastWeatherID)")
    }

    override func viewDidAppear(_ animated: Bool) {
            main?.loadWeatherFromServer()        
    }
    
    func showData(_ weather : Weather) {
        
            self.cityLabel.text = weather.name
            self.temperatureLabel.text = String(format:"%.1f", weather.weatherMain.temp) + "°"
            self.descriptionLabel.text = weather.weatherDetail[0].main
            self.humidityLabel.text = "Humidity: " + String(weather.weatherMain.humidity) + "%"
            self.pressureLabel.text = "Pressure: " + String(weather.weatherMain.pressure) + " hPa"
            self.windLabel.text = "Wind: " + String(format:"%.1f", weather.wind.speed) + " m/s"
        
            if let imageData = main?.userDefaults.object(forKey: weather.weatherDetail[0].icon) {
                self.weatherIcon.iconView.image = UIImage(data: imageData as! Data)
            }
    }
}
