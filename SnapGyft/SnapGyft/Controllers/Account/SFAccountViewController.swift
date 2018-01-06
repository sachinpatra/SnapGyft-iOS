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
import expanding_collection
import SwiftMessages

class SFAccountViewController: ExpandingViewController {
    
    var accountKit: AKFAccountKit!
    var myProfile: Profile!
    let reachability = Reachability()!
    let coreData = AACoreData.sharedInstance()
    
    typealias ItemInfo = (imageName: String, title: String)
    var items: [ItemInfo] = [("item0", "UBER"),("item1", "OLA"),("item2", "PayTM"),("item3", "AMAZON")]
    
    //MARK: - View life cycle
    override func viewDidLoad() {
  //  itemSize = CGSize(width: 356, height: 250)
    
        super.viewDidLoad()
        
        registerCell()
        addGesture(to: collectionView!)


        coreData.fetchRecords(entityName: .ProfileEntityName) { (results) in
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            guard let profileList = results as? [Profile] else {
                self.accountKit.requestAccount{
                    (account, error) -> Void in
                    if let error = error {
                        self.backToLoginPageOnNetworkIssue(withMessage: error.localizedDescription)
                        return
                    }

                    //Save profile data with Authentication details
                    self.myProfile = self.coreData.getNewObject(entityName: .ProfileEntityName) as! Profile
                    self.myProfile.accountID = account?.accountID
                    if let phoneNumber = account?.phoneNumber {
                        self.myProfile.phoneNumber = phoneNumber.stringRepresentation()
                    }
                    if let emailID = account?.emailAddress {
                        self.myProfile.emailAddress = emailID
                    }
                    self.coreData.saveContext()
                    
                    //TODO:-  Remove this after sucess of service work
                    KRProgressHUD.dismiss({
                        self.startAlternateAuthentication()
                    })
                    
//
//                    guard (self.reachability.isReachable) else {
//                        self.backToLoginPageOnNetworkIssue(withMessage: "Check Network Connection."); return
//                    }
//                    //Call Here All three API's
//                    let payload: [String:String] = ["PhoneNumber": (self.myProfile.phoneNumber)!]
//                    let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
//                    Alamofire.request(Constants.API_ISREGISTERED_ACCOUNT,
//                                      method: .post,
//                                      parameters: params,
//                                      encoding: JSONEncoding.default,
//                                      headers : nil).validate().responseJSON {[weak self] response in
//                        guard response.result.isSuccess else {
//                            self?.backToLoginPageOnNetworkIssue(withMessage: (response.result.error?.localizedDescription)!)
//                            return
//                        }
//
//                        let payload: [String:Any] = ["PhoneNumber": account!.phoneNumber!.stringRepresentation(),
//                                                     "VerificationStatus": "Verified",
//                                                     "Device": SGUtility.deviceParamsForService]
//                        let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
//                        Alamofire.request(Constants.API_UPDATE_ACCOUNT_STATUS,
//                                          method: .post,
//                                          parameters: params,
//                                          encoding: JSONEncoding.default,
//                       headers : nil).validate().responseJSON { [weak self] response in
//
//                            guard response.result.isSuccess else {
//                                self?.backToLoginPageOnNetworkIssue(withMessage: (response.result.error?.localizedDescription)!)
//                                return
//                            }
//                            let payload: [String:Any] = ["AccountNumber": "236834"]
//                            let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
//                            Alamofire.request(Constants.API_ACCOUNT_DETAILS,
//                                          method: .post,
//                                          parameters: params,
//                                          encoding: JSONEncoding.default,
//                                          headers : nil).validate().responseJSON { [weak self] response in
//
//                                guard response.result.isSuccess else {
//                                    self?.backToLoginPageOnNetworkIssue(withMessage: (response.result.error?.localizedDescription)!)
//                                    return
//                                }
//                                KRProgressHUD.dismiss({
//                                    self?.startAlternateAuthentication()
//                                })
//                        }
//                    }
//
//                    }
                }

                return
            }
            
            self.myProfile = profileList.first
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionView?.frame = CGRect(x: 0, y: (self.collectionView?.frame.origin.y)! - 60, width: (self.collectionView?.frame.size.width)!, height: (self.collectionView?.frame.size.height)!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAddView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SwiftMessages.hide()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAddView() {
        var buttomView: MessageView
        buttomView = MessageView.viewFromNib(layout: .messageViewIOS8)
        buttomView.configureContent(title: "Hurry UP, Hurry Up!!!!", body: "Big Discount is going on to your nearest store. Grab Early THis Message is very important.. THis Message is very important This is very", iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        buttomView.configureDropShadow()
        let iconText = ["🐸", "🐷", "🐬", "🐠", "🐍", "🐹", "🐼"].sm_random()
        buttomView.configureTheme(backgroundColor: UIColor.purple, foregroundColor: UIColor.white, iconImage: nil, iconText: iconText)
        buttomView.button?.setImage(Icon.errorSubtle.image, for: .normal)
        buttomView.button?.setTitle(nil, for: .normal)
        buttomView.button?.backgroundColor = UIColor.clear
        buttomView.button?.tintColor = UIColor.green.withAlphaComponent(0.7)
        buttomView.button?.isHidden = true

        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        config.duration = .forever
        SwiftMessages.show(config: config, view: buttomView)
    }
    
    func registerCell() {
        let nib = UINib(nibName: String(describing: CardCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: CardCollectionViewCell.self))
    }
    
    
    func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(storyboard: .Main)
        let toViewController: CardDetailTableController = storyboard.instantiateViewController()
        return toViewController
    }
    
    func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(SFAccountViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }
        
        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(SFAccountViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }
    
    //MARK: - expanding_collection Delegates
    func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController())
        }
        
        let open = sender.direction == .up ? true : false
        if open == false{
        }else{
            let endcolor = cell.backgroundImageView.image?.getPixelColor(pos: CGPoint(x: 5, y: 5))
            cell.backsideView.startColor = endcolor!
        }
        cell.cellIsOpen(open)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // pageLabel.text = "\(currentIndex+1)/\(items.count)"
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        
        if cell.isOpened == true {
        }else{
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? CardCollectionViewCell else { return }
        
        switch indexPath.row {
        case 0:
            cell.cardValue.text = "$10"
        case 1:
            cell.cardValue.text = "$20"
        case 2:
            cell.cardValue.text = "$30"
        case 3:
            cell.cardValue.text = "$40"
        
        default:
            cell.cardValue.text = "$425"

        }
        
        let index = indexPath.row % items.count
        let info = items[index]
        cell.backgroundImageView?.image = UIImage(named: info.imageName)
        cell.customTitle.text = info.title
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
            , currentIndex == indexPath.row else { return }
        
        if cell.isOpened == false {
            cell.cellIsOpen(true)
            let endcolor = cell.backgroundImageView.image?.getPixelColor(pos: CGPoint(x: 5, y: 5))
            cell.backsideView.startColor = endcolor!
        } else {
            pushToViewController(getViewController())
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CardCollectionViewCell.self), for: indexPath)
    }
    
