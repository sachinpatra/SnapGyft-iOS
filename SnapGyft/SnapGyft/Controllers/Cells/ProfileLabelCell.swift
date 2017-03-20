//
//  ProfileLabelCell.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

final class ProfileLabelCell: UITableViewCell, InlineDatePickerFormableRow, InlinePickerFormableRow {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .formerColor()
        displayLabel.textColor = .formerSubColor()
    }
    
    func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    func formDisplayLabel() -> UILabel? {
        return displayLabel
    }
    
    func updateWithRowFormer(_ rowFormer: RowFormer) {}
}
