//
//  Constants.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 11/24/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import Foundation

class Constants {
    static let API_ISREGISTERED_ACCOUNT = "https://snapgift.azurewebsites.net/api/account/IsRegisteredAccount"
    static let API_UPDATE_ACCOUNT_STATUS = "https://snapgift.azurewebsites.net/api/register/UpdateAccountStatus"
    static let API_ACCOUNT_DETAILS = "https://snapgift.azurewebsites.net/api/account/GetAccountDetails"

}

extension AACoreData {
    // MARK:- Add your entities here
    static let ProfileEntityName = AACoreDataEntity<String>("Profile")
}
