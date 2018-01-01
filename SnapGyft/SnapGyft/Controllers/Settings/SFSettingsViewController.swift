//
//  SFSettingsViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/19/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class SFSettingsViewController: UITableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        former.deselect(animated: true)
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
                $0.titleLabel.font = .boldSystemFont(ofSize: 17)
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
                $0.titleLabel.font = .boldSystemFont(ofSize: 17)
                $0.subTextLabel.textColor = .formerSubColor()
                $0.subTextLabel.font = .boldSystemFont(ofSize: 16)
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
        let redemptionRow = createMenu("Redemptions") { [weak self] in
            self?.performSegue(withIdentifier: "ShowRedemptionListSegue", sender: self)
        }


        //Section 3
        let helpCenterRow = createMenu("Help Center") { [weak self] in
            //self?.navigationController?.pushViewController(DefaultsViewController(), animated: true)
        }
        let feedbackRow = createMenu("FeedBack") { [weak self] in
            //self?.navigationController?.pushViewController(DefaultsViewController(), animated: true)
        }
        let rateUsRow = createMenu("Rate Us") { [weak self] in
            //self?.navigationController?.pushViewController(DefaultsViewController(), animated: true)
        }
        
        
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
        let section2 = SectionFormer(rowFormer: gyftCardBalanceRow, redemptionRow).set(headerViewFormer: createHeader("  "))
        let section3 = SectionFormer(rowFormer: helpCenterRow, feedbackRow, rateUsRow)
            .set(footerViewFormer: createFooter("Copyright © 2017 SnapGyft. All rights reserved."))

        
        former.append(sectionFormer: section1, section2, section3)
    }
    
    private func pushGyftCardBalance() -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                rowFormer.subText = "$0"//For temporary
                self?.performSegue(withIdentifier: "ShowGyftCardBalanceSegue", sender: self)
            }
        }
    }
    
}