    //MARK: - Userdefiend Methods
    func backToLoginPageOnNetworkIssue(withMessage message:String) {
        KRProgressHUD.dismiss({
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Alertift.alert(title: "SnapGyft", message: message).action(.default("OK")){ _ in
                    if let account = self.accountKit {
                        account.logOut()
                    }
                    //self.accountKit.logOut()
                    self.coreData.deleteAllRecords(entity: .ProfileEntityName)
                    self.performSegue(withIdentifier: "backToLoginPageSegue", sender: self)
                }.show()
            }
        })
    }
    
    func startAlternateAuthentication() {
        guard let _ = self.myProfile.emailAddress else {
            Alertift.alert(title: "SnapGyft", message: "Please Authenticate EmailID. This is must before transaction. Do you want to proceed now?")
                .action(.cancel("Skip"))
                .action(.default("Proceed")) { _ in
                    let inputState: String = UUID().uuidString
                    let viewController = self.accountKit.viewControllerForEmailLogin(withEmail: nil, state: inputState) as? AKFViewController
                    self.prepareLoginViewController(viewController!)
                    self.present(viewController as! UIViewController, animated: true, completion: nil)
                }.show()
            
            return
        }
        
        if let _ = self.myProfile.phoneNumber?.isEmpty {
            Alertift.alert(title: "SnapGyft", message: "Please Authenticate Phone number. This is must before transaction. Do you want to proceed now?")
                .action(.cancel("Skip"))
                .action(.default("Proceed")) { _ in
                    let inputState: String = UUID().uuidString
                    let viewController = self.accountKit.viewControllerForPhoneLogin(with: nil, state: inputState) as? AKFViewController
                    self.prepareLoginViewController(viewController!)
                    self.present(viewController as! UIViewController, animated: true, completion: nil)
                }.show()
            
            return
        }
    }
    
    //MARK: - AKFAccountKit Delegate
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        self.accountKit.requestAccount{
            (account, error) -> Void in
            if let emailID = account?.emailAddress {
                self.myProfile.emailAddress = emailID
                Alertift.alert(title: "SnapGyft", message: "Email address sucessfully authenticated").action(.cancel("OK")).show()
            }
            if let phoneNumber = account?.phoneNumber {
                self.myProfile.phoneNumber = phoneNumber.stringRepresentation()
                Alertift.alert(title: "SnapGyft", message: "Phone number sucessfully authenticated").action(.cancel("OK")).show()
            }
            self.coreData.saveContext()
        }
    }
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("Login succcess with AuthorizationCode")
    }
    
    func viewController(_ viewController: UIViewController!, didFailWithError error: Error!) {
        print("We have an error \(error)")
    }
    
    func viewControllerDidCancel(_ viewController: UIViewController!) {
        print("The user cancel the login")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

}
