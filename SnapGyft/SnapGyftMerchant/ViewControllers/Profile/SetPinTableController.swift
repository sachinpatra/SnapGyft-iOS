//
//  SetPinTableController.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/30/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class SetPinTableController: UITableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Set Pin"
        
        configureForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Private
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    private func configureForm() {
        let showCurrentPinRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Show Current Pin"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.switchButton.onTintColor = .formerSubColor()
            }.configure {
                $0.switchWhenSelected = true
                
            }.onSwitchChanged { [weak self] in
                self?.switchCurrentPinSection(switchStatus: $0)
        }
        
        
        let enterPinRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Enter Pin"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Please enter new pin"
            }.onTextChanged {_ in
        }
        let reEnterPinRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Re-Enter Pin"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Please Re-Enter new pin"
            }.onTextChanged {_ in
        }
        
        let submitRow = LabelRowFormer<CenterLabelCell>()
            .configure {
                $0.text = "Confirm"
            }.onSelected(onConfirmBtnSelected)
        
        // Create Headers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        // Create SectionFormers
        let section1 = SectionFormer(rowFormer: showCurrentPinRow).set(headerViewFormer: createHeader("Current pin option"))
        let section2 = SectionFormer(rowFormer: enterPinRow, reEnterPinRow).set(headerViewFormer: createHeader("Update Pin"))
        let section3 = SectionFormer(rowFormer: submitRow).set(headerViewFormer: createHeader("    "))
        
        former.append(sectionFormer: section1, section2, section3)
    }
    
   private lazy var createFixedLabel = { (
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
    private lazy var currentPinRow = self.createFixedLabel("Current Pin", "123456")

  
    private func switchCurrentPinSection(switchStatus: Bool){
        if (switchStatus) {
            former.insertUpdate(rowFormer: currentPinRow, toIndexPath: IndexPath.init(row: 0, section: 1), rowAnimation: .top)
        } else {
            former.removeUpdate(rowFormer: currentPinRow, rowAnimation: .top)
        }
    }
    
    private func onConfirmBtnSelected(rowFormer: RowFormer) {
        rowFormer.former?.deselect(animated: true)
    }
}
