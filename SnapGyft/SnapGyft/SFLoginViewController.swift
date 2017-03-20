//
//  SFLoginViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/18/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import AccountKit

class SFLoginViewController: UIViewController, AKFViewControllerDelegate {

    var accountKit: AKFAccountKit!

    override func viewDidLoad() {
        super.viewDidLoad()

        if accountKit == nil {
            // may also specify AKFResponseTypeAccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (accountKit.currentAccessToken != nil) {
            // if the user is already logged in, go to the main screen
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "ShowHomeSegue", sender: self)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginBtnClicked(_ sender: Any) {
        //            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
        // DispatchQueue.main.async(execute: {
        //login with Phone
        let inputState: String = UUID().uuidString
        let viewController:AKFViewController = self.accountKit.viewControllerForPhoneLogin(with: nil, state: inputState)  as! AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
        // })
    }
    
    //MARK: - AKFAccountKit Delegate
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("Login succcess with AccessToken")
    }
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("Login succcess with AuthorizationCode")
    }
    private func viewController(_ viewController: UIViewController!, didFailWithError error: NSError!) {
        print("We have an error \(error)")
    }
    func viewControllerDidCancel(_ viewController: UIViewController!) {
        print("The user cancel the login")
    }
    
    func prepareLoginViewController(_ loginViewController: AKFViewController) {
        
        loginViewController.delegate = self
        loginViewController.advancedUIManager = nil
        
        //Costumize the theme
//        let theme:AKFTheme = AKFTheme.default()
//        theme.headerBackgroundColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
//        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
//        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
//        theme.statusBarStyle = .default
//        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
//        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
//        loginViewController.theme = theme
        
        let theme:AKFTheme = AKFTheme.default()
        theme.headerBackgroundColor = UIColor.formerSubColor()
        //theme.headerTextType = .appName
        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
        theme.statusBarStyle = .default
        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
    
        
        theme.inputBackgroundColor = UIColor(red: 0.9, green: 0.55, blue: 0.08, alpha: 0.3)
        theme.buttonDisabledBackgroundColor = UIColor(red: 0.9, green: 0.55, blue: 0.08, alpha: 0.3)
        theme.buttonBackgroundColor = UIColor(red: 0.9, green: 0.55, blue: 0.08, alpha: 0.6)
        theme.buttonHighlightedBackgroundColor = UIColor.formerSubColor()
        loginViewController.theme = theme
        
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
