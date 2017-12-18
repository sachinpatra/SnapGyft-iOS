//
//  UIApplication+Extention.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/18/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

extension UIApplication {
     class func isFirstLaunch() -> Bool {
        guard UserDefaults.standard.bool(forKey: "IsFirstLaunchKey") else {
            UserDefaults.standard.set(true, forKey: "IsFirstLaunchKey")
            UserDefaults.standard.synchronize()
            return true;
        }
        return false
    }
}
