//
//  TabBarController.swift
//  Weatherforecast App
//
//  Created by 司佳蓉 on 12/1/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class TabBarController: UITabBarController {

    @IBAction func twitter1(_ sender: Any) {
//            let twitterAPI = "https://twitter.com/intent/tweet?"
//           let query = "text=The current temperature at \(self.city) is \(self.Weather_number!)." +
//           "The weather conditions are \(self.status1!).&hashtags=CSCI571WeatherSearch";
//           let twitterURL = twitterAPI + query
//           let twitterEncodedURL = twitterURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//           if let url = URL(string: twitterEncodedURL) {
//               UIApplication.shared.open(url)
//           }
        
    }
    var city: String = ""
    
//   let photoViewController: PhotosView = tabViewController.viewControllers?[1] as! PhotosView
//   let mapViewController: MapView = tabViewController.viewControllers?[2] as! MapView



    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.city

        let todayViewController: TodayViewController = self.viewControllers?[0] as! TodayViewController
        todayViewController.city = self.city
        
        let weekViewController: WeekViewController  = self.viewControllers?[1] as! WeekViewController
        weekViewController.city = self.city
        
        let photoViewController: photoViewController  = self.viewControllers?[2] as! photoViewController
        photoViewController.city = self.city

        
    }
 

}
