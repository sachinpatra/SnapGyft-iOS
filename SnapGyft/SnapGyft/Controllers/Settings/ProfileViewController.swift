//
//  ProfileViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/19/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {

    // MARK: Public
    public private(set) lazy var former: Former = Former(tableView: self.tableView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        configure()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Private
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)    
    
    private func configure() {
        
        // Create RowFomers
        let nameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your name"
                $0.text = Profile.sharedInstance.name
            }.onTextChanged {
                Profile.sharedInstance.name = $0
        }
        let phoneRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            $0.textField.delegate = self
            }.configure {
                $0.text = Profile.sharedInstance.phoneNumber
            }.onTextChanged {
                Profile.sharedInstance.name = $0
        }

        let genderRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Gender"
            }.configure {
                let genders = ["Male", "Female"]
                $0.pickerItems = genders.map {
                    InlinePickerItem(title: $0)
                }
                if let gender = Profile.sharedInstance.gender {
                    $0.selectedRow = genders.index(of: gender) ?? 0
                }
            }.onValueChanged {
                Profile.sharedInstance.gender = $0.title
        }
        let birthdayRow = InlineDatePickerRowFormer<ProfileLabelCell>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Birthday"
            }.configure {
                $0.date = Profile.sharedInstance.birthDay ?? Date()
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .date
            }.displayTextFromDate {
                return String.mediumDateNoTime(date: $0)
            }.onDateChanged {
                Profile.sharedInstance.birthDay = $0
        }
        let introductionRow = TextViewRowFormer<FormTextViewCell>() { [weak self] in
            $0.textView.textColor = .formerSubColor()
            $0.textView.font = .systemFont(ofSize: 15)
            $0.textView.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your self-introduction"
                $0.text = Profile.sharedInstance.introduction
            }.onTextChanged {
                Profile.sharedInstance.introduction = $0
        }
        let moreRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Add more information ?"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.switchButton.onTintColor = .formerSubColor()
            }.configure {
                $0.switched = Profile.sharedInstance.moreInformation
                $0.switchWhenSelected = true
            }.onSwitchChanged { [weak self] in
                Profile.sharedInstance.moreInformation = $0
                self?.switchInfomationSection()
        }
        
        // Create Headers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        // Create SectionFormers
        let imageSection = SectionFormer(rowFormer: imageRow)
            .set(headerViewFormer: createHeader("Profile Image"))
        let introductionSection = SectionFormer(rowFormer: introductionRow)
            .set(headerViewFormer: createHeader("Introduction"))
        let aboutSection = SectionFormer(rowFormer: nameRow, phoneRow, genderRow, birthdayRow)
            .set(headerViewFormer: createHeader("About"))
        let moreSection = SectionFormer(rowFormer: moreRow)
            .set(headerViewFormer: createHeader("More Infomation"))
        
        former.append(sectionFormer: imageSection, introductionSection, aboutSection, moreSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
        if Profile.sharedInstance.moreInformation {
            former.append(sectionFormer: informationSection)
        }
    }
    
    fileprivate lazy var imageRow: LabelRowFormer<ProfileImageCell> = {
        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
            $0.iconView.image = UIImage(named: "Profile_Demo")
            if let image = Profile.sharedInstance.image{
                $0.iconView.image = image
            }
            }.configure {
                $0.text = "Choose profile image from library"
                $0.rowHeight = 90
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
                self?.presentImagePicker()
        }
    }()
    
    private lazy var informationSection: SectionFormer = {
        let nicknameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Nickname"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your nickname"
                $0.text = Profile.sharedInstance.nickname
            }.onTextChanged {
                Profile.sharedInstance.nickname = $0
        }
        let locationRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Location"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your location"
                $0.text = Profile.sharedInstance.location
            }.onTextChanged {
                Profile.sharedInstance.location = $0
        }
        let jobRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Job"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your job"
                $0.text = Profile.sharedInstance.job
            }.onTextChanged {
                Profile.sharedInstance.job = $0
        }
        return SectionFormer(rowFormer: nicknameRow, locationRow, jobRow)
    }()

    private func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    private func switchInfomationSection() {
        if Profile.sharedInstance.moreInformation {
            former.insertUpdate(sectionFormer: informationSection, toSection: former.numberOfSections, rowAnimation: .top)
        } else {
            former.removeUpdate(sectionFormer: informationSection, rowAnimation: .top)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        picker.dismiss(animated: true, completion: nil)
        Profile.sharedInstance.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageRow.cellUpdate {
            $0.iconView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return false
    }
}
