//
//  SFAccountViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/17/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import Alamofire

class SFAccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  let request = Network.request("https://httpbin.org/get").query(["foo": "bar", "sachin": "patra"]).build()
//        request?.responseJSON(completionHandler: { (_, URLResponse, JSONData, error) -> Void in
//            print("sachin = \(JSONData!)")
//            
//            let dict = JSONData as! [String:Any]
//            print("sachin \(dict)")
//
//        })
        
        
        let url = "https://hybridapp1.azurewebsites.net/api/register/RegisterUser"
        let keyParams: [String:String]   = ["MsgId": "1b4d68ff-c988-4af3-b53a-81356953d2ea",
                          "MsgDateTime": "1997-07-16 19:20:30.45+0100",
                          "CustLangPref": "en-In",
                          "SystemId": "Mobile_Android",]
        let par: [String:String] = ["MobileNumber": "8984048840"]
        let params: [String : Any] = ["Header": keyParams, "Payload": par]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers : nil)
            .responseJSON { response in
                
                print(response)
                let disc = response.result.value as! Dictionary<String, Any>
                print(disc["UserID"]!)
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
