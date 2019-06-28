//
//  SettingsViewController.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 01.08.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    weak var main : MainTabBarController?
    
    var timerForecast = Timer()
    var runningTimer = false
    
    var cyprusCities = [CyprusCity]()
    var countries = [Country]()
    
    var cyprusCityPicker = UIPickerView()
    var countryPicker = UIPickerView()
    var unitsPicker = UIPickerView()
    var timerPeriodPicker = UIPickerView()
    
    @IBOutlet weak var cyprusCityLabel: UILabel!
    @IBOutlet weak var cyprusCityTextField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var searchModeControl: UISegmentedControl!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var countryTextFieldTop: NSLayoutConstraint!
    @IBOutlet weak var unitsTextFieldTop: NSLayoutConstraint!
    @IBOutlet weak var unitsTextField: UITextField!
    @IBOutlet weak var enableTimerSwitch: UISwitch!
    @IBOutlet weak var timerPeriodTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cyprusCities = CyprusCity.dataFromJSONFile()
        countries = Country.dataFromJSONFile()
        
        buildPickers()
    }

    override func viewDidAppear(_ animated: Bool) {
        showData()
    }
    
    func showData() {
        searchModeControl.selectedSegmentIndex = (main?.searchMode)!
        changeSearchMode()

        cyprusCityTextField.text = main?.chosenCityName
        
        var i = 0
        for city in cyprusCities {
            if city.name == main?.chosenCityName {
                cyprusCityPicker.selectRow(i, inComponent: 0, animated: false)
                break
            }
            i+=1
        }

        countryTextField.text = main?.chosenCountryName
        
        cityTextField.text = main?.cityKeyword
        
        i = 0
        for country in countries {
            if country.name == main?.chosenCountryName {
                countryPicker.selectRow(i, inComponent: 0, animated: false)
                break
            }
            i+=1
        }

        unitsTextField.text = main?.chosenUnit
        if let rowUnit = Config.apiUnits.index(of: (main?.chosenUnit)!) {
            unitsPicker.selectRow(rowUnit, inComponent: 0, animated: false)
        }

        timerPeriodTextField.text = main?.chosenTimerPeriod
        if let rowTimer = Config.apiTimerPeriod.index(of: (main?.chosenTimerPeriod)!){
            timerPeriodPicker.selectRow(rowTimer, inComponent: 0, animated: false)
        }

        enableTimerSwitch.isOn = (main?.enableTimerSwitch)!
        timerPeriodTextField.isEnabled = enableTimerSwitch.isOn
        if (enableTimerSwitch.isOn && !runningTimer) {
            runTimer()
        }

    }
    
    func buildPickers(){
        
        cyprusCityPicker.delegate = self
        cyprusCityTextField.inputView = cyprusCityPicker
        
        countryPicker.delegate = self
        countryTextField.inputView = countryPicker
        
        unitsPicker.delegate = self
        unitsTextField.inputView = unitsPicker
        
        timerPeriodPicker.delegate = self
        timerPeriodTextField.inputView = timerPeriodPicker
    }
    
    @IBAction func cityTextFieldEditingEnd(_ sender: UITextField) {
        main?.userDefaults.set(self.cityTextField.text, forKey: "cityKeyword")
        main?.cityKeyword = self.cityTextField.text!
        main?.changedSettings = true
        main?.userDefaults.synchronize()
    }
    
    func changeSearchMode(){
        self.cyprusCityLabel.isHidden = (self.searchModeControl.selectedSegmentIndex == 1)
        self.cyprusCityTextField.isHidden = (self.searchModeControl.selectedSegmentIndex == 1)
        self.countryLabel.isHidden = (self.searchModeControl.selectedSegmentIndex == 0)
        self.countryTextField.isHidden = (self.searchModeControl.selectedSegmentIndex == 0)
        self.cityLabel.isHidden = (self.searchModeControl.selectedSegmentIndex == 0)
        self.cityTextField.isHidden = (self.searchModeControl.selectedSegmentIndex == 0)
        if self.searchModeControl.selectedSegmentIndex == 0 {
            countryTextFieldTop.constant = 8
            unitsTextFieldTop.constant = -68
        } else {
            countryTextFieldTop.constant = -30
            unitsTextFieldTop.constant = 8
        }
    }
    
    @IBAction func searchModeControlChanged(_ sender: UISegmentedControl) {
        main?.userDefaults.set(self.searchModeControl.selectedSegmentIndex, forKey: "searchMode")
        main?.searchMode = self.searchModeControl.selectedSegmentIndex
        main?.userDefaults.synchronize()
        main?.changedSettings = true
        changeSearchMode()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case cyprusCityPicker:
            return cyprusCities.count
        case countryPicker:
            return countries.count
        case unitsPicker:
            return Config.apiUnits.count
        case timerPeriodPicker:
            return Config.apiTimerPeriod.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case cyprusCityPicker:
            return cyprusCities[row].name
        case countryPicker:
            return countries[row].name
        case unitsPicker:
            return Config.apiUnits[row]
        case timerPeriodPicker:
            return Config.apiTimerPeriod[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case cyprusCityPicker:
            cyprusCityTextField.text = cyprusCities[row].name
            main?.userDefaults.set(self.cyprusCities[row].id, forKey: "chosenCityID")
            main?.userDefaults.set(self.cyprusCities[row].name, forKey: "chosenCityName")
            main?.chosenCityID = self.cyprusCities[row].id
            main?.chosenCityName = self.cyprusCities[row].name
        case countryPicker:
            countryTextField.text = countries[row].name
            main?.userDefaults.set(self.countries[row].code, forKey: "chosenCountryCode")
            main?.userDefaults.set(self.countries[row].name, forKey: "chosenCountryName")
            main?.chosenCountryCode = self.countries[row].code
            main?.chosenCountryName = self.countries[row].name
        case unitsPicker:
            unitsTextField.text = Config.apiUnits[row]
            main?.userDefaults.set(Config.apiUnits[row], forKey: "chosenUnit")
            main?.chosenUnit = Config.apiUnits[row]
        case timerPeriodPicker:
            timerPeriodTextField.text = Config.apiTimerPeriod[row]
            main?.userDefaults.set(Config.apiTimerPeriod[row], forKey: "chosenTimerPeriod")
            main?.chosenTimerPeriod = Config.apiTimerPeriod[row]
        default: break
        }
        main?.changedSettings = true
        main?.userDefaults.synchronize()
        self.view.endEditing(true)
    }
    
    @IBAction func enableTimerSwitchChanged(_ sender: UISwitch) {
        timerPeriodTextField.isEnabled = enableTimerSwitch.isOn
        main?.userDefaults.set(enableTimerSwitch.isOn, forKey: "enableTimerSwitch")
        main?.userDefaults.synchronize()
        
        if enableTimerSwitch.isOn {
            runTimer()
        } else {
            timerForecast.invalidate()
        }
    }
    
    func runTimer() {
        let rowTimerIndex = Config.apiTimerPeriod.index(of: (main?.chosenTimerPeriod)!)
        
        timerForecast = Timer.scheduledTimer(timeInterval: Config.apiTimerPeriodSeconds[rowTimerIndex!], target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if Reachability.isConnectedToNetwork() {
            print("Updating timer")
            runningTimer = true
            main?.loadForecastFromServer()
        }
    }
    
}
