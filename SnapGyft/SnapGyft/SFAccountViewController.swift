//
//  SFAccountViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/17/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import KRProgressHUD
import Alertift
import ReachabilitySwift

class SFAccountViewController: UIViewController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var accountKit: AKFAccountKit!
    var myProfile: Profile!
    let reachability = Reachability()!
    let appdelObj: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        container?.performBackgroundTask({ [weak self] context in
            let profileCount = try? context.fetch(Profile.fetchRequest()).count
            if profileCount == 0{
                self?.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
                self?.accountKit.requestAccount{
                    (account, error) -> Void in
                    self?.myProfile = Profile.createProfile(accountID: account!.accountID, phoneNumber: account!.phoneNumber!.stringRepresentation(), in: context)
                    try? context.save()
                    //self?.myProfile = try! context.fetch(Profile.fetchRequest()).first!

                    guard (self?.reachability.isReachable)! else {
                        self?.backToLoginPageOnNetworkIssue(withMessage: "Check Network Connection.")
                        return
                    }
                    //Call Here All three API's
                    let payload: [String:String] = ["PhoneNumber": (self?.myProfile.phoneNumber)!]
                    let params: [String : Any] = ["Header": SGUtility().keyParamsForService, "Payload": payload]
                    Alamofire.request(Constants.API_ISREGISTERED_ACCOUNT,
                                      method: .post,
                                      parameters: params,
                                      encoding: JSONEncoding.default,
                                      headers : nil).responseJSON {[weak self] response in
                                        
                        switch response.result{
                        case .success:
                            let payload: [String:Any] = ["PhoneNumber": account!.phoneNumber!.stringRepresentation(),
                                                         "VerificationStatus": "Verified",
                                                         "Device": SGUtility().deviceParamsForService]
                            let params: [String : Any] = ["Header": SGUtility().keyParamsForService, "Payload": payload]
                            Alamofire.request(Constants.API_UPDATE_ACCOUNT_STATUS,
                                              method: .post,
                                              parameters: params,
                                              encoding: JSONEncoding.default,
                                              headers : nil).responseJSON { [weak self] response in
                                                
                                switch response.result{
                                case .success:
                                    let payload: [String:Any] = ["AccountNumber": "236834"]
                                    let params: [String : Any] = ["Header": SGUtility().keyParamsForService, "Payload": payload]
                                    Alamofire.request(Constants.API_ACCOUNT_DETAILS,
                                                      method: .post,
                                                      parameters: params,
                                                      encoding: JSONEncoding.default,
                                                      headers : nil).responseJSON { [weak self] response in
                                                        
                                        switch response.result{
                                        case .success(_):
                                            KRProgressHUD.dismiss()
                                            break
                                        case .failure(_):
                                            self?.backToLoginPageOnNetworkIssue(withMessage: "Service Down")
                                            break
                                        }
                                    }
                                    break
                                    
                                case .failure:
                                    self?.backToLoginPageOnNetworkIssue(withMessage: "Service Down")
                                    break
                                }
                            }
                            break
                            
                        case .failure:
                            self?.backToLoginPageOnNetworkIssue(withMessage: "Service Down")
                            break
                        }
                    }
                }
            }
        })
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - Userdefiend Methods
    
    func backToLoginPageOnNetworkIssue(withMessage message:String) {
        KRProgressHUD.dismiss({
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Alertift.alert(title: "SnapGyft", message: message).action(.default("OK")){ _ in
                    self.accountKit.logOut()
                    DispatchQueue.main.async(execute: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "RootNavigationStoryBoardID")
//                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginSotryBoardID")
                    self.appdelObj.window?.rootViewController = vc
                    })
                    
//                    DispatchQueue.main.async(execute: {
//                        self.performSegue(withIdentifier: "ShowLoginSegue", sender: self)
//                    })
                }.show()
            }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
