//
//  ProfileTableController.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/17/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class ProfileTableController: UITableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        configureForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Private
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    private func configureForm() {
        
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
        
        let createFixedLabel = { (
            text: String,
            subText: String) -> RowFormer in
            return LabelRowFormer<RegisterLabelCell>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 15)
                }.configure {
                    $0.text = text
                    $0.subText = subText
                }.onSelected { _ in
                    self.former.deselect(animated: true)
            }
        }
        
        // Create Headers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        //Section 1
        let nameRow = createFixedLabel("Name", "Italian Restaurant")
        let emailRow = createFixedLabel("Email", "sachin@italianrestaurant.com")
        let phoneRow = createFixedLabel("Phone", "1234567890")

        //Section 2
        let setUpRow = createMenu("Setup") { [weak self] in
            self?.former.deselect(animated: true)
        }
        
        //Section 3
        let setPinRow = createMenu("Set Pin") { [weak self] in
            self?.performSegue(withIdentifier: "showSetPinSegue", sender: self)
        }
        
        
        // Create SectionFormers
        let section1 = SectionFormer(rowFormer: nameRow, emailRow, phoneRow).set(headerViewFormer: createHeader("    "))
        let section2 = SectionFormer(rowFormer: setUpRow).set(headerViewFormer: createHeader("    "))
        let section3 = SectionFormer(rowFormer: setPinRow).set(headerViewFormer: createHeader("    "))
        
        former.append(sectionFormer: section1, section2, section3)
        
    }
    

}
