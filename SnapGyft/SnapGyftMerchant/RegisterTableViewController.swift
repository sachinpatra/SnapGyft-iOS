//
//  RegisterTableViewController.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/16/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

enum PhysicalLcations {
    case None, Customers, Single, BelowTen, BelowFifty, AboveFifty
    func title() -> String {
        switch self {
        case .None: return "Number of physical locations"
        case .Customers: return "I travel to my customers"
        case .Single: return "1"
        case .BelowTen: return "2-9"
        case .BelowFifty: return "10-49"
        case .AboveFifty: return "50+"
        }
    }
    static func values() -> [PhysicalLcations] {
        return [Customers, Single, BelowTen, BelowFifty, AboveFifty]
    }
}

enum Categories {
    case None, Restaurant, Hotel, Massage, Photography
    func title() -> String {
        switch self {
        case .None: return "Select business category"
        case .Restaurant: return "Restaurant"
        case .Hotel: return "Hotel"
        case .Massage: return "Massage"
        case .Photography: return "Photography"
        }
    }
    static func values() -> [Categories] {
        return [Restaurant, Hotel, Massage, Photography]
    }
}

enum Countries {
    case None, Unitedstates
    func title() -> String {
        switch self {
        case .None: return "Select Country"
        case .Unitedstates: return "United States"
        }
    }
    static func values() -> [Countries] {
        return [Unitedstates]
    }
}

enum States {
    case None, Alabama, Alaska, Arizona, California
    func title() -> String {
        switch self {
        case .None: return "Select State"
        case .Alabama: return "Alabama"
        case .Alaska: return "Alaska"
        case .Arizona: return "Arizona"
        case .California: return "California"
        }
    }
    static func values() -> [States] {
        return [Alabama, Alaska, Arizona, California]
    }
}

class RegisterTableViewController: UITableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"

        configureForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)

    private func configureForm() {
        
        // Tell us about your business
        let nameRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Business Name"
                //$0.text = self.myProfile?.firstName
            }.onTextChanged {_ in
                //self.saveProfile(with: "name", value: $0)
        }
        let phoneRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            //$0.textField.delegate = self
            }.configure {
                $0.placeholder = "Business Phone, e.g 9742783454"
            }.onTextChanged {_ in
        }
        let emailRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Email"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Business Email"
            }.onTextChanged {_ in
        }
        let zipcodeRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Zipcode"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Business Zipcode"
            }.onTextChanged {_ in
        }
        let firstnameRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "First Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your first name"
            }.onTextChanged {_ in
        }
        let lastnameRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Last Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your last name"
            }.onTextChanged {_ in
        }
        
        
        //Category
        let physicalLocationRow = InlinePickerRowFormer<RegisterLabelCell, String>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
            $0.titleLabel.text = "Locations"
            }.configure {
                let never = PhysicalLcations.None
                $0.pickerItems.append(
                    InlinePickerItem(title: never.title(),
                                     displayTitle: NSAttributedString(string: never.title(), attributes: [NSForegroundColorAttributeName: UIColor.lightGray]),
                                     value: never.title())
                )
                $0.pickerItems += PhysicalLcations.values().map {
                    InlinePickerItem(title: $0.title(), value: $0.title())
                }
            }.onValueChanged {_ in
        }
        let businessCategoryRow = InlinePickerRowFormer<RegisterLabelCell, String>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
            $0.titleLabel.text = "Categories"
            }.configure {
                let never = Categories.None
                $0.pickerItems.append(
                    InlinePickerItem(title: never.title(),
                                     displayTitle: NSAttributedString(string: never.title(), attributes: [NSForegroundColorAttributeName: UIColor.lightGray]),
                                     value: never.title())
                )
                $0.pickerItems += Categories.values().map {
                    InlinePickerItem(title: $0.title(), value: $0.title())
                }
            }.onValueChanged {_ in
        }
        
        
        //Little More in business
        let addressRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Address"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your business address"
            }.onTextChanged {_ in
        }
        let cityRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "City"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your city"
            }.onTextChanged {_ in
        }
        let countryRow = InlinePickerRowFormer<RegisterLabelCell, String>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
            $0.titleLabel.text = "Country"
            }.configure {
                let never = Countries.None
                $0.pickerItems.append(
                    InlinePickerItem(title: never.title(),
                                     displayTitle: NSAttributedString(string: never.title(), attributes: [NSForegroundColorAttributeName: UIColor.lightGray]),
                                     value: never.title())
                )
                $0.pickerItems += Countries.values().map {
                    InlinePickerItem(title: $0.title(), value: $0.title())
                }
            }.onValueChanged {_ in
        }
        let stateRow = InlinePickerRowFormer<RegisterLabelCell, String>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
            $0.titleLabel.text = "State"
            }.configure {
                let never = States.None
                $0.pickerItems.append(
                    InlinePickerItem(title: never.title(),
                                     displayTitle: NSAttributedString(string: never.title(), attributes: [NSForegroundColorAttributeName: UIColor.lightGray]),
                                     value: never.title())
                )
                $0.pickerItems += States.values().map {
                    InlinePickerItem(title: $0.title(), value: $0.title())
                }
            }.onValueChanged {_ in
        }
        
        //Register
        let submitRow = LabelRowFormer<CenterLabelCell>()
            .configure {
                $0.text = "Submit"
            }.onSelected { [weak self] _ in
                self?.performSegue(withIdentifier: "ShowHomeSegue", sender: self)
        }
        
        // Create Headers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        let createSpaceHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>() {
                $0.contentView.backgroundColor = .clear
                }.configure {
                    $0.viewHeight = 30
            }
        }
        
        // Create SectionFormers
        let aboutSection = SectionFormer(rowFormer: nameRow, phoneRow, emailRow, zipcodeRow, firstnameRow, lastnameRow)
            .set(headerViewFormer: createHeader("Tell us about your business"))
        let categorySection = SectionFormer(rowFormer: physicalLocationRow, businessCategoryRow)
            .set(headerViewFormer: createHeader("Physical Locations & Business Category"))
        let littleMoreBusinessSection = SectionFormer(rowFormer: addressRow, cityRow, countryRow, stateRow)
            .set(headerViewFormer: createHeader("Tell us a little bit more about your business"))
        let registerSection = SectionFormer(rowFormer: submitRow)
            .set(headerViewFormer: createSpaceHeader())

        former.append(sectionFormer: aboutSection, categorySection, littleMoreBusinessSection, registerSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
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

extension RegisterTableViewController: UITextFieldDelegate{
    
//    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
//        return false
//    }
}
