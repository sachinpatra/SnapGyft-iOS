//
//  CenterLabelCell.swift
//  Former-Demo
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

final class CenterLabelCell: FormCell, LabelFormableRow {
    
    // MARK: Public
    
    func formTextLabel() -> UILabel? {
        return titleLabel
    }
    
    func formSubTextLabel() -> UILabel? {
        return nil
    }
    
    weak var titleLabel: UILabel!
    
    override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.textColor = .formerSubColor()
        titleLabel.font = .boldSystemFont(ofSize: 19)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let constraints = [
          NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[titleLabel]-0-|",
                options: [],
                metrics: nil,
                views: ["titleLabel": titleLabel]
            ),
            NSLayoutConstraint.constraints(
              withVisualFormat: "H:|-0-[titleLabel]-0-|",
                options: [],
                metrics: nil,
                views: ["titleLabel": titleLabel]
            )
            ].flatMap { $0 }
        contentView.addConstraints(constraints)
    }
}
