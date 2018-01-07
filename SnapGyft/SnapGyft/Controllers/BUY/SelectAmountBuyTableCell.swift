//
//  SelectAmountBuyTableCell.swift
//  SnapGyft
//
//  Created by Sachin Kumar Patra on 1/7/18.
//  Copyright © 2018 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

class SelectAmountBuyTableCell: UITableViewCell {

    @IBOutlet weak var buyButton: AwesomeButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onStepperChange(_ sender: UIStepper) {
        self.buyButton.setTitle("Buy $"+"\(Int(sender.value))", for: .normal)
    }
    
}
