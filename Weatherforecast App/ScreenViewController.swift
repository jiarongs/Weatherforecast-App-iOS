//
//  ScreenViewController.swift
//  Weatherforecast App
//
//  Created by 司佳蓉 on 11/27/19.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import Toast_Swift
import SwiftSpinner


class ScreenViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate {
    

    
//    @IBOutlet weak var dates00: UILabel!
    
    @IBOutlet weak var search: UISearchBar!
    
    
    @IBAction func button(_ sender: Any) {
        performSegue(withIdentifier: "segue00", sender: self)

    }
    
    
    
    @IBOutlet weak var weather_icon_big: UIImageView!
    
    
 
    @IBOutlet weak var tableVIew: UITableView!
    
    
    @IBOutlet weak var temp_num: UILabel!
    
    @IBOutlet weak var summary: UILabel!
    
    @IBOutlet weak var curr_city: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var wind_speed: UILabel!
    
    @IBOutlet weak var visibility: UILabel!
    
    @IBOutlet weak var pressure: UILabel!
    
    
    
    @IBOutlet weak var week_table: UITableView!
    
    
    var dates: [String] = []
       var sun_rises: [String] = []
       var sun_sets: [String] = []
    
    
    var ctrlsel:[String] = ["ghj", "hkl", "kkk"]
    var ctrls:[String] = []
    var city: String = ""
private var data: [String] = []
    
    public let locationManagerVar = CLLocationManager()
    public var locationInformation: [CLLocation] = [CLLocation]()
    public var timer:Timer?
    public var count: Int = 0
    public var lastTime: Date?
    public var distanceTotal: Double = 0.0
    public var lat: String = ""
    public var lng: String = ""

    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegate
        self.search.delegate = self
        self.tableVIew.delegate = self
        self.tableVIew.dataSource = self
        self.week_table.dataSource = self
        self.week_table.delegate = self
       //self.week_table.register(UITableViewCell.self, forCellReuseIdentifier: "idf")
        
        
        self.tableVIew.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableVIew.isHidden = true;
        self.navigationItem.titleView = search
        
        for i in 0...10 {
                 data.append("\(i)")
            }
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "twitter") , style: .plain, target: self, action: )
        
        enableLocationServices()
        escalateLocationServiceAuthorization()
        checkForLocationServices()
        locationManagerVar.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManagerVar.requestAlwaysAuthorization()
        locationManagerVar.startUpdatingLocation()
        locationManagerVar.delegate = self as! CLLocationManagerDelegate
        
        SwiftSpinner.show("loading")
        
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == self.tableVIew{
            return data.count

        }

        return 7
    }

    //table row counts
//    func tableView(_ week_table: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 7
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {

            var cell = UITableViewCell()
            if tableView == self.tableVIew{
                let identify:String = "cell"
                       // 同一形式的单元格重复使用，在声明时已注册
                cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                                for: indexPath)
                       //cell.accessoryType = .disclosureIndicator
                cell.textLabel?.text = self.ctrlsel[indexPath.row]
                return cell

            } else if tableView == self.week_table{
                let cell = tableView.dequeueReusableCell(withIdentifier: "idf") as! CustomTableViewCell
                //                 print(dates)
                //                print(dates.count)
                        if(dates.count == 0){
                            return cell
                        }else{
                            let textD = dates[indexPath.row]
                            cell.date.text = textD
                            cell.sunrise_t.text = sun_rises[indexPath.row]
                            cell.sunset_t.text = sun_sets[indexPath.row]
                            
//                            cell.icon0.image = UIImage(named: self.dic[weather_pic[indexPath.row]]!)

                            return cell
                        }
            }
       return cell
    }
    

    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        // locations.last is the latest location in the array
        let location = locations.last!
        // Do something with the location.
