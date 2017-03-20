//
//  Profile.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/19/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

final class Profile {
    
    static let sharedInstance = Profile()
    
    var image: UIImage?
    var name: String?
    var gender: String?
    var birthDay: Date?
    var introduction: String?
    var moreInformation = false
    var nickname: String?
    var location: String?
    var phoneNumber: String?
    var job: String?
    var accountID: String?
}
