//
//  PromoTableController.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/29/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class PromoTableController: UITableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Promo"
        
        configureForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let firstRow = createSelectorRow("Weekend 10% Promo", "03/09/2018", pushWeekEndPromoController())
        let secondRow = createSelectorRow("New dish Ad", "05/27/2018", pushNewDishController())
        let thirdRow = createSelectorRow("Fish Biriyani stak", "06/28/2018", pushFishBiriyaniController())

        
        
        // Create Headers and Footers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 35
            }
        }
        
        
        // Create SectionFormers
        let section1 = SectionFormer(rowFormer: firstRow, secondRow, thirdRow).set(headerViewFormer: createHeader("  "))
        
        former.append(sectionFormer: section1)
        
    }
    
    private func pushWeekEndPromoController() -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                rowFormer.subText = "$0"//For temporary
                self?.performSegue(withIdentifier: "showWeekEndPromoSegue", sender: self)
            }
        }
    }
    private func pushNewDishController() -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                rowFormer.subText = "$0"//For temporary
                self?.performSegue(withIdentifier: "showNewDishSegue", sender: self)
            }
        }
    }
    private func pushFishBiriyaniController() -> (RowFormer) -> Void {
        return { [weak self] rowFormer in
            if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
                rowFormer.subText = "$0"//For temporary
                self?.performSegue(withIdentifier: "showFishBiriyaniSegue", sender: self)
            }
        }
    }

}
