//
//  RegisterLabelCell.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/16/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

final class RegisterLabelCell: UITableViewCell, InlineDatePickerFormableRow, InlinePickerFormableRow, SelectorPickerFormableRow, LabelFormableRow {
    
    var selectorPickerView: UIPickerView?
    
    var selectorAccessoryView: UIView?
    

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
    
    //MARK: - LabelFormableRow Delegate
    func formTextLabel() -> UILabel? {
        return titleLabel
    }
    
    func formSubTextLabel() -> UILabel? {
        return displayLabel
    }
}
