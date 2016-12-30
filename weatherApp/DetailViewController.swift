//
//  DetailViewController.swift
//  weatherApp
//
//  Created by Tiago Henrique on 12/29/16.
//  Copyright © 2016 Tiago Henrique. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
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
    @IBOutlet var sunrise: UILabel!
    @IBOutlet var sunset: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
