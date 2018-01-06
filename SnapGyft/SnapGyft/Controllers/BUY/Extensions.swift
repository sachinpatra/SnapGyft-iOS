//
//  Extensions.swift
//  Example
//
//  Created by Lasha Efremidze on 12/19/17.
//  Copyright © 2017 Lasha Efremidze. All rights reserved.
//

import UIKit

extension UIView {
    func addParallax() {
        let group = UIMotionEffectGroup()
        group.motionEffects = [
            UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis, span: 20),
            UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis, span: 20)
        ]
        addMotionEffect(group)
    }
}

extension UIInterpolatingMotionEffect {
    convenience init(keyPath: String, type: UIInterpolatingMotionEffectType, span: Int) {
        self.init(keyPath: keyPath, type: type)
        self.minimumRelativeValue = -span
        self.maximumRelativeValue = span
    }
}
