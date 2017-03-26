//
//  UIViewController+Extention.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/22/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

extension UIViewController {

    //MARK:- Alert Function
    func alertShow(strMessage: String) {
        let alert = UIAlertController(title: "SnapGyft", message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:nil))
        self.present(alert, animated: true, completion: nil)
    }
}
