//
//  ViewController.swift
//  myClimaApp
//
//  Created by Marisha Deroubaix on 18/08/18.
//  Copyright © 2018 Marisha Deroubaix. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
  
  let weatherURL = "http://api.openweathermap.org/data/2.5/weather"
  let appID = "556cacbea2ae97790d6f585b754f9740"
  
  let locationManager = CLLocationManager()
  let weatherDataModel = WeatherDataModel()
  
  
  @IBOutlet weak var weatherIcon: UIImageView!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  //MARK: - Networking
  //*****************************************************************/
  
  func getWeatherData(url: String, parameters: [String: String]) {
    
    Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
      
      if response.result.isSuccess {
        print("Success! Got the weather data")
        let weatherJSON : JSON = JSON(response.result.value!)
        self.updateWeatherData(json: weatherJSON)
      } else {
        print("Error\(String(describing: response.result.error))")
        self.cityLabel.text = "Connection Issues"
      }
    }
    
  }
  
  //MARK: - JSON Parsing
  //*****************************************************************/
  
  func updateWeatherData(json: JSON) {
    
    if let tempResult = json["main"]["temp"].double {
    weatherDataModel.temperature = Int(tempResult - 273.15)
    weatherDataModel.city = json["name"].stringValue
    weatherDataModel.condition = json["weather"][0]["id"].intValue
    weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
      
    updateUIWithWeatherData()
      
    } else {
      cityLabel.text = "Weather Unavailable"
    }
  }
  
  //MARK: - UI UPdates
  /******************************************************************/
  
  func updateUIWithWeatherData() {
    
    cityLabel.text = weatherDataModel.city
    temperatureLabel.text = "\(weatherDataModel.temperature)°"
    weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    
  }
  
  //MARK: - Location Manager Delegate Methods
  /******************************************************************/
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations[locations.count - 1]
    if location.horizontalAccuracy > 0 {
      locationManager.stopUpdatingLocation()
      
      print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
      
      let latitude = String(location.coordinate.latitude)
      let longitude = String(location.coordinate.longitude)
      
      let params : [String: String] = ["lat": latitude, "lon": longitude, "appid": appID]
      
      getWeatherData(url: weatherURL, parameters: params)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
    cityLabel.text = "Location Unavailable"
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - Change City Delegate methods
  
  func userEnteredANewCityName(city: String) {
    let params : [String: String] = ["q" : city, "appid": appID]
    
    getWeatherData(url: weatherURL, parameters: params)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "changeCityName" {
      let destanitionVC = segue.destination as! ChangeCityViewController
      destanitionVC.delegate = self
    }
  }


}

