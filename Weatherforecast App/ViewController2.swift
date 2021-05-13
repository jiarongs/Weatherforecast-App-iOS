//
//  ViewController2.swift
//  Weatherforecast App
//
//  Created by 司佳蓉 on 11/28/19.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import SwiftSpinner


class ViewController2: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var count = 0

    @IBOutlet weak var image_plus: UIImageView!
    
//    func showPlus(){
     
    
    
    
    @IBAction func btn_fav(_ sender: Any) {

        count += 1
        
        if count>0 && count%2 == 1{
            var city0 = String(self.city.split(separator: ",")[0])
                   
            self.view.makeToast(city0 + " was added to the favorite list")
            self.image_plus.image = UIImage(named:"trash-can")
            
        } else if count>0 && count%2 == 0{
            
            var city0 = String(self.city.split(separator: ",")[0])
                              
            self.view.makeToast(city0 + "was removed from the favorite list")
            
            self.image_plus.image = UIImage(named:"plus-circle")
        }
        
       
    }
    
    
    @IBOutlet weak var weather_icon: UIImageView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let uiView: TabBarController = segue.destination as! TabBarController
            uiView.city = self.city
    }
    
    @IBAction func button(_ sender: Any) {
//        print("self.city")
        performSegue(withIdentifier: "segue_detail", sender: self)
    }
    
    
    @IBOutlet weak var Weather_number: UILabel!
    
    @IBOutlet weak var status1: UILabel!
    
    @IBOutlet weak var city1: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var windSpeed1: UILabel!
    
    @IBOutlet weak var visibility1: UILabel!
    
    @IBOutlet weak var pressure1: UILabel!
    
    var city: String = ""
    let dic = [
      "clear-day": "weather-sunny",
      "clear-night": "weather-night",
      "rain": "weather-rainy",
      "snow" : "weather-snowy",
      "sleet" : "weather-snowy-rainy",
      "wind" : "weather-windy-variant",
      "fog" : "weather-fog",
      "cloudy" : "weather-cloudy",
      "partly-cloudy-night" : "weather-night-partly-cloudy",
      "partly-cloudy-day" : "weather-partly-cloudy"
    ]
    var longitude = 0.0
    var latitude = 0.0
    var dates: [String] = []
    var sun_rises: [String] = []
    var sun_sets: [String] = []
    var weather_pic: [String] = []
  
    @IBAction func twitter(_ sender: Any) {
//        guard let url = URL(string: "https://www.twitter.com") else {
//          return //be safe
//        }
//
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        } else {
//            UIApplication.shared.openURL(url)
//        }
        
        
        let twitterAPI = "https://twitter.com/intent/tweet?"
        let query = "text=The current temperature at \(self.city) is \(self.Weather_number!)." +
        "The weather conditions are \(self.status1!).&hashtags=CSCI571WeatherSearch";
        let twitterURL = twitterAPI + query
        let twitterEncodedURL = twitterURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if let url = URL(string: twitterEncodedURL) {
            UIApplication.shared.open(url)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if count == 0{
            self.image_plus.image = UIImage(named:"plus-circle")
             
             }
        self.navigationItem.title = self.city

        self.tableView.delegate = self
        ASrequest()
        SwiftSpinner.show("Fecthing Weather Details for " + self.city)

        
        tableView.dataSource = self as! UITableViewDataSource
        super.viewDidLoad()

    }
    
         
    
     func ASrequest(){
            var res: JSON?
                      
            var urlGeocode = "http://WeatherForecast-env.4qwmujidvt.us-east-2.elasticbeanstalk.com/getData"
            Alamofire.request(urlGeocode, parameters: ["city": self.city]).responseJSON{
                response in
                switch response.result{
                case.success(let value):
                let jsonGeocode = JSON(value)
    //            print(jsonGeocode)
                let lat = jsonGeocode["results"][0]["geometry"]["location"]["lat"].stringValue
                let lng = jsonGeocode["results"][0]["geometry"]["location"]["lng"].stringValue

                
    //            print(lat,lng)
                var urlInfo = "http://WeatherForecast-env.4qwmujidvt.us-east-2.elasticbeanstalk.com/getInfo?lat=" + lat + "&lng=" + lng
                Alamofire.request(urlInfo).responseJSON{
                    response in
                    switch response.result{
                    case.success(let value):
                    let jsonInfo = JSON(value)
                    self.city1.text = String(self.city.split(separator: ",")[0])
                    self.Weather_number.text = String(round(jsonInfo["currently"]["temperature"].doubleValue * 100)/100) + "°F"
                    self.status1.text = jsonInfo["currently"]["summary"].stringValue
                    self.humidity.text = String(round((jsonInfo["currently"]["humidity"].doubleValue * 100) * 100)/100) + "%"
                    self.windSpeed1.text = String(round(jsonInfo["currently"]["windSpeed"].doubleValue * 100)/100) + "mph"
                    self.visibility1.text = String(round(jsonInfo["currently"]["visibility"].doubleValue * 100)/100) + "km"
                    self.pressure1.text = String(round(jsonInfo["currently"]["pressure"].doubleValue + 100)/100) + "mb"
                    var iconV = jsonInfo["currently"]["icon"].stringValue
                    self.weather_icon.image = UIImage(named: self.dic[iconV]!)

                    
                    self.dates = []
                    for i in 1..<8{
                        
                        var time = jsonInfo["daily"]["data"][i]["time"].stringValue
                        var sunrise_time = jsonInfo["daily"]["data"][i]["sunriseTime"].stringValue
                        var sunset_time = jsonInfo["daily"]["data"][i]["sunsetTime"].stringValue
                        
                        var iconn = jsonInfo["daily"]["data"][i]["icon"].stringValue

                        
                        let timeInterval:TimeInterval = TimeInterval(time) as! TimeInterval
                        let timeInterval2:TimeInterval = TimeInterval(sunrise_time) as! TimeInterval
                        let timeInterval3:TimeInterval = TimeInterval(sunset_time) as! TimeInterval
                        
                        let date = Date(timeIntervalSince1970: timeInterval)
                        let time1 = Date(timeIntervalSince1970: timeInterval2)
                        let time2 = Date(timeIntervalSince1970: timeInterval3)
                        
                        let dformatter1 = DateFormatter()
                        let dformatter2 = DateFormatter()

                        dformatter1.dateFormat = "MM/dd/yyyy"
                        dformatter2.dateFormat = "HH:mm"
                        
                        self.dates.append(dformatter1.string(from: date))
                        self.sun_rises.append(dformatter2.string(from: time1))
                        self.sun_sets.append(dformatter2.string(from: time2))
                        self.weather_pic.append(iconn)

                    }
                    self.tableView.reloadData()

//                    print(self.dates)
    //                print(self.sun_rises)
    //                print(self.sun_sets)
                      SwiftSpinner.hide()

                        
                        
                        
                        
                        
                      
                        
                        
                    case .failure(let error2):
                        print(error2)
                    }
                }

                    case .failure(let error1):
                        print(error1)
                    }
            }
        
        
                
        }
        
    
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

                 let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! CustomTableViewCell
//                 print(dates)
//                print(dates.count)
        if(dates.count == 0){
            return cell
        }else{
            let textD = dates[indexPath.row]
            cell.date.text = textD
            cell.sunrise_t.text = sun_rises[indexPath.row]
            cell.sunset_t.text = sun_sets[indexPath.row]
            
            cell.icon0.image = UIImage(named: self.dic[weather_pic[indexPath.row]]!)

            return cell
        }
    }
                     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7

    }
    
                     
                     
     
    
    
   
    






}
   
