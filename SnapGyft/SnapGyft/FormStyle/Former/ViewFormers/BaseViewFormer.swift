//
//  BaseViewFormer.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

open class BaseViewFormer<T: UITableViewHeaderFooterView>
: ViewFormer, ConfigurableForm {
    
    // MARK: Public
    
    public var view: T {
        return viewInstance as! T
    }
    
    required public init(
        instantiateType: Former.InstantiateType = .Class,
        viewSetup: ((T) -> Void)? = nil) {
        super.init(
            viewType: T.self,
            instantiateType: instantiateType,
            viewSetup: viewSetup
            )
    }
    
    public final func viewUpdate(update: ((T) -> Void)) -> Self {
        update(view)
        return self
    }
    
    open func viewInitialized(_ view: T) {}
    
    override func viewInstanceInitialized(_ view: UITableViewHeaderFooterView) {
        viewInitialized(view as! T)
    }
}