//        print("loc:\(location)")
        lat =  String(format:"%f", location.coordinate.latitude)
        lng = String(format:"%f", location.coordinate.longitude)
        var urlInfo = "http://WeatherForecast-env.4qwmujidvt.us-east-2.elasticbeanstalk.com/getInfo?lat=" + lat + "&lng=" + lng
        Alamofire.request(urlInfo).responseJSON{
                   response in
                   switch response.result{
                   case.success(let value):
                   let jsonInfo = JSON(value)
//                    print(jsonInfo)
                   self.temp_num.text = String(round(jsonInfo["currently"]["temperature"].doubleValue * 100)/100) + "°F"
                   self.summary.text = jsonInfo["currently"]["summary"].stringValue
                   self.humidity.text = String(round((jsonInfo["currently"]["humidity"].doubleValue * 100) * 100)/100) + "%"
                   self.wind_speed.text = String(round(jsonInfo["currently"]["windSpeed"].doubleValue * 100)/100) + "mph"
                   self.visibility.text = String(round(jsonInfo["currently"]["visibility"].doubleValue * 100)/100) + "km"
                   self.pressure.text = String(round(jsonInfo["currently"]["pressure"].doubleValue + 100)/100) + "mb"
                   var iconV = jsonInfo["currently"]["icon"].stringValue
                    print(iconV)
                   self.weather_icon_big.image = UIImage(named: self.dic[iconV]!)
                   
                   
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
//                       self.weather_pic.append(iconn)

                   }
                   self.week_table.reloadData()
                   
        SwiftSpinner.hide()
      
                   case .failure(let error):
                    print(error)
            }
            
        }
    
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableVIew{
            return 1
        }
        return 7
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
    }

    func checkForLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // Location services are available, so query the user’s location.
        } else {
            // Update your app’s UI to show that the location is unavailable.
        }
    }
    func enableLocationServices() {
        let status = CLLocationManager.authorizationStatus()
        if status != .authorizedAlways || status != .authorizedWhenInUse
        {
            // Request when-in-use authorization initially
            locationManagerVar.requestWhenInUseAuthorization()
        }
       
    }
    func escalateLocationServiceAuthorization() {
        // Escalate only when the authorization is set to when-in-use
        // 仅在授权被使用时才获取位置升级为一直获取位置
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManagerVar.requestAlwaysAuthorization()
        }
    }
                         
      
    

    
    //transfer
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    print("You tapped cell number \(indexPath.row).")
        var click = self.ctrlsel[indexPath.row]
        self.city = click
//        print(self.city)
        performSegue(withIdentifier: "segue1", sender: self)
        
    }
     
    // 搜索代理UISearchBarDelegate方法，每次改变搜索内容时都会调用
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 没有搜索内容时显示全部组件
        if searchText == "" {
            tableVIew.isHidden = true
        }
        else {
            var res: JSON?
            var urlAuto = "http://WeatherForecast-env.4qwmujidvt.us-east-2.elasticbeanstalk.com/getCity?city=" + searchText
                Alamofire.request(urlAuto).responseJSON{
                        response in
                        switch response.result{
                        case.success(let value):
                            let jsonAuto = JSON(value)

                            if let auto_array = jsonAuto["predictions"].array {

                                var tmp:[String] = []
                                for jsonCurr in auto_array{
                                    let jsonCurr_structured = jsonCurr["structured_formatting"]
                                    var curr_string: String = jsonCurr_structured["main_text"].stringValue
                                    curr_string += ", "
                                    curr_string += jsonCurr_structured["secondary_text"].stringValue
                                    tmp.append(curr_string)
                                
                                }
                                self.ctrlsel = tmp
                                if(self.ctrlsel.count > 0){
                                    self.tableVIew.isHidden = false;
                                    self.tableVIew.reloadData()

                                }
                            }
                        case.failure(let error):
                            print(error)
                        }
                    }
        }
        // 刷新Table View显示
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1"{
            let searchBar: ViewController2 = segue.destination as! ViewController2
            searchBar.city = self.city
        }else if segue.identifier == "segue00"{
            let tabBar: TabBarController = segue.destination as! TabBarController
             tabBar.city = "Los Angeles,CA,USA"
        }
 
    }
    
    
}


