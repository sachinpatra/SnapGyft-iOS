//
//  NewPromoTableController.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/29/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import Alertift

enum PromoType {
    case None, Quantity, Amount, EndDate
    func title() -> String {
        switch self {
        case .None: return "Select Promotype"
        case .Quantity: return "Quantity"
        case .Amount: return "Amount"
        case .EndDate: return "End Date"
        }
    }
    static func values() -> [PromoType] {
        return [Quantity, Amount, EndDate]
    }
}

class NewPromoTableController: UITableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Promo"
        
        configureForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Private
    fileprivate lazy var promoImageRow: LabelRowFormer<NewPromoImageTableCell> = {
        LabelRowFormer<NewPromoImageTableCell>(instantiateType: .Nib(nibName: "NewPromoImageTableCell")) {
            $0.iconView.image = UIImage(named: "NewPromo")
            }.configure {
                $0.text = "Promo Image"
                $0.rowHeight = 140
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
                self?.presentImagePicker()
        }
    }()
    
    fileprivate lazy var showAdvertiseRow = SwitchRowFormer<FormSwitchCell>() {
        $0.titleLabel.text = "Show Advertise"
        $0.titleLabel.textColor = .formerColor()
        $0.titleLabel.font = .boldSystemFont(ofSize: 15)
        $0.switchButton.onTintColor = .formerSubColor()
        }.configure {
            $0.switchWhenSelected = true
            
        }.onSwitchChanged { [weak self] in
            self?.switchShowAdertiseSection(switchStatus: $0)
    }
    
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    private func configureForm() {
        //Section 2
        let promoNameRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Promo Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter promo name"
            }.onTextChanged {_ in
        }
        
        let startDateRow = InlineDatePickerRowFormer<RegisterLabelCell>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
             $0.titleLabel.text = "Start Date"
             }.configure {
                    $0.date = Date()
             }.inlineCellSetup {
                    $0.datePicker.datePickerMode = .date
             }.displayTextFromDate {
                    return String.mediumDateNoTime(date: $0)
             }.onDateChanged {_ in
            }
        let endDateRow = InlineDatePickerRowFormer<RegisterLabelCell>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
            $0.titleLabel.text = "End Date"
            }.configure {
                $0.date = Date()
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .date
            }.displayTextFromDate {
                return String.mediumDateNoTime(date: $0)
            }.onDateChanged {_ in
        }
        
        //Section 3
        let promoDetailsRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFont(ofSize: 15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your promo details"
            }.onTextChanged {_ in
        }
        
        //Section 4
        let quantityPromoTypeRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Quantity"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter quantity"
            }.onTextChanged {_ in
        }
        let amountPromoTypeRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Amount"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter amount"
            }.onTextChanged {_ in
        }
       let promoTypeRow = InlinePickerRowFormer<RegisterLabelCell, String>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
            $0.titleLabel.text = "Promo type"
            }.configure {
                let never = PromoType.None
                $0.pickerItems.append(
                    InlinePickerItem(title: never.title(),
                                     displayTitle: NSAttributedString(string: never.title(), attributes: [NSForegroundColorAttributeName: UIColor.lightGray]),
                                     value: never.title())
                )
                $0.pickerItems += PromoType.values().map {
                    InlinePickerItem(title: $0.title(), value: $0.title())
                }
            }.onValueChanged({ (pickerItem) in
                self.former.removeUpdate(rowFormer: quantityPromoTypeRow, rowAnimation: .right)
                self.former.removeUpdate(rowFormer: amountPromoTypeRow, rowAnimation: .right)

                switch pickerItem.title {
                    case PromoType.Quantity.title():
                        self.former.insertUpdate(rowFormer: quantityPromoTypeRow, toIndexPath: IndexPath.init(row: 1, section: 3), rowAnimation: .left)
                    case PromoType.Amount.title():
                        self.former.insertUpdate(rowFormer: amountPromoTypeRow, toIndexPath: IndexPath.init(row: 1, section: 3), rowAnimation: .left)
                    case PromoType.EndDate.title():
                        return
                    default:break
                }
                
            })
        
        let discountRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Discount (%)"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter discount"
            }.onTextChanged {_ in
        }
        
        // Create Headers and Footers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 35
            }
        }
        
        
        // Create SectionFormers
        let section1 = SectionFormer(rowFormer: promoImageRow).set(headerViewFormer: createHeader("Please tap to set promo image"))
        let section2 = SectionFormer(rowFormer: promoNameRow, startDateRow, endDateRow).set(headerViewFormer: createHeader("About Promo"))
        let section3 = SectionFormer(rowFormer: promoDetailsRow).set(headerViewFormer: createHeader("Promo Details"))
        let section4 = SectionFormer(rowFormer: promoTypeRow, discountRow).set(headerViewFormer: createHeader("Promo Type Details"))
        let section5 = SectionFormer(rowFormer: showAdvertiseRow).set(headerViewFormer: createHeader("Confirm to show advertise"))

        
        former.append(sectionFormer: section1, section2, section3, section4, section5)
    }

    private func presentImagePicker() {
        Alertift.actionSheet(message: "Select source type")
            .actions(["Camera", "Photo Galery"])
            .action(.destructive("Cancel"))
            .finally { action, index in
                if action.style == .cancel {
                    return
                }
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = false
                switch (action.title!){
                case "Camera":
                    picker.sourceType = UIImagePickerControllerSourceType.camera
                case "Photo Galery":
                    picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                default:break
                }
                self.present(picker, animated: true, completion: nil)

            }.show()
    }
    
    private func switchShowAdertiseSection(switchStatus: Bool){
        if switchStatus {
            Alertift.alert(title: "Terms & Contition", message: "All copyright, trade marks, design rights, patents and other intellectual property rights (registered and unregistered) in and on BBC Online Services and BBC Content belong to the BBC and/or third parties (which may include you or other users.) The BBC reserves all of its rights in BBC Content and BBC Online Services. Nothing in the Terms grants you a right or license to use any trade mark, design right or copyright owned or controlled by the BBC or any other third party except as expressly provided in the Terms. The BBC reserves all of its rights in BBC Content and BBC Online Services. Nothing in the Terms grants you a right or license to use any trade mark, design right or copyright owned or controlled by the BBC or any other third party except as expressly provided in the Terms.")
                .action(.default("Accept")) { _ in
                    // delete post
                }
                .action(.cancel("Decline")){ _ in
                   let switchCell = self.showAdvertiseRow.cellInstance as! FormSwitchCell
                    switchCell.switchButton.isOn = false
                }
                .show()
        }
    }

}

extension NewPromoTableController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        picker.dismiss(animated: true, completion: nil)
        
        promoImageRow.cellUpdate {
            $0.iconView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
    }
}
