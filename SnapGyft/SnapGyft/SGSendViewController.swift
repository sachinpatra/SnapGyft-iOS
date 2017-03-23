//
//  SGSendViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/19/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit


class SGSendViewController: EPContactsPicker {

    private var foregroundNotification: NSObjectProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.multiSelectEnabled = true
        self.contactDelegate = self
        self.subtitleCellValue = SubtitleCellValue.email
        
        self.foregroundNotification = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: OperationQueue.main) {_ in
            self.reloadContacts()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self.foregroundNotification)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onAddBtnClicked(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "ShowAddFriendSegue", sender: self)
    }
    
    
    //MARK: - Segue Delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddFriendSegue"{
            (segue.destination as? SGAddFriendViewController)?.delegate = self
        }
    }
}

//MARK: EPContactsPicker delegates
extension SGSendViewController: EPPickerDelegate{
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError)
    {
        print("Failed with error \(error.description)")
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact : EPContact)
    {
        print("Contact \(contact.displayName()) has been selected")
    }
    
    func epContactPicker(_: EPContactsPicker, didCancel error : NSError)
    {
        print("User canceled the selection");
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
        print("The following contacts are selected")
        for contact in contacts {
            print("\(contact.displayName())")
        }
    }
}

//MARK: - SGAddFriendViewControllerDelegate
extension SGSendViewController: SGAddFriendViewControllerDelegate{
    
    func addContactRefresh(_: SGAddFriendViewController) {
        self.reloadContacts()
    }

}
