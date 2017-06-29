//
//  ProfileViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/19/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext? = nil
    var myProfile: Profile?
    var accountKit: AKFAccountKit!
    

    // MARK: Public
    public private(set) lazy var former: Former = Former(tableView: self.tableView)
    let appdelObj: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        
        managedObjectContext = appdelObj.persistentContainer.viewContext
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Profile")
        
        do {
            myProfile = try (managedObjectContext?.fetch(employeesFetch) as! [Profile]).first
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        if myProfile?.phoneNumber == nil
            /*&& accountKit == nil */{
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                self.saveProfile(with: "accountID", value: account?.accountID ?? "")
                
                if account?.phoneNumber?.phoneNumber != nil {
                    self.saveProfile(with: "phonenumber", value: account!.phoneNumber?.stringRepresentation() ?? "")
                }
            }
        }

        
        configure()
    }
    
    func saveProfile(with propertyName: String, value: Any) {
        
        if let _ = myProfile{
            
        }else{
            myProfile = Profile(context: managedObjectContext!)
        }
        
        switch propertyName {
        case "name":
            myProfile?.firstName = value as? String
            break
        case "phone":
            myProfile?.phoneNumber = value as? String
            break
        case "gender":
            myProfile?.gender = value as? String
            break
        case "birthday":
            myProfile?.birthDay = value as? NSDate
            break
        case "introduction":
            myProfile?.introduction = value as? String
            break
        case "moreinfo":
            myProfile?.moreInformation = value as! Bool
            break
        case "nickname":
            myProfile?.nickname = value as? String
            break
        case "location":
            myProfile?.location = value as? String
            break
        case "job":
            myProfile?.job = value as? String
            break
        case "accountID":
            myProfile?.accountID = value as? String
            break
        case "phonenumber":
            myProfile?.phoneNumber = value as? String
            break
        case "imagedata":
            myProfile?.imageData = value as? NSData
            break

        default: break
        }
        
        // Save the context.
        do {
            try managedObjectContext!.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
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
                $0.text = self.myProfile?.firstName
            }.onTextChanged {
                self.saveProfile(with: "name", value: $0)
        }
        let phoneRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            $0.textField.delegate = self
            }.configure {
                $0.text = self.myProfile?.phoneNumber
            }.onTextChanged {
                self.saveProfile(with: "phone", value: $0)

        }

        let genderRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Gender"
            }.configure {
                let genders = ["Male", "Female"]
                $0.pickerItems = genders.map {
                    InlinePickerItem(title: $0)
                }
                if let gender = self.myProfile?.gender {
                    $0.selectedRow = genders.index(of: gender)!
                }
            }.onValueChanged {
                self.saveProfile(with: "gender", value: $0.title)

        }
        let birthdayRow = InlineDatePickerRowFormer<ProfileLabelCell>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Birthday"
            }.configure {
//                $0.date = Profile.sharedInstance.birthDay ?? Date()
                if let date = self.myProfile?.birthDay{
                    $0.date = date as Date
                }
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .date
            }.displayTextFromDate {
                return String.mediumDateNoTime(date: $0)
            }.onDateChanged {
                self.saveProfile(with: "birthday", value: $0)

        }
        let moreRow = SwitchRowFormer<FormSwitchCell>() {
            $0.titleLabel.text = "Add more information ?"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.switchButton.onTintColor = .formerSubColor()
            }.configure {
                if let moreInformation = myProfile?.moreInformation{
                    $0.switched = moreInformation
                }
                $0.switchWhenSelected = true

            }.onSwitchChanged { [weak self] in
                self?.saveProfile(with: "moreinfo", value: $0)
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
        let aboutSection = SectionFormer(rowFormer: nameRow, phoneRow, genderRow, birthdayRow)
            .set(headerViewFormer: createHeader("About"))
        let moreSection = SectionFormer(rowFormer: moreRow)
            .set(headerViewFormer: createHeader("More Infomation"))
        
        former.append(sectionFormer: imageSection, aboutSection, moreSection)
            .onCellSelected { [weak self] _ in
                self?.formerInputAccessoryView.update()
        }
   //     if  (myProfile?.moreInformation)! {
       // if let _ = myProfile?.moreInformation {
        if myProfile?.moreInformation == true{
            former.append(sectionFormer: informationSection)
        }
    }
    
    fileprivate lazy var imageRow: LabelRowFormer<ProfileImageCell> = {
        LabelRowFormer<ProfileImageCell>(instantiateType: .Nib(nibName: "ProfileImageCell")) {
            $0.iconView.image = UIImage(named: "Profile_Demo")
            if let image = self.myProfile?.imageData{
                var imageArray =  UIImage(data: image as Data)
                print("temp")
                $0.iconView.image = UIImage(data: image as Data)
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
                $0.text = self.myProfile?.nickname

            }.onTextChanged {
                self.saveProfile(with: "nickname", value: $0)
        }
        
        let locationRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Location"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add your location"
                $0.text = self.myProfile?.location

            }.onTextChanged {
                self.saveProfile(with: "location", value: $0)
        }

        let createMenu: ((String, (() -> Void)?) -> RowFormer) = { text, onSelected in
            return LabelRowFormer<FormLabelCell>() {
                $0.titleLabel.textColor = .formerColor()
                $0.titleLabel.font = .boldSystemFont(ofSize: 15)
                $0.accessoryType = .disclosureIndicator
                }.configure {
                    $0.text = text
                }.onSelected { _ in
                    onSelected?()
            }
        }
        
        let myCharityRow = createMenu("My Charity") { [weak self] in
            self?.performSegue(withIdentifier: "ShowMyCharitySegue", sender: self)
        }
        
        
        return SectionFormer(rowFormer: nicknameRow, locationRow, myCharityRow)
    }()

   
    
    private func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    private func switchInfomationSection(){
        if (myProfile?.moreInformation)! {
            former.insertUpdate(sectionFormer: informationSection, toSection: former.numberOfSections, rowAnimation: .top)
        } else {
            former.removeUpdate(sectionFormer: informationSection, rowAnimation: .top)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        picker.dismiss(animated: true, completion: nil)
        if let imageData = UIImagePNGRepresentation(info[UIImagePickerControllerOriginalImage] as! UIImage) as NSData?{
            saveProfile(with: "imagedata", value: imageData)
        }
        imageRow.cellUpdate {
            $0.iconView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return false
    }
}
