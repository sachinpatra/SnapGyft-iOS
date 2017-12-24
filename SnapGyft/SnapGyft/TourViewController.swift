//
//  TourViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/18/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import AccountKit
import Alertift
import Alamofire
import KRProgressHUD
import Alamofire_Synchronous
import ReachabilitySwift
import OnboardingKit

class TourViewController: UIViewController {

    @IBOutlet weak var onboardingView: OnboardingView!
    @IBOutlet weak var phoneButton: AwesomeButton!
    @IBOutlet weak var emailButton: AwesomeButton!
    var accountKit: AKFAccountKit!
    let reachability = Reachability()!

    private let model = ClientTourScreenModel()

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if accountKit == nil {
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        if let _ = accountKit.currentAccessToken {
            // if the user is already logged in, go to the main screen
            performSegue(withIdentifier: "ShowHomeSegue", sender: self); return
        }
        
        onboardingView.dataSource = model
        onboardingView.delegate = model
        //Do Button visible control over scroll of tour page
        model.didShow = { page in
        }
        model.willShow = { page in
            UIView.animate(withDuration: 0.3){
                switch page {
                case 0:
                    self.phoneButton.backgroundColor = UIColor(red: 220, green: 66, blue: 66)
                    self.emailButton.backgroundColor = UIColor(red: 220, green: 66, blue: 66)
                case 1:
                    self.phoneButton.backgroundColor = UIColor(red: 33, green: 184, blue: 252)
                    self.emailButton.backgroundColor = UIColor(red: 33, green: 184, blue: 252)
                case 2:
                    self.phoneButton.backgroundColor = UIColor.formerSubColor()
                    self.emailButton.backgroundColor = UIColor.formerSubColor()
                case 3:
                    self.phoneButton.backgroundColor = UIColor(red: 38, green: 149, blue: 116)
                    self.emailButton.backgroundColor = UIColor(red: 38, green: 149, blue: 116)
                case 4:
                    self.phoneButton.backgroundColor = UIColor(red: 88, green: 72, blue: 154)
                    self.emailButton.backgroundColor = UIColor(red: 88, green: 72, blue: 154)
                default:
                    break
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = accountKit.currentAccessToken {
            performSegue(withIdentifier: "ShowHomeSegue", sender: self); return
        }
    }

   //MARK: - Button Actions
    @IBAction func onPhoneButtonClicked(_ sender: Any) {
        let inputState: String = UUID().uuidString
        let viewController = accountKit.viewControllerForPhoneLogin(with: nil, state: inputState) as? AKFViewController
        viewController?.defaultCountryCode =  "IN" //"US"
        prepareLoginViewController(viewController!)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    @IBAction func onLoginButtonClicked(_ sender: Any) {
        let inputState: String = UUID().uuidString
        let viewController = accountKit.viewControllerForEmailLogin(withEmail: nil, state: inputState) as? AKFViewController
        prepareLoginViewController(viewController!)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    
    //MARK: - AKFAccountKit Delegate
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
        KRProgressHUD.show()
        
        /* Synchronous Request
         let response = Alamofire.request(Constants.API_UPDATE_ACCOUNT_STATUS, method: .post, parameters: params).responseJSON()
         if let json = response.result.value {
         print(json)
         }*/
    }
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("Login succcess with AuthorizationCode")
    }
    
    func viewController(_ viewController: UIViewController!, didFailWithError error: Error!) {
        print("We have an error \(error)")
        
        guard reachability.isReachable else {
            Alertift.alert(title: "SnapGyft", message: "Check Network Connection.").action(.default("OK")).show()
            return
        }
        
        //If failed by Facebook server, Then send Phone number to server to be update
        let payload: [String:String] = ["PhoneNumber": "1234567890"] //TODO:- Find Phone Number form Error
        let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
        Alamofire.request(Constants.API_ISREGISTERED_ACCOUNT,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers : nil).validate().responseJSON { response in
                            
            /*print(response)
             let disc = response.result.value as! Dictionary<String, Any>
             print(disc["IsRegistered"]!)*/
            guard response.result.isSuccess else {
                SGUtility.showAlert(withMessage: (response.result.error?.localizedDescription)!); return
            }
        }
        
    }
    
    func viewControllerDidCancel(_ viewController: UIViewController!) {
        print("The user cancel the login")
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func unwindToLoginViewControllre(segue:UIStoryboardSegue) {}

}


