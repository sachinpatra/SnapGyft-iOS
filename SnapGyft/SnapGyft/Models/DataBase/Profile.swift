//
//  Profile.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 7/5/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import CoreData

class Profile: NSManagedObject {
    
    class func createProfile(accountID: String, phoneNumber: String, in context: NSManagedObjectContext) -> Profile{
        
        let profile = Profile(context: context)
        profile.accountID = accountID
        profile.phoneNumber = phoneNumber
        
        return profile
    }
}
