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
    fileprivate let items: [ItemInfo] = [("item0", "UBER"),("item1", "OLA"),("item2", "PayTM"),("item3", "AMAZON")]
    
    override func viewDidLoad() {
        
//    itemSize = CGSize(width: 256, height: 335)
        
        super.viewDidLoad()
        
        registerCell()
        addGesture(to: collectionView!)
        
        showAddView()

        coreData.fetchRecords(entityName: .ProfileEntityName) { (results) in
            guard let _ = results as? [Profile] else {
                self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
                self.accountKit.requestAccount{
                    (account, error) -> Void in
                    if let error = error {
                        self.backToLoginPageOnNetworkIssue(withMessage: error.localizedDescription)
                        return
                    }
                    
                    self.myProfile = self.coreData.getNewObject(entityName: .ProfileEntityName) as! Profile
                    self.myProfile.accountID = account?.accountID
                    self.myProfile.phoneNumber = account?.phoneNumber?.stringRepresentation()
                    self.coreData.saveContext()
                    
                    guard (self.reachability.isReachable) else {
                        self.backToLoginPageOnNetworkIssue(withMessage: "Check Network Connection."); return
                    }
                    //Call Here All three API's
                    let payload: [String:String] = ["PhoneNumber": (self.myProfile.phoneNumber)!]
                    let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
                    Alamofire.request(Constants.API_ISREGISTERED_ACCOUNT,
                                      method: .post,
                                      parameters: params,
                                      encoding: JSONEncoding.default,
                                      headers : nil).validate().responseJSON {[weak self] response in
                        guard response.result.isSuccess else {
                            self?.backToLoginPageOnNetworkIssue(withMessage: (response.result.error?.localizedDescription)!)
                            return
                        }
                        
                        let payload: [String:Any] = ["PhoneNumber": account!.phoneNumber!.stringRepresentation(),
                                                     "VerificationStatus": "Verified",
                                                     "Device": SGUtility.deviceParamsForService]
                        let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
                        Alamofire.request(Constants.API_UPDATE_ACCOUNT_STATUS,
                                          method: .post,
                                          parameters: params,
                                          encoding: JSONEncoding.default,
                       headers : nil).validate().responseJSON { [weak self] response in
                        
                            guard response.result.isSuccess else {
                                self?.backToLoginPageOnNetworkIssue(withMessage: (response.result.error?.localizedDescription)!)
                                return
                            }
                            let payload: [String:Any] = ["AccountNumber": "236834"]
                            let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
                            Alamofire.request(Constants.API_ACCOUNT_DETAILS,
                                          method: .post,
                                          parameters: params,
                                          encoding: JSONEncoding.default,
                                          headers : nil).validate().responseJSON { [weak self] response in
                                            
                                guard response.result.isSuccess else {
                                    self?.backToLoginPageOnNetworkIssue(withMessage: (response.result.error?.localizedDescription)!)
                                    return
                                }
                                KRProgressHUD.dismiss()
                                           
                        }
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
    
    func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell  = collectionView?.cellForItem(at: indexPath) as? CardCollectionViewCell else { return }
        // double swipe Up transition
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController())
        }
        
        let open = sender.direction == .up ? true : false
        if open == false{
            showAddView()
        }else{
            SwiftMessages.hide()
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
            SwiftMessages.hide()
        }else{
            showAddView()
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
            break
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
            SwiftMessages.hide()
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
