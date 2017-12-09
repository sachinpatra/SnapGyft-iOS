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
    
    var accountKit: AKFAccountKit!
    var myProfile: Profile!
    let reachability = Reachability()!
    let instance = AACoreData.sharedInstance()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        instance.fetchRecords(entityName: .ProfileEntityName) { (results) in

            guard let _ = results as? [Profile] else {
                self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
                self.accountKit.requestAccount{
                    (account, error) -> Void in
                    
                    self.myProfile = self.instance.getNewObject(entityName: .ProfileEntityName) as! Profile
                    self.myProfile.accountID = account?.accountID
                    self.myProfile.phoneNumber = account?.phoneNumber?.stringRepresentation()
                    self.instance.saveContext()
                    
                    guard (self.reachability.isReachable) else {
                        self.backToLoginPageOnNetworkIssue(withMessage: "Check Network Connection.")
                        return
                    }
                    //Call Here All three API's
                    let payload: [String:String] = ["PhoneNumber": (self.myProfile.phoneNumber)!]
                    let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
                    Alamofire.request(Constants.API_ISREGISTERED_ACCOUNT,
                                      method: .post,
                                      parameters: params,
                                      encoding: JSONEncoding.default,
                                      headers : nil).responseJSON {[weak self] response in
                                        
                        switch response.result{
                        case .success:
                            let payload: [String:Any] = ["PhoneNumber": account!.phoneNumber!.stringRepresentation(),
                                                         "VerificationStatus": "Verified",
                                                         "Device": SGUtility.deviceParamsForService]
                            let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
                            Alamofire.request(Constants.API_UPDATE_ACCOUNT_STATUS,
                                              method: .post,
                                              parameters: params,
                                              encoding: JSONEncoding.default,
                                              headers : nil).responseJSON { [weak self] response in
                                                
                                switch response.result{
                                case .success:
                                    let payload: [String:Any] = ["AccountNumber": "236834"]
                                    let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
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
                
                return
            }
        }
        
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
                    //TODO:- Delete Profile data from DB before back to login page
                    self.performSegue(withIdentifier: "backToLoginPageSegue", sender: self)
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
