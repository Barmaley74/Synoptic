//
//  ForecastTableViewCell.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 03/08/2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: WeatherIcon!
    @IBOutlet weak var dateTimeForecast: UILabel!
    @IBOutlet weak var tempForecast: UILabel!
    @IBOutlet weak var humidityForecast: UILabel!
    @IBOutlet weak var pressureForecast: UILabel!
    @IBOutlet weak var desciptionForecast: UILabel!
    @IBOutlet weak var precipationView: PrecipationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func showFields(_ forecastDetail : ForecastDetail) {
        let idx = forecastDetail.dt_txt.index(forecastDetail.dt_txt.startIndex, offsetBy: 16)
        dateTimeForecast.text = String(forecastDetail.dt_txt[..<idx])
        tempForecast.text = String(format:"%.1f", forecastDetail.main.temp) + "°"
        desciptionForecast.text = forecastDetail.weather[0].description
        humidityForecast.text = "Humidity: " + String(forecastDetail.main.humidity) + "%"
        pressureForecast.text = "Pressure: " + String(forecastDetail.main.pressure) + " hPa"
        if forecastDetail.rain != nil {
            precipationView.rainLabel.text = "Rain: " + String(format:"%.3f", (forecastDetail.rain?.hours3)!)
        }
        if forecastDetail.snow != nil {
            precipationView.snowLabel.text = "Snow: " + String(format:"%.3f", (forecastDetail.snow?.hours3)!)
        }

        let iconURL = "\(Config.apiIconURL)\(String(describing: forecastDetail.weather[0].icon)).png"
        if let imageData = UserDefaults.standard.object(forKey: iconURL) {
            self.weatherIcon.iconView.image = UIImage(data: imageData as! Data)
        }

    }
    
}
