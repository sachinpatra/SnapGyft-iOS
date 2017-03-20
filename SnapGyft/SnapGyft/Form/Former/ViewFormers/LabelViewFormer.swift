//
//  LabelViewFormer.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

public protocol LabelFormableView: FormableView {
    
    func formTitleLabel() -> UILabel
}

public final class LabelViewFormer<T: UITableViewHeaderFooterView>: BaseViewFormer<T> where T: LabelFormableView {
    
    // MARK: Public
    
    open var text: String?
    
    required public init(instantiateType: Former.InstantiateType = .Class, viewSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, viewSetup: viewSetup)
    }
    
    public override func initialized() {
        super.initialized()
        viewHeight = 30
    }
    
    open override func update() {
        super.update()
        view.formTitleLabel().text = text
    }
}
