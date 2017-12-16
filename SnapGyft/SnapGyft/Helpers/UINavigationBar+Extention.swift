//
//  UINavigationBar+Extention.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/16/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

extension UINavigationBar {

    class func setupAppearance(){
        appearance().barTintColor = UIColor.formerSubColor()
        appearance().tintColor = UIColor.white
        appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UISearchBar.appearance().tintColor = UIColor.formerSubColor()
        UITabBar.appearance().tintColor = UIColor.formerSubColor()
    }
}
