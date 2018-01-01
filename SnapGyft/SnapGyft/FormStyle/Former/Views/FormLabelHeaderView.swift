//
//  FormLabelHeaderView.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

open class FormLabelHeaderView: FormHeaderFooterView, LabelFormableView {
    
    // MARK: Public
    
    public private(set) weak var titleLabel: UILabel!
    
    public func formTitleLabel() -> UILabel {
        return titleLabel
    }
    
    override open func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.textColor = .lightGray
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:[label(>=0)]-5-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "H:|-15-[label]-15-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}
