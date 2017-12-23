//
//  CardDetailQRCodeCell.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/23/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

final class CardDetailQRCodeCell: UITableViewCell, LabelFormableRow {
    

    @IBOutlet weak var qrcodeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func formTextLabel() -> UILabel? {
        return nil
    }
    
    func formSubTextLabel() -> UILabel? {
        return nil
    }
    
     func updateWithRowFormer(_ rowFormer: RowFormer) {}
    
}
