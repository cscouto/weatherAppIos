//
//  DetailViewController.swift
//  weatherApp
//
//  Created by Tiago Henrique on 12/29/16.
//  Copyright © 2016 Tiago Henrique. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    @IBOutlet var image: UIImageView!
    var weatherData: WeatherData!
    @IBOutlet var location: UILabel!
    @IBOutlet var day: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var min: UILabel!
    @IBOutlet var max: UILabel!
    @IBOutlet var wind: UILabel!
    @IBOutlet var cloudiness: UILabel!
    @IBOutlet var pressure: UILabel!
    @IBOutlet var humidity: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location.text = weatherData.location
        day.text = weatherData.day
        temperature.text = weatherData.temperature
        min.text = weatherData.min
        max.text = weatherData.max
        wind.text = weatherData.wind
        cloudiness.text = weatherData.cloudiness
        pressure.text = weatherData.pressure
        humidity.text = weatherData.humidity
        print(" Hello \(weatherData.image)")
        image.image = UIImage(named: weatherData.image)
    }
    @IBAction func btnBackPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
