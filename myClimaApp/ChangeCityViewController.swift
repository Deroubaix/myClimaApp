//
//  ChangeCityViewController.swift
//  myClimaApp
//
//  Created by Marisha Deroubaix on 20/08/18.
//  Copyright © 2018 Marisha Deroubaix. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
  
  func userEnteredANewCityName(city: String)
  
}

class ChangeCityViewController: UIViewController {
  
  var delegate : ChangeCityDelegate?

  @IBOutlet weak var changeCityTextField: UITextField!
  

  @IBAction func getWeatherPressed(_ sender: UIButton) {
    
    let cityName = changeCityTextField.text!
    
    delegate?.userEnteredANewCityName(city: cityName)
    
    self.dismiss(animated: true, completion: nil)
    
  }
  
  @IBAction func backButtonPressed(_ sender: UIButton) {
    
    self.dismiss(animated: true, completion: nil)
  }
  
}
