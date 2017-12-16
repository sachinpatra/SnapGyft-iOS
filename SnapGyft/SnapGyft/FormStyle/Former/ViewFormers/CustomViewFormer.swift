//
//  CustomViewFormer.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

open class CustomViewFormer<T: UITableViewHeaderFooterView>
: BaseViewFormer<T> {
    
    // MARK: Public
    
    required public init(instantiateType: Former.InstantiateType = .Class, viewSetup: ((T) -> Void)? = nil) {
            super.init(instantiateType: instantiateType, viewSetup: viewSetup)
    }
}
