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
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dataDetail = segue.destination as! DetailViewController
        dataDetail.weatherData = self.weatherData
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast/daily?q=14752&units=metric&cnt=16&APPID=809ca8d83020431d08cf4a78c95c5909")
        
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard error == nil && data != nil else {
                print("error=\(error)")
                return
            }
            
            var finalString: String
            
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [])
                print(jsonResult)
                if let dictionary = jsonResult as? [String: Any]{
                    if let city = dictionary["city"] as? [String: Any]{
                        let location = city["name"]!
                    }
                    if let days = dictionary["list"] as? [Any]{
                        for day in days{
                            finalString = ""
                            if let info = day as? [String: Any]{
                                let day = info["dt"]!
                                if let temp = info["temp"] as? [String: Any]{
                                    for item in temp{
                                        if item.key == "day"{
                                            let temperature = "\(item.value)"
                                        }
                                        if item.key == "min"{
                                            finalString = "\(item.value)"
                                        }
                                         
                                        if item.key == "max"{
                                            finalString = finalString+" / "+"\(item.value)"
                                        }
                                    }
                                    
                                }
                            }
                            
                             if let infoWeather = day as? [String: Any]{
                             
                                if let weather = infoWeather["weather"] as? [Any]{
                                    if let weatherDay = weather.first as? [String: Any]{
                                        for item in weatherDay{
                                            if item.key == "main"{
                                                finalString = finalString+" "+"\(item.value)"
                                            }
                                        }
                                    }
                                }
                             }
                            let weather = WeatherData()
                            weather.info = finalString
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

