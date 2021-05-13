//
//  photoViewController.swift
//  Weatherforecast App
//
//  Created by 司佳蓉 on 12/2/19.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class photoViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var city: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ASrequest()
        SwiftSpinner.show("Fecthing Google Images...")
        
        scrollView.contentSize = CGSize(width: 374, height: 480 * 8)

//        let url = URL(string: "https://i.redd.it/snvrl97axmb11.jpg")!
//        if let data = try? Data(contentsOf:url as URL){
//            print("aaa")
//            var image = UIImage(data:data as Data, scale: 1.0)
//            var imageview : UIImageView = UIImageView(image: image)
//            var frame = CGRect(x: 0, y: 0, width: 374, height: 480)
//            imageview.frame = frame
//            self.scrollView.addSubview(imageview)
//        }
//
//
//        var url1 : NSURL = NSURL(string: "http://img.ivsky.com/img/tupian/pre/201509/13/tianzhukui.jpg")!
//        var data1 : NSData = NSData(contentsOf:url1 as URL)!
//
//        var image1 = UIImage(data:data1 as Data, scale: 1.0)
//        var imageview1 : UIImageView = UIImageView(image: image1)
//        var frame1 = CGRect(x: 0, y: 482, width: 374, height: 480)
//        imageview1.frame = frame1
//        self.scrollView.addSubview(imageview1)
//
        SwiftSpinner.hide()

        
        ASrequest()
        
        

    }
    
    var photos: [String] = []
    

    func ASrequest(){
//        let frame = UIImageView(image: UIImage())
//        frame.frame = CGRect(x: 0, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>)
//        scrollView.addSubview(frame)
        var res: JSON?
        var urlPhoto = "http://WeatherForecast-env.4qwmujidvt.us-east-2.elasticbeanstalk.com/customSearch".urlEncoded()
//
        
        Alamofire.request(urlPhoto, parameters: ["city": self.city]).responseJSON{
                        response in
                        switch response.result{
                        case.success(let value):
                        let jsonPhoto = JSON(value)
                        var length = jsonPhoto["items"].count
//                            print(jsonPhoto)
                        
                        for i in 0..<min(length, 8){
                           self.photos.append(jsonPhoto["items"][i]["link"].stringValue)
                            let url = URL(string: self.photos[i])
                            if let data = try? Data(contentsOf:url!){
                                var image = UIImage(data:data as Data, scale: 1.0)
                                var imageview : UIImageView = UIImageView(image: image)
                                var y0 = 480 * i
                                var frame = CGRect(x: 0, y: y0, width: 374, height: 480)
                                imageview.frame = frame
                                self.scrollView.addSubview(imageview)
                            }

                        }
                        
                        
                        
//                        let url = URL(string: self.photos[0])
//                        print(url)
//                        let data = try? Data(contentsOf: url!)
//                        let image = UIImage(data: data!)
//                        let imageView = UIImageView(image: image)
//                         imageView.frame = CGRect(x: 0, y: 0, width: 374, height: 480)
//                        //
//                        self.scrollView.addSubview(imageView)
                        
                        
                     
                            
//                        var photo_link0 = jsonPhoto["items"][0]["link"].stringValue
//                        var url0 = NSURL(string: photo_link0)
//                        print(url0)
//                        var data0 = NSData(contentsOf:(url0 as! URL))
//                        print(data0)
//                        let image0 = UIImage(data:data0! as Data)
//                        let imageView0 = UIImageView(image:image0)
//                        imageView0.frame = CGRect(x: 0, y: 0, width: 374, height: 480)
//
//                        self.scrollView.addSubview(imageView0)


                        
                        
//                        var url : NSURL = NSURL(string: "http://img0.bdstatic.com/img/image/shouye/xinshouye/sheji202.jpg")!
//                               var data : NSData = NSData(contentsOf:url as URL)!
//
//                               var image = UIImage(data:data as Data, scale: 1.0)
//                               var imageview : UIImageView = UIImageView(image: image)
//                               var frame = CGRect(x: 0, y: 0, width: 320, height: 480)
//                               imageview.frame = frame
//                               self.view.addSubview(imageview)
                            
                        
    
//                        print(self.photos)
                        case .failure(let error):
                            print(error)
                       
            }
                        
        }
        
    }
    


}

extension String {
 
//将原始的url编码为合法的url
func urlEncoded() -> String {
    let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
        .urlQueryAllowed)
    return encodeUrlString ?? ""
}
 

}
