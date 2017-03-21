//
//  SGAddFriendViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/20/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit


class SGAddFriendViewController: UIViewController {

    let appdelObj: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: SGTextFieldExtender!
    @IBOutlet weak var phoneTextField: SGTextFieldExtender!
    @IBOutlet weak var emailTextField: SGTextFieldExtender!
    @IBOutlet weak var countryBtn: SGButtonExtender!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add a Friend"
        self.navigationItem.setHidesBackButton(true, animated: true)

        nameTextField.padding(width: 5)
        phoneTextField.padding(width: 5)
        emailTextField.padding(width: 5)
        
        //Setting Current Country Default Code
        let locale = Locale.current
        let countryCode = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        let countryData = CallingCodes.filter { $0["code"] == countryCode }
        let dialCode = countryData[0]["dial_code"]!
        self.countryBtn.setTitle("\(dialCode)", for: .normal)

//        NotificationCenter.default.addObserver(self, selector: #selector(SGAddFiendViewController.keyboardWasShown(aNotification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(SGAddFiendViewController.keyboardWillBeHidden(aNotification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate lazy var CallingCodes = { () -> [[String: String]] in
        let resourceBundle = Bundle(for: MICountryPicker.classForCoder())
        guard let path = resourceBundle.path(forResource: "CallingCodes", ofType: "plist") else { return [] }
        return NSArray(contentsOfFile: path) as! [[String: String]]
    }()
    
    @IBAction func CountryCodeBtnClicked(_ sender: Any) {
        let picker = MICountryPicker { (name, code) -> () in
            print(code)
        }
        // Optional: To pick from custom countries list
        // picker.customCountriesCode = ["EG", "US", "AF", "AQ", "AX"]
        picker.delegate = self
        picker.showCallingCodes = true
        // or closure
        picker.didSelectCountryClosure = { name, code in}
        
        self.present(UINavigationController(rootViewController: picker), animated: true, completion: nil)

    }
    
    @IBAction func SaveBtnClicked(_ sender: Any) {
        if  validationCheck() == true {
            let dicDetails = generateAllDetailDic()

        }
    }

    @IBAction func CancelBtnClicked(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func generateAllDetailDic() ->NSDictionary  {
        let arrFullname: [String] = self.nameTextField.text!.trim().components(separatedBy: " ")
        let fullNo = countryBtn.currentTitle! + emailTextField.text!
        let emailId = emailTextField.text!.trim()
        
        let dic: NSDictionary = ["Fullname": arrFullname , "Mobile": fullNo, "EmailID" : emailId]
        return dic
    }
    
    //MARK:- ValidationCheck
    func validationCheck() -> Bool {
        if (nameTextField.text?.trim().isEmpty)! || nameTextField.text?.trim() == nil
        {
            alertShow(strMessage: "Please enter full name")
            return false
        }
        else if (nameTextField.text?.trim().characters.count)! > 0 {
            let arrFullname = nameTextField.text?.trim().components(separatedBy: " ")
            
            if (arrFullname?.count)! < 2 {
                alertShow(strMessage: "Please enter first and last name")
                return false
            }
        }
        
        if (phoneTextField.text?.isEmpty)! || phoneTextField.text == nil
        {
            alertShow(strMessage: "Please enter mobile number")
            return false
        }
        else if (phoneTextField.text?.characters.count)! > 0
        {
            let checkmobile: Bool = appdelObj.mobileNumberValidate(number: phoneTextField.text!)
            if checkmobile == false {
                alertShow(strMessage: "Please enter valid mobile number")
                return false
            }
        }
        
        if (emailTextField.text?.trim().characters.count)! > 0 && emailTextField.text?.trim() != ""
        {
            let isValidEmail: Bool = appdelObj.emailAdrressValidation(strEmail: "\(emailTextField.text!.trim())")
            
            if isValidEmail == true {
                return true
            }
            else{
                alertShow(strMessage: "Please enter valid email")
                return false
            }
        }
        return true
    }

    // MARK: - Keyboard Notification Method
    func keyboardWasShown(aNotification: NSNotification) {
        
        if let userInfo = aNotification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                self.scrollView.contentInset = contentInsets
                self.scrollView.scrollIndicatorInsets = contentInsets
                var aRect: CGRect = self.view.frame
                aRect.size.height -= keyboardSize.height
            } else {
            }
        } else {
            
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden(aNotification: NSNotification) {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            let contentInsets: UIEdgeInsets = .zero
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }, completion: {(finished: Bool) -> Void in
        })
    }
}

//MARK:- UITextField Methods
extension SGAddFriendViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == nameTextField
        {
            if string.isEmpty {
                return true
            }
            
            let regEx = "([a-zA-Z ])"
            let range = string.range(of:regEx, options:.regularExpression)
            if range != nil {
//                let found = string.substring(with: range!)
//                print("found: \(found)") // found: example
            }
            else{
                return false
            }
        }
            
        else if  textField == phoneTextField
        {
            if string.isEmpty {
                return true
            }
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if numberFiltered == "" {
                return false
            }
            else
            {
                let currentString = (textField.text! as NSString)
                    .replacingCharacters(in: range, with: string)
                
                let inteValue :Int? =  Int(currentString)
                
                if inteValue! > 0 {
                    let length = currentString.characters.count
                    if length > 15 {
                        return false
                    }
                }
                else
                {
                    return false
                }
            }
        }
        
        return true
    }
}
extension SGAddFriendViewController: MICountryPickerDelegate {
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String) {
    }
    
    func countryPicker(_ picker: MICountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String){
       // DispatchQueue.main.asyncAfter(deadline: .now()) {

        self.dismiss(animated: true) {
            self.countryBtn.setTitle("\(dialCode)", for: .normal)
        }
    }
}
