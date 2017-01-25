//
//  ViewController.swift
//  weatherApp
//
//  Created by Tiago Henrique on 12/21/16.
//  Copyright © 2016 Tiago Henrique. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var currentDegree: UILabel!
    @IBOutlet var currentImage: UIImageView!
    @IBOutlet var currentDate: UILabel!
    @IBOutlet var currentLocation: UILabel!
    @IBOutlet var currentDesc: UILabel!
    
    
    var weatherData: WeatherData!
    var weathers = Array<WeatherData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let dateAsString = formatter.string(from: NSDate() as Date)
        currentDate.text = dateAsString
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail"{
            let dataDetail = segue.destination as! DetailVC
            dataDetail.weatherData = self.weatherData
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.weatherData = weathers[indexPath.row + 1]
        self.performSegue(withIdentifier: "segueDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherViewCell
        
        let index = indexPath.row + 1
        
        let max = weathers[index].max
        let min = weathers[index].min
        
        cell.day.text = weathers[index].day
        if (max?.characters.count)! > 6 {
            cell.max.text = (max?.substring(to: (max?.index((max?.startIndex)!, offsetBy: 6))!))! + "°"
        }else{
             cell.max.text = max! + "°"
        }
        if (min?.characters.count)! > 6 {
            cell.min.text = (min?.substring(to: (min?.index((min?.startIndex)!, offsetBy: 6))!))! + "°"
        }else{
            cell.min.text = min! + "°"
        }
        cell.weather.text = weathers[index].info
        cell.weatherImg.image = UIImage(named: weathers[index].image+" Mini")
        return cell
    }
    
    func loadData() {
        
        weathers.removeAll()
        
        var zipcode: String!
        var measureV: String!
        
        if let zip = UserDefaults().string(forKey: "zipcode"){
            zipcode = "\(zip)"
        }else{
            zipcode = "14752"
        }
        
        let measure = UserDefaults().integer(forKey: "type")

        if measure == 1{
            measureV = "imperial"
        }else{
            measureV = "metric"
        }
        
        print(measureV)
        print(zipcode)
        
        let stringUrl = "http://api.openweathermap.org/data/2.5/forecast/daily?q=\(zipcode!)&units=\(measureV!)&cnt=7&APPID=809ca8d83020431d08cf4a78c95c5909"
        
        print(stringUrl)
        let url = URL(string: stringUrl)
        
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            guard error == nil && data != nil else {
                print("error=\(error)")
                return
            }

            do{
                var location: String = ""
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [])
                if let dictionary = jsonResult as? [String: Any]{
                    if let city = dictionary["city"] as? [String: Any]{
                        location = "\(city["name"]!)"
                    }
                    if let days = dictionary["list"] as? [Any]{
                        for day in days{
                            let weather = WeatherData()
                            weather.location = location
                            if let info = day as? [String: Any]{
                                
                                if let date = info["dt"] as? Double {
                                    let unixcode = Date(timeIntervalSince1970: date)
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateStyle = .full
                                    dateFormatter.dateFormat = "EEEE"
                                    dateFormatter.timeStyle = .none
                                    weather.day = unixcode.dayOfTheWeek()
                                }
                                
                                weather.wind = "\(info["speed"]!)"
                                weather.cloudiness = "\(info["clouds"]!)"
                                weather.pressure =  "\(info["pressure"]!)"
                                weather.humidity =  "\(info["humidity"]!)"
                                
                                if let temp = info["temp"] as? [String: Any]{
                                    for item in temp{
                                        if item.key == "day"{
                                            weather.temperature = "\(item.value) °"
                                        }
                                        if item.key == "min"{
                                            weather.min = "\(item.value)"
                                        }
                                         
                                        if item.key == "max"{
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
                                                weather.info = "\(item.value)"
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
            DispatchQueue.main.sync(execute: {
                
                let temp = self.weathers[0].temperature
                
                self.currentDegree.text = ""
                
                if (temp?.characters.count)! > 6 {
                    self.currentDegree.text = (temp?.substring(to: (temp?.index((temp?.startIndex)!, offsetBy: 6))!))!
                }else{
                    self.currentDegree.text = temp!
                }
                
                self.currentDesc.text = self.weathers[0].info!
                self.currentImage.image = UIImage(named: self.weathers[0].image!)
                self.currentLocation.text = self.weathers[0].location
                
                self.tableView.reloadData()
            })
            
        }
        
        
        task.resume()
    }
    
    
}
extension Date {
    
    func dayOfTheWeek() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE"
        return dateformatter.string(from: self)
    }
    
}

