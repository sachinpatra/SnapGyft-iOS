//
//  SFSettingsViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/19/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class SFSettingsViewController: UITableViewController {

    var accountKit: AKFAccountKit!

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()
        if accountKit == nil {
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                Profile.sharedInstance.accountID = account?.accountID
                if account?.phoneNumber?.phoneNumber != nil {
                    Profile.sharedInstance.phoneNumber = account!.phoneNumber?.stringRepresentation()
                }
            }
        }

        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        former.deselect(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: Private
    
    private func configure() {
//        let logo = UIImage(named: "header_logo")!
//        navigationItem.titleView = UIImageView(image: logo)
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        
        // Create RowFormers
        
        let createMenu: ((String, (() -> Void)?) -> RowFormer) = { text, onSelected in
            return LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 18)
                $0.accessoryType = .disclosureIndicator
                }.configure {
                    $0.text = text
                }.onSelected { _ in
                    onSelected?()
            }
        }
        
        let createSelectorRow = { (
            text: String,
            subText: String,
            onSelected: ((RowFormer) -> Void)?) -> RowFormer in
            return LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 18)
                $0.subTextLabel.textColor = .formerSubColor()
                $0.subTextLabel.font = .boldSystemFont(ofSize: 17)
                $0.accessoryType = .disclosureIndicator
                }.configure { form in
                    _ = onSelected.map { form.onSelected($0) }
                    form.text = text
                    form.subText = subText
            }
        }

        //Section 1
        let profileRow = createMenu("Profile") { [weak self] in
            self?.performSegue(withIdentifier: "ShowProfileSegue", sender: self)
        }
        
        //Section 2
        let gyftCardBalanceRow = createSelectorRow("Gyft Card Balance", "$23", pushGyftCardBalance())
        let rewardPointsRow = createSelectorRow("Reward Points", "0 pts", pushRewardPoints())

        let defaultRow = createMenu("All Defaults") { [weak self] in
            self?.navigationController?.pushViewController(DefaultsViewController(), animated: true)
        }
        
        let disableRow = LabelRowFormer<CenterLabelCell>()
            .configure {
                $0.text = "LogOut"
            }.onSelected(disableRowSelected)
        
        // Create Headers and Footers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 35
            }
        }
        
        let createFooter: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelFooterView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 100
            }
        }
        
        // Create SectionFormers
        
        let section1 = SectionFormer(rowFormer: profileRow).set(headerViewFormer: createHeader("  "))
        let section2 = SectionFormer(rowFormer: gyftCardBalanceRow, rewardPointsRow).set(headerViewFormer: createHeader("  "))

        let defaultSection = SectionFormer(rowFormer: defaultRow)
        let signOutSection = SectionFormer(rowFormer: disableRow)
            .set(footerViewFormer: createFooter("Copyright © 2017 SnapGyft. All rights reserved."))

        
        former.append(sectionFormer: section1, section2, defaultSection, signOutSection)
    }
    
    private func pushGyftCardBalance() -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                rowFormer.subText = "$0"//For temporary
                self?.performSegue(withIdentifier: "ShowGyftCardBalanceSegue", sender: self)
            }
        }
    }
    
    private func pushRewardPoints() -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                rowFormer.subText = "$0"//For temporary
                self?.performSegue(withIdentifier: "ShowRewardPointsSegue", sender: self)
            }
        }
    }
    
    private func disableRowSelected(rowFormer: RowFormer) {
        let alertController = UIAlertController(title: "SnapGyft", message: "Are you sure! Do you want to logout?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes", style: .default) { (action: UIAlertAction) in
            self.accountKit.logOut()
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "ShowLoginSegue", sender: self)
            })
        })
        present(alertController, animated: true, completion: nil)
        former.deselect(animated: true)
      
    }
}
