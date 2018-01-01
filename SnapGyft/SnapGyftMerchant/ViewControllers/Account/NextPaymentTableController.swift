//
//  NextPaymentTableController.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/29/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class NextPaymentTableController: UITableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Next Payment"
        
        configureForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Private
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    private func configureForm() {
        
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
        
        //Section 1
        let ammountRow = createFixedLabel("Amount", "$200")
        let dateRow = createFixedLabel("Date", "07/24/2018")
        
        // Create Headers and Footers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 35
            }
        }
        
        // Create SectionFormers
        let section1 = SectionFormer(rowFormer: ammountRow, dateRow).set(headerViewFormer: createHeader("Next payment details"))
        
        former.append(sectionFormer: section1)
        
    }

}
