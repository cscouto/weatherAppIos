//
//  ViewController.swift
//  weatherApp
//
//  Created by Tiago Henrique on 12/21/16.
//  Copyright © 2016 Tiago Henrique. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var weatherData: WeatherData!
    var weathers = Array<WeatherData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail"{
            let dataDetail = segue.destination as! DetailViewController
            dataDetail.weatherData = self.weatherData
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.weatherData = weathers[indexPath.item]
        self.performSegue(withIdentifier: "segueDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherViewCell
        
        cell.weatherDay.text = weathers[indexPath.item].info
        
        return cell
    }
    
    func loadData() {
        
        weathers.removeAll()
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?q=14752&units=metric&cnt=16&APPID=809ca8d83020431d08cf4a78c95c5909")
        
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard error == nil && data != nil else {
                print("error=\(error)")
                return
            }

            do{
                var location: String = ""
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [])
                print(jsonResult)
                if let dictionary = jsonResult as? [String: Any]{
                    if let city = dictionary["city"] as? [String: Any]{
                        location = "Hello, \(city["name"]!)"
                    }
                    if let days = dictionary["list"] as? [Any]{
                        for day in days{
                            let weather = WeatherData()
                            weather.location = location
                            if let info = day as? [String: Any]{
                                weather.day = "\(info["dt"]!)"
                                weather.wind = "\(info["speed"]!)"
                                weather.cloudiness = "\(info["clouds"]!)"
                                weather.pressure =  "\(info["pressure"]!)"
                                weather.humidity =  "\(info["humidity"]!)"
                                
                                if let temp = info["temp"] as? [String: Any]{
                                    for item in temp{
                                        if item.key == "day"{
                                            weather.temperature = "\(item.value) C"
                                        }
                                        if item.key == "min"{
                                            weather.info = "\(item.value)"
                                            weather.min = "\(item.value)"
                                        }
                                         
                                        if item.key == "max"{
                                            weather.info = weather.info+" / "+"\(item.value)"
                                            weather.max = "\(item.value)"
                                        }
                                    }
                                    
                                }
                            }
                            
                             if let infoWeather = day as? [String: Any]{
                             
                                if let weather2 = infoWeather["weather"] as? [Any]{
                                    if let weatherDay = weather2.first as? [String: Any]{
                                        for item in weatherDay{
                                            if item.key == "main"{
                                                weather.info = weather.info+" "+"\(item.value)"
                                                weather.image = "\(item.value)"
                                            }
                                        }
                                    }
                                }
                             }
                            self.weathers.append(weather)
                        }
                    }
                }
            }catch{
                
            }
            
        }

        
        task.resume()
        
        self.tableView.reloadData()
    }
}

