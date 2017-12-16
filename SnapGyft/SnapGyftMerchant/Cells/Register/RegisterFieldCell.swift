//
//  RegisterFieldCell.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/16/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

final class RegisterFieldCell: UITableViewCell, TextFieldFormableRow {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .formerColor()
        textField.textColor = .formerSubColor()
    }
    
    func formTextField() -> UITextField {
        return textField
    }
    
    func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    func updateWithRowFormer(_ rowFormer: RowFormer) {}

}
