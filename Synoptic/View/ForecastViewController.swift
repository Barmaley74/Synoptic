//
//  ForecastViewController.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 01.08.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var main : MainTabBarController?
    
    var lastForecastID : Int64 = Config.cityDefaultID
    var forecastList = [ForecastDetail]()

    @IBOutlet weak var forecastModeControl: UISegmentedControl!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.forecastTableView.delegate = self
        self.forecastTableView.dataSource = self
        
        if let savedForecast = main?.userDefaults.integer(forKey: "lastForecast") {
            lastForecastID = Int64(savedForecast)
        }
        _ = main?.loadForecastFromUserDefaults("forecast\(lastForecastID)")

    }

    override func viewDidAppear(_ animated: Bool) {
        main?.loadForecastFromServer()
    }
    
    @IBAction func forecastModeControlChanged(_ sender: UISegmentedControl) {
        forecastTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell")! as! ForecastTableViewCell
        if forecastList.count > 0 {
                cell.showFields(forecastList[(indexPath as NSIndexPath).row])
                _ = main?.loadIcon(forecastList[(indexPath as NSIndexPath).row].weather[0].icon, indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch forecastModeControl.selectedSegmentIndex {
        case 0:
            return 8
        case 1:
            return 24
        case 2:
            return 40
        default:
            return 1
        }
    }
    
    func showData(_ forecast : Forecast) {
        
        self.cityLabel.text = "\(forecast.city.name), \(forecast.city.country)"
        forecastList = forecast.list
        
        forecastTableView.reloadData()
    }
}
