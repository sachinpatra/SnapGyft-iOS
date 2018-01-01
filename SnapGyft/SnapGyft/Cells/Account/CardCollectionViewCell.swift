//
//  CardCollectionViewCell.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/13/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import expanding_collection

class CardCollectionViewCell: BasePageCollectionCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var customTitle: UILabel!
    @IBOutlet weak var cardValue: UILabel!
    @IBOutlet weak var backsideView: GradientView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        customTitle.layer.shadowRadius = 2
        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
        customTitle.layer.shadowOpacity = 0.2
    }
}

