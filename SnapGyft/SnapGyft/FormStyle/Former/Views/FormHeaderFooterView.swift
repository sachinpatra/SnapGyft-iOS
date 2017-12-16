//
//  FormHeaderFooterView.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

open class FormHeaderFooterView: UITableViewHeaderFooterView, FormableView {
    
    // MARK: Public
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open func updateWithViewFormer(_ viewFormer: ViewFormer) {}
    
    open func setup() {
        contentView.backgroundColor = .groupTableViewBackground
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
