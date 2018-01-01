//
//  UIViewController+Extention.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/24/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import AccountKit

extension UIViewController: AKFViewControllerDelegate {
    func prepareLoginViewController(_ loginViewController: AKFViewController) {
        
        loginViewController.delegate = self
        loginViewController.enableSendToFacebook = true
        //viewController.enableGetACall = true
        loginViewController.uiManager = AKFSkinManager.init(skinType: .classic, primaryColor: UIColor.formerSubColor(), backgroundImage: UIImage(named: "Login_Background"), backgroundTint: .white, tintIntensity: 0.60)
    }
}
