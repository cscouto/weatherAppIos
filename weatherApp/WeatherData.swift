//
//  WeatherData.swift
//  weatherApp
//
//  Created by Tiago Henrique on 12/29/16.
//  Copyright © 2016 Tiago Henrique. All rights reserved.
//

import Foundation
class WeatherData {
    var info: String!
    var location: String!
    var day: String!
    var temperature: String!
    var min: String!
    var max: String!
    var wind: String!
    var cloudiness: String!
    var pressure: String!
    var humidity: String!
    var sunrise: String!
    var sunset: String!
    
    init() {
        info = ""
        location = ""
        day = ""
        temperature = ""
        min = ""
        max = ""
        wind = ""
        cloudiness = ""
        pressure = ""
        humidity = ""
        sunrise = ""
        sunset = ""
    }
}
