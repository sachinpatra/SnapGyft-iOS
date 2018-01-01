//
//  TourViewController.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/14/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import OnboardingKit
import Firebase

class TourViewController: UIViewController {
    
    @IBOutlet weak var onboardingView: OnboardingView!
    private let model = MerchantTourScreenModel()
    @IBOutlet weak var getStartedButton: AwesomeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = Auth.auth().currentUser {
            performSegue(withIdentifier: "ShowHomeSegue", sender: self); return
        }

        //Tour Screen
        onboardingView.dataSource = model
        onboardingView.delegate = model
        model.didShow = { page in
        }
        model.willShow = { page in
            UIView.animate(withDuration: 0.3){
                switch page {
                case 0:
                    self.getStartedButton.backgroundColor = UIColor(red: 220, green: 66, blue: 66)
                case 1:
                    self.getStartedButton.backgroundColor = UIColor(red: 33, green: 184, blue: 252)
                case 2:
                    self.getStartedButton.backgroundColor = UIColor.formerSubColor()
                case 3:
                    self.getStartedButton.backgroundColor = UIColor(red: 38, green: 149, blue: 116)
                case 4:
                    self.getStartedButton.backgroundColor = UIColor(red: 88, green: 72, blue: 154)
                default:
                    break
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func getStartedButtonClicked(_ sender: AwesomeButton) {
            self.performSegue(withIdentifier: "showRegisterSegue", sender: self)
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
