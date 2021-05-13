//
//  TodayViewController.swift
//  Weatherforecast App
//
//  Created by 司佳蓉 on 12/1/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class TodayViewController: UIViewController {
    
    
    @IBOutlet weak var windSpeed: UILabel!
    
    @IBOutlet weak var pressure: UILabel!
    
    @IBOutlet weak var precipitation: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var summary: UILabel!
    
    @IBOutlet weak var visibility: UILabel!
    
    @IBOutlet weak var cloudCover: UILabel!
    
    @IBOutlet weak var ozone: UILabel!
    
    
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

    
    
    private var data: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ASrequest()
        
    }
    
    
    func ASrequest(){
            var res: JSON?
//         print(self.city)
            var urlGeocode = "http://WeatherForecast-env.4qwmujidvt.us-east-2.elasticbeanstalk.com/getData"
            Alamofire.request(urlGeocode, parameters: ["city": self.city]).responseJSON{
                response in
                switch response.result{
                case.success(let value):
                let jsonGeocode = JSON(value)
//                print(jsonGeocode)
                let lat = jsonGeocode["results"][0]["geometry"]["location"]["lat"].stringValue
                let lng = jsonGeocode["results"][0]["geometry"]["location"]["lng"].stringValue

//                print(lat,lng)
                var urlInfo = "http://WeatherForecast-env.4qwmujidvt.us-east-2.elasticbeanstalk.com/getInfo?lat=" + lat + "&lng=" + lng
                Alamofire.request(urlInfo).responseJSON{
                    response in
                    switch response.result{
                    case.success(let value):
                    let jsonInfo = JSON(value)
//                    print(jsonInfo)
                        
                    self.windSpeed.text = String(round(jsonInfo["currently"]["windSpeed"].doubleValue * 100)/100) + "mph"
                        
                    self.pressure.text = String(round(jsonInfo["currently"]["pressure"].doubleValue + 100)/100) + "mb"
                 
                    self.precipitation.text = String(round(jsonInfo["currently"]["precipIntensity"].doubleValue + 100)/100) + "mmph"
                        
                    self.temperature.text = String(round(jsonInfo["currently"]["temperature"].doubleValue + 100)/100) + "°F"

                    var iconV = jsonInfo["currently"]["icon"].stringValue
                    
                        self.weatherIcon.image = UIImage(named: self.dic[iconV]!)
                        
                       self.summary.text = jsonInfo["currently"]["summary"].stringValue
                    
                        self.humidity.text = String(round((jsonInfo["currently"]["humidity"].doubleValue * 100) * 100)/100) + "%"
                    self.visibility.text = String(round(jsonInfo["currently"]["visibility"].doubleValue * 100)/100) + "km"
                        
                    self.cloudCover.text =
                       String(round((jsonInfo["currently"]["cloudCover"].doubleValue * 100) * 100)/100) + "%"
                        
                    self.ozone.text = String(round(jsonInfo["currently"]["ozone"].doubleValue * 100)/100) + "DU"
               
                        
                    case .failure(let error2):
                        print(error2)
                    }
                }

                    case .failure(let error1):
                        print(error1)
                    }
            }
    }}
    
    
    
    
    

    


