//
//  PaymentTableController.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/29/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class PaymentTableController: UITableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Payment"
        
        let cellTableViewHeader = tableView.dequeueReusableCell(withIdentifier: "LifetimePaymentCellIdentifier")
        tableView.tableHeaderView = cellTableViewHeader
        
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
        let historyRow = createMenu("History") { [weak self] in
            self?.performSegue(withIdentifier: "showHistorySegue", sender: self)
        }
        let nextPaymentRow = createSelectorRow("Next Payment", "$200", pushNextPaymentController())
        
        
        // Create SectionFormers
        let section1 = SectionFormer(rowFormer: historyRow, nextPaymentRow)
        
        former.append(sectionFormer: section1)
        
    }
    
    private func pushNextPaymentController() -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                rowFormer.subText = "$0"//For temporary
                self?.performSegue(withIdentifier: "showNextPaymentSegue", sender: self)
            }
        }
    }

}
