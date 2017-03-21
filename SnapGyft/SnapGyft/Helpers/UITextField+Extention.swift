//
//  UITextField+Extention.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/22/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

extension UITextField {

    func padding(width: CGFloat) {
        let label = UILabel(frame: CGRect(x :0,y :0,width :width,height: 10))
        label.text = " "
        self.leftViewMode = .always
        self.leftView = label
    }
}
