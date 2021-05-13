//
//  WeekViewController.swift
//  Weatherforecast App
//
//  Created by 司佳蓉 on 12/1/19.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts


class WeekViewController: UIViewController {

    @IBOutlet weak var weather_icon: UIImageView!
    
    @IBOutlet weak var view1: UIView!
//    view1.layer.cornerRadius = 10
    
    var points:[Double] = []
    
    @IBOutlet weak var weather_summary: UILabel!
    
    @IBOutlet weak var chtChart: LineChartView!
    
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
    
    var tempHigh: [Double] =  []
    var tempLow : [Double] = []
    
    
        var numbers = [0,1,1,2,3,3,4,5,4,1,7,9,3,2,4,0,4,2,7,8,6,5,3,7,4,8]
    
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
//                        print(jsonInfo)
                        
                            
                        self.weather_summary.text = jsonInfo["daily"]["summary"].stringValue
                        var iconV = jsonInfo["currently"]["icon"].stringValue
                        self.weather_icon.image = UIImage(named: self.dic[iconV]!)
                        var datas = jsonInfo["daily"]["data"]
                        var length = datas.count

                        for i in 0..<length{
                            self.tempHigh.append(datas[i]["temperatureHigh"].doubleValue)
                            self.tempLow.append(datas[i]["temperatureLow"].doubleValue)

                        }
//                        print(self.tempLow)
                        self.updateGraph()
                       
                        case .failure(let error2):
                            print(error2)
                        }
                    }

                        case .failure(let error1):
                            print(error1)
                        }
                }
        
        
        }
        func updateGraph(){
//                                   print("self.tempLow")
//                                   print(self.tempLow)

                                var lineChartEntry = [ChartDataEntry]()
                            var lineChartEntry2 = [ChartDataEntry]()

                            for i in 0..<self.tempLow.count{
                                               let value = ChartDataEntry(x:Double(i),y:Double(self.tempLow[i]))
                                                  lineChartEntry.append(value)
                            }
                                              let line2 = LineChartDataSet(entries:lineChartEntry,label:"Maximum Temperature (°F)")
                                              line2.colors = [NSUIColor.blue]
                            line2.circleHoleRadius = 0
                            line2.circleRadius = 4
                            line2.circleColors = [NSUIColor.blue]
   
            
                                   for i in 0..<self.tempHigh.count{
                                       let value = ChartDataEntry(x:Double(i),y:Double(self.tempHigh[i]))
                                          lineChartEntry2.append(value)
                                      }
                                      let line1 = LineChartDataSet(entries:lineChartEntry2,label:"Maximum Temperature (°F)")
                                      line1.colors = [NSUIColor.white]
                    line1.circleHoleRadius = 0
                    line1.circleRadius = 4
                    line1.circleColors = [NSUIColor.white]

                                      
                                      let data = LineChartData()
                                      
                                      data.addDataSet(line1)
                                        data.addDataSet(line2)
                                   self.chtChart.data = data
                                      
                               }


}
