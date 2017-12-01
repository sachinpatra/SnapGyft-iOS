//
//  SGUtility.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 11/24/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import Foundation


class SGUtility: NSObject {
    
    
    
    var keyParamsForService: [String:String] {
        return ["MsgId": "1b4d68ff-c988-4af3-b53a-81356953d2ea",
                "MsgDateTime": "1997-07-16 19:20:30.45+0100",
                "CustLangPref": "en-US",
                "SystemId": "Mobile_iOS"]
    }
    
    var deviceParamsForService: [String:String] {
        return ["Type": "iPhone6+",
                "OS": "iOS",
                "IPAddress": "192.168.1.102",
                "DeviceID": "01-02-03-04-05-06-07"]
    }
    
}
