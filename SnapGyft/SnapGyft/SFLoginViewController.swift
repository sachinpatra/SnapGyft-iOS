//
//  SFLoginViewController.swift
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

//enum LoginType: Int {
//    case Phone
//    case Email
//}

class SFLoginViewController: UIViewController, AKFViewControllerDelegate {

  //  @IBOutlet weak var loginUserTextFiled: UITextField!
    var accountKit: AKFAccountKit!
   // var loginType: LoginType!

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

//        //Add leftView in Login TextField
//        let leftImageView = UIImageView()
//        leftImageView.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
//        leftImageView.image = UIImage(named: "Login_User")
//        loginUserTextFiled.leftViewMode = .always
//        loginUserTextFiled.leftView = leftImageView
        
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
    
//    @IBAction func onGetStartedClicked(_ sender: UIButton) {
//        
//        if (loginUserTextFiled.text?.isContainsLetters)! {//Email
//            if (loginUserTextFiled.text?.isValidEmail)! {
//                
//                self.loginType = .Email
//                checkUserExistance()
//            }else{
//                Alertift.alert(title: "SnapGyft", message: "Please enter valid Email-ID")
//                    .action(.default("OK")).show()
//            }
//        }else{//Phone
//            if (loginUserTextFiled.text?.isValidPhoneNumber)! {
//                //            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
//                // DispatchQueue.main.async(execute: {
//                // })
//
//                self.loginType = .Phone
//                checkUserExistance()
//            }else{
//                Alertift.alert(title: "SnapGyft", message: "Please enter valid 10 digits number")
//                    .action(.default("OK")).show()
//            }
//        }
//    }
    

    //MARK: - Userdefiend Methods
    
    func prepareLoginViewController(_ loginViewController: AKFViewController) {
        
        loginViewController.delegate = self
        loginViewController.enableSendToFacebook = true
        //viewController.enableGetACall = true
        loginViewController.uiManager = AKFSkinManager.init(skinType: .classic, primaryColor: UIColor.formerSubColor(), backgroundImage: UIImage(named: "Login_Background"), backgroundTint: .white, tintIntensity: 0.60)
    }
    
    //MARK: - AKFAccountKit Delegate
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
        KRProgressHUD.show(withMessage: "UpdateAccount API", completion: nil)
        
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
        print("We have an error \(error)") //phone_number=919748736234
        
        //If failed by Facebook server, Then send Phone number to server to be update
        KRProgressHUD.show()
        let payload: [String:String] = ["PhoneNumber": "1234567890"] //TODO:- Find Phone Number form Error
        let params: [String : Any] = ["Header": SGUtility().keyParamsForService, "Payload": payload]
        Alamofire.request(Constants.API_ISREGISTERED_ACCOUNT,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers : nil).responseJSON { response in
                            
            /*print(response)
             let disc = response.result.value as! Dictionary<String, Any>
             print(disc["IsRegistered"]!)*/
            
            KRProgressHUD.dismiss()
            switch response.result{
            case .success:
                break
                
            case .failure:
                Alertift.alert(title: "SnapGyft", message: "Service Down").action(.default("OK")).show()
                break
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

}


