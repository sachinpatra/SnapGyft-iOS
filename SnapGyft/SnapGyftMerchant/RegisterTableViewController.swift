//
//  RegisterTableViewController.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/16/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import Alertift
import Firebase
import KRProgressHUD
import ReachabilitySwift
import Alamofire
import QRCodeReader

enum PhysicalLcations {
    case None, Single, BelowTen, BelowFifty, AboveFifty
    func title() -> String {
        switch self {
        case .None: return "Number of physical locations"
        case .Single: return "1"
        case .BelowTen: return "2-9"
        case .BelowFifty: return "10-49"
        case .AboveFifty: return "50+"
        }
    }
    static func values() -> [PhysicalLcations] {
        return [Single, BelowTen, BelowFifty, AboveFifty]
    }
}

enum Categories {
    case None, Restaurant, Massage, Photography, Other
    func title() -> String {
        switch self {
        case .None: return "Select business category"
        case .Restaurant: return "Restaurant"
        case .Massage: return "Massage / Spa"
        case .Photography: return "Photography"
        case .Other: return "Other"
        }
    }
    static func values() -> [Categories] {
        return [Restaurant, Massage, Photography, Other]
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
    case None, Alabama, Alaska, Arizona, Arkansas, California, Colorado, Connecticut, Delaware, Florida, Georgia, Hawaii, Idaho, Illinois, Indiana, Iowa, Kansas, Kentucky, Louisiana, Maine, Maryland, Massachusetts, Michigan, Minnesota, Mississippi, Missouri, Montana, Nebraska, Nevada, NewHampshire, NewJersey, NewMexico, NewYork, NorthCarolina, NorthDakota, Ohio, Oklahoma, Oregon, Pennsylvania, RhodeIsland, SouthCarolina, SouthDakota, Tennessee, Texas, Utah, Vermont, Virginia, Washington, WestVirginia, Wisconsin, Wyoming
    func title() -> String {
        switch self {
        case .None: return "Select State"
        case .Alabama: return "Alabama"
        case .Alaska: return "Alaska"
        case .Arizona: return "Arizona"
        case .Arkansas: return "Arkansas"
        case .California: return "California"
        case .Colorado: return "Colorado"
        case .Connecticut: return "Connecticut"
        case .Delaware: return "Delaware"
        case .Florida: return "Florida"
        case .Georgia: return "Georgia"
        case .Hawaii: return "Hawaii"
        case .Idaho: return "Idaho"
        case .Illinois: return "Illinois"
        case .Indiana: return "Indiana"
        case .Iowa: return "Iowa"
        case .Kansas: return "Kansas"
        case .Kentucky: return "Kentucky"
        case .Louisiana: return "Louisiana"
        case .Maine: return "Maine"
        case .Maryland: return "Maryland"
        case .Massachusetts: return "Massachusetts"
        case .Michigan: return "Michigan"
        case .Minnesota: return "Minnesota"
        case .Mississippi: return "Mississippi"
        case .Missouri: return "Missouri"
        case .Montana: return "Montana"
        case .Nebraska: return "Nebraska"
        case .Nevada: return "Nevada"
        case .NewHampshire: return "New Hampshire"
        case .NewJersey: return "New Jersey"
        case .NewMexico: return "New Mexico"
        case .NewYork: return "New York"
        case .NorthCarolina: return "North Carolina"
        case .NorthDakota: return "North Dakota"
        case .Ohio: return "Ohio"
        case .Oklahoma: return "Oklahoma"
        case .Oregon: return "Oregon"
        case .Pennsylvania: return "Pennsylvania"
        case .RhodeIsland: return "Rhode Island"
        case .SouthCarolina: return "South Carolina"
        case .SouthDakota: return "South Dakota"
        case .Tennessee: return "Tennessee"
        case .Texas: return "Texas"
        case .Utah: return "Utah"
        case .Vermont: return "Vermont"
        case .Virginia: return "Virginia"
        case .Washington: return "Washington"
        case .WestVirginia: return "West Virginia"
        case .Wisconsin: return "Wisconsin"
        case .Wyoming: return "Wyoming"
        }
    }
    static func values() -> [States] {
        return [Alabama, Alaska, Arizona, Arkansas, California, Colorado, Connecticut, Delaware, Florida, Georgia, Hawaii, Idaho, Illinois, Indiana, Iowa, Kansas, Kentucky, Louisiana, Maine, Maryland, Massachusetts, Michigan, Minnesota, Mississippi, Missouri, Montana, Nebraska, Nevada, NewHampshire, NewJersey, NewMexico, NewYork, NorthCarolina, NorthDakota, Ohio, Oklahoma, Oregon, Pennsylvania, RhodeIsland, SouthCarolina, SouthDakota, Tennessee, Texas, Utah, Vermont, Virginia, Washington, WestVirginia, Wisconsin, Wyoming]
    }
}

class RegisterTableViewController: UITableViewController, QRCodeReaderViewControllerDelegate {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)
    
