//
//  WeekEndPromoTableController.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 1/1/18.
//  Copyright © 2018 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class WeekEndPromoTableController: UITableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weekend 10% Promo"
        
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
        let startDateRow = createFixedLabel("Start Date", "03/09/2018")
        let endDateRow = createFixedLabel("End Date", "03/11/2018")
        let AdSeenByRow = createFixedLabel("Ad seen by", "1000")
        let AdCreatedRow = createFixedLabel("Ad Clicked", "20")
        let giftProcessedRow = createFixedLabel("Transactions", "$100, 2 transactions")

        
        // Create Headers and Footers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 35
            }
        }
        
        // Create SectionFormers
        let section1 = SectionFormer(rowFormer: startDateRow, endDateRow, AdSeenByRow, AdCreatedRow, giftProcessedRow).set(headerViewFormer: createHeader("Weekend promo details"))
        
        former.append(sectionFormer: section1)
    }
    
}
