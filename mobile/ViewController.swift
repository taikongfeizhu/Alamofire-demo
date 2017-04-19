//
//  ViewController.swift
//  mobile
//
//  Created by huangjian on 2017/4/19.
//  Copyright © 2017年 huangjian. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class ViewController: UIViewController {
    
    @IBOutlet var tv:UITextView!
    
    @IBAction func btnPressed(sender:AnyObject){
        self.tv.text="数据请求中...."
        webRequest()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func jsonFromNetworking(){
        let strURL = "http://127.0.0.1:3002/network.json"
        let url = NSURL(string:strURL)
        let request = NSURLRequest(url: url! as URL)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if (error != nil){
                NSLog("Error:\(String(describing: error?.localizedDescription))")
            }
            else{
                let json = JSON(data: data!)
                //从JSON Dictionary中获取key为headers的JSON Dictionary，再从其中获取key为Host的string值
                let host = json["headers","Host"].string!
                let origin = json["origin"].string!
                let url = json["url"].string!
                print("host:\(host),\n origin:\(origin),\n url:\(url)")
            }
        }
        dataTask.resume()
        
        
    }
    
    func webRequest(){
        Alamofire.request("http://127.0.0.1:3002/network.json").responseJSON { response in
            print("request:", response.request!)  // original URL request
            print("response:", response.response!) // HTTP URL response
            print("data:", response.data!)     // server data
            print("result:", response.result)   // result of respon`se serialization
            let result = JSON(response.result.value!)
            print(">>>", result["url"].string!)
            self.tv.text = "url: \(result["url"])\nua: \(result["headers"]["User-Agent"])\norigin: \(result["origin"])"
        }
    }
    
    func localJson(){
        let path = Bundle.main.path(forResource: "Notes", ofType: "json")!
        let json = JSON(data: NSData(contentsOfFile: path)! as Data)
        
        //从JSON Dictionary中获取key为ResultCode的int值
        let resultCode = json["ResultCode"].int!
        print("ResultCode:\(resultCode)")
        let array = json["Record"]
        
        //从JSON Array中进行循环解析
        for (index,subJson):(String,JSON) in array {
            
            let userId = subJson["UserID"].string!
            let content = subJson["Content"].string!
            let date = subJson["Date"].string!
            
            print("\(index):\(userId) will do \(content) at \(date)")
        }
    }

}