    var businessNameRow: TextFieldRowFormer<RegisterFieldCell>!
    var businessPhoneRow: TextFieldRowFormer<RegisterFieldCell>!
    var emailRow: TextFieldRowFormer<RegisterFieldCell>!
    var zipcodeRow: TextFieldRowFormer<RegisterFieldCell>!
    var firstnameRow: TextFieldRowFormer<RegisterFieldCell>!
    var lastnameRow: TextFieldRowFormer<RegisterFieldCell>!
    var physicalLocationRow: InlinePickerRowFormer<RegisterLabelCell, String>!
    var businessCategoryRow: InlinePickerRowFormer<RegisterLabelCell, String>!
    var addressRow: TextFieldRowFormer<RegisterFieldCell>!
    var cityRow: TextFieldRowFormer<RegisterFieldCell>!
    var countryRow: InlinePickerRowFormer<RegisterLabelCell, String>!
    var stateRow: InlinePickerRowFormer<RegisterLabelCell, String>!
    
    var merchantProfile: MerchantProfile!
    let coreData = AACoreData.sharedInstance()
    let reachability = Reachability()!
    
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader          = QRCodeReader.init(captureDevicePosition: .back)
            $0.showTorchButton = true
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    

    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"

        configureForm()
        
        //Set Table Header
        let cellTableViewHeader = tableView.dequeueReusableCell(withIdentifier: "RegisterTableHeaderIdentifier")
        //cellTableViewHeader?.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60)
        tableView.tableHeaderView = cellTableViewHeader

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    //MARK: Custom Methods
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)

    private func configureForm() {
        
        // Tell us about your business
        businessNameRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            $0.textField.keyboardType = .alphabet
            }.configure {
                $0.placeholder = "Business Name"
            }.onTextChanged {_ in
        }
        businessPhoneRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Phone"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            $0.textField.keyboardType = .numberPad
            //$0.textField.delegate = self
            }.configure {
                $0.placeholder = "Business Phone, e.g 9742783454"
            }.onTextChanged {_ in
        }
        emailRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Email"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            $0.textField.keyboardType = .emailAddress
            }.configure {
                $0.placeholder = "Business Email"
            }.onTextChanged {_ in
        }
        zipcodeRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Zipcode"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            $0.textField.keyboardType = .numberPad
            }.configure {
                $0.placeholder = "Business Zipcode"
            }.onTextChanged {_ in
        }
        firstnameRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "First Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your first name"
            }.onTextChanged {_ in
        }
        lastnameRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Last Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your last name"
            }.onTextChanged {_ in
        }
        
        
        //Category
        physicalLocationRow = InlinePickerRowFormer<RegisterLabelCell, String>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
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
        businessCategoryRow = InlinePickerRowFormer<RegisterLabelCell, String>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
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
            }.onValueChanged({ (pickerItem) in
                if pickerItem.title == "Other" {
                    Alertift.alert(title: "New Category", message: "Input your category name")
                        .textField { textField in
                            textField.placeholder = "Category Name"
                        }
                        .action(.default("OK")) {_, _, textFields in
                            if let otherCategoryName = textFields?.first?.text {
                                self.businessCategoryRow.cell.displayLabel.text = otherCategoryName
                            }else{
                                
                            }
                    }.show()
                }
            })

        
        //Little More in business
        addressRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "Address"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your business address"
            }.onTextChanged {_ in
        }
        cityRow = TextFieldRowFormer<RegisterFieldCell>(instantiateType: .Nib(nibName: "RegisterFieldCell")) { [weak self] in
            $0.titleLabel.text = "City"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Enter your city"
            }.onTextChanged {_ in
        }
        countryRow = InlinePickerRowFormer<RegisterLabelCell, String>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
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
        stateRow = InlinePickerRowFormer<RegisterLabelCell, String>(instantiateType: .Nib(nibName: "RegisterLabelCell")) {
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
            }.onSelected(onSubmitBtnSelected)
        
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
        let aboutSection = SectionFormer(rowFormer: businessNameRow, businessPhoneRow, emailRow, zipcodeRow, firstnameRow, lastnameRow)
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
    
    //MARK: - Button Actions
    private func onSubmitBtnSelected(rowFormer: RowFormer) {
        rowFormer.former?.deselect(animated: true)
        
        //Validation
        guard let businessName = businessNameRow.text else {
            Alertift.alert(title: "SnapGyft", message: "Business name can not be blank.").action(.default("OK")).show(); return }
        guard let _ = businessPhoneRow.text else {
            Alertift.alert(title: "SnapGyft", message: "Business phone can not be blank.").action(.default("OK")).show(); return }
        guard let phoneNumber = businessPhoneRow.text, phoneNumber.isValidPhoneNumber else {
            Alertift.alert(title: "SnapGyft", message: "Please enter valid 10 digit number.").action(.default("OK")).show(); return }
        guard let _ = emailRow.text else {
            Alertift.alert(title: "SnapGyft", message: "Business email can not be blank.").action(.default("OK")).show(); return }
        guard let emailID = emailRow.text, emailID.isValidEmail else {
            Alertift.alert(title: "SnapGyft", message: "Please enter valid Email Id.").action(.default("OK")).show(); return }
        guard let zipcode = zipcodeRow.text else {
            Alertift.alert(title: "SnapGyft", message: "Business zipcode can not be blank.").action(.default("OK")).show(); return }
        guard let firstname = firstnameRow.text else {
            Alertift.alert(title: "SnapGyft", message: "Firstname can not be blank.").action(.default("OK")).show(); return }
        guard let lastname = lastnameRow.text else {
            Alertift.alert(title: "SnapGyft", message: "Lastname can not be blank.").action(.default("OK")).show(); return }
        
        if physicalLocationRow.selectedRow == 0 {
            Alertift.alert(title: "SnapGyft", message: "Please select physical location.").action(.default("OK")).show(); return }
        if businessCategoryRow.selectedRow == 0 {
            Alertift.alert(title: "SnapGyft", message: "Please selcect category.").action(.default("OK")).show(); return }
        
        guard let address = addressRow.text else {
            Alertift.alert(title: "SnapGyft", message: "Business address can not be blank.").action(.default("OK")).show(); return }
        guard let city = cityRow.text else {
            Alertift.alert(title: "SnapGyft", message: "Business city can not be blank.").action(.default("OK")).show(); return }
        if countryRow.selectedRow == 0 {
            Alertift.alert(title: "SnapGyft", message: "Please select country.").action(.default("OK")).show(); return }
        if stateRow.selectedRow == 0 {
            Alertift.alert(title: "SnapGyft", message: "Please select state.").action(.default("OK")).show(); return }
        
        //Save in Database
        merchantProfile = coreData.getNewObject(entityName: .MerchantProfileEntityName) as! MerchantProfile
        merchantProfile.businessName = businessName
        merchantProfile.phoneNumber = phoneNumber
        merchantProfile.emailID = emailID
        merchantProfile.zipcode = zipcode
        merchantProfile.firstName = firstname
        merchantProfile.lastName = lastname
        merchantProfile.numberOfLocations = PhysicalLcations.values()[physicalLocationRow.selectedRow - 1].title()
        merchantProfile.category = Categories.values()[businessCategoryRow.selectedRow - 1].title()
        merchantProfile.address = address
        merchantProfile.city = city
        merchantProfile.country = Countries.values()[countryRow.selectedRow - 1].title()
        merchantProfile.state = States.values()[stateRow.selectedRow - 1].title()
        coreData.saveContext()
        
        firebaseAuthentication()
        
    }
    
    func firebaseAuthentication(){
        
        guard (self.reachability.isReachable) else {
            SGUtility.showAlert(withMessage: "Check Network Connection."); return
        }
        
        //Phone Authentication
        KRProgressHUD.show(withMessage: nil) {
            PhoneAuthProvider.provider().verifyPhoneNumber("+91"+self.businessPhoneRow.text!, uiDelegate: nil) { (verificationID, error) in
                KRProgressHUD.dismiss({
                    if let error = error {
                        SGUtility.showAlert(withMessage: error.localizedDescription); return
                    }
                    //Enter verificaton code alert
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        guard let verificationID = verificationID else { return }
                        Alertift.alert(title: "Verification", message: "Input your verification code")
                            .textField { textField in
                                textField.keyboardType = .numberPad
                                textField.placeholder = "6 digits code"
                            }
                            .action(.cancel("Cancel"))
                            .action(.default("Verify")) { _, _, textFields in
                                if let verificationCode = textFields?.first?.text {
                                    KRProgressHUD.show()
                                    let credential = PhoneAuthProvider.provider().credential(
                                        withVerificationID: verificationID,
                                        verificationCode: verificationCode)
                                    //Do SignIn with verification code
                                    Auth.auth().signIn(with: credential) { (user, error) in
                                        if let error = error {
                                            SGUtility.showAlert(withMessage: error.localizedDescription); return
                                        }
                                        //Update Email-ID
                                        Auth.auth().currentUser?.updateEmail(to: self.emailRow.text!) { (error) in
                                            if let error = error {
                                                SGUtility.showAlert(withMessage: error.localizedDescription); return
                                            }
                                            
                                            //Register Merchant for local server
                                           // self.registerMerchant()
                                            KRProgressHUD.dismiss({
                                                self.performSegue(withIdentifier: "ShowHomeSegue", sender: self)
                                            })

                                        }
                                    }
                                } else {
                                    SGUtility.showAlert(withMessage: "verification code can't be empty"); return
                                }
                            }
                            .show()
                    }
                })
            }
        }
    }
    
    func registerMerchant() {
        let payload: [String:String] = ["BusinessName": merchantProfile.businessName!,
                                     "BusinessPhone": merchantProfile.phoneNumber!,
                                     "BusinessEmail": merchantProfile.emailID!,
                                     "FirstName": merchantProfile.firstName!,
                                     "LastName": merchantProfile.lastName!,
                                     "Category": merchantProfile.category!,
                                     "SubCategory": merchantProfile.numberOfLocations!]
        let params: [String : Any] = ["Header": SGUtility.keyParamsForService, "Payload": payload]
        Alamofire.request(Constants.API_MERCHANT_REGISTER,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default,
                          headers : nil).validate().responseJSON { [weak self] response in

                            guard response.result.isSuccess else {
                                SGUtility.showAlert(withMessage: (response.result.error?.localizedDescription)!)
                                //TODO: SignOut FIrebase
                                return
                            }
                            guard let _ = response.result.value as? [String: Any] else {
                                return
                            }
                            
                            KRProgressHUD.dismiss({
                                self?.performSegue(withIdentifier: "ShowHomeSegue", sender: self)
                            })
                            
        }
    }
    
    
    
    @IBAction func onRedeemBtnClicked(_ sender: AwesomeButton) {
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        present(readerVC, animated: true, completion: nil)
    }
    
    //MARK: - QRCodeReader Delegate
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true) { _ in
            //let decodedString = result.value.base64Decoded()
            Alertift.alert(title: "SnapGyft", message: "Scaned Value = \(result.value)").action(.cancel("OK")).show()
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    
}



//MARK: Extentions
extension RegisterTableViewController: UITextFieldDelegate{
    
//    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
//        return false
//    }
}
