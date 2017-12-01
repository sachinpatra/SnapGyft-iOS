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

class SFAccountViewController: UIViewController {
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    var accountKit: AKFAccountKit!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        container?.performBackgroundTask({ [weak self] context in
            let profileCount = try? context.fetch(Profile.fetchRequest()).count
            if profileCount == 0{
                self?.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
                self?.accountKit.requestAccount{
                    (account, error) -> Void in
                    _ = Profile.createProfile(accountID: account!.accountID, phoneNumber: account!.phoneNumber!.stringRepresentation(), in: context)
                    try? context.save()
                    
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
                            KRProgressHUD.update(message: "AccountDetails API")
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
                                    self?.onServiceFailure()
                                    break
                                }
                            }
                            break
        
                        case .failure:
                            self?.onServiceFailure()
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
    func onServiceFailure() {
        KRProgressHUD.dismiss({
            let alert = UIAlertController(title: "SnapGyft", message: "Service Down", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                self.accountKit.logOut()
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "ShowLoginSegue", sender: self)
                })
            }))
            self.present(alert, animated: true, completion: nil)
        })

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
