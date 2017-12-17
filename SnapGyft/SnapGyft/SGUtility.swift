//
//  SGUtility.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 11/24/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import Foundation
import Alertift
import KRProgressHUD

class SGUtility: NSObject {
        
    class var keyParamsForService: [String:String] {
        return ["MsgId": "1b4d68ff-c988-4af3-b53a-81356953d2ea",
                "MsgDateTime":  SGUtility.getCurrentTime(),
                "CustLangPref": "en-US",
                "SystemId": "Mobile_iOS"]
    }
    
    class var deviceParamsForService: [String:String] {
        return ["Type": UIDevice.current.model,
                "OS": UIDevice.current.systemName,
                "IPAddress": SGUtility.getIPAddress()!,
                "DeviceID": (UIDevice.current.identifierForVendor?.uuidString)!]
    }
    
   class func getIPAddress() -> String? {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    let name: String = String(cString: (interface?.ifa_name)!)
                    if name == "en0" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
   class func getCurrentTime() -> String {
        let now = Date.init(timeIntervalSinceNow: 0)
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ssZZZ"
        return formatter.string(from: now)
    }
    
    class func showAlert(withMessage message:String) {
        KRProgressHUD.dismiss({
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Alertift.alert(title: "SnapGyft", message: message).action(.default("OK")){ _ in
                    }.show()
            }
        })
    }
    
}



