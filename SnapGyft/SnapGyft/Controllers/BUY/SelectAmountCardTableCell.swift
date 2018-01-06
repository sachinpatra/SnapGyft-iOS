//
//  SelectAmountCardTableCell.swift
//  SnapGyft
//
//  Created by Sachin Kumar Patra on 1/6/18.
//  Copyright © 2018 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import Shiny

class SelectAmountCardTableCell: UITableViewCell {

    @IBOutlet weak var containerView: ContainerView! {
        didSet {
            containerView.layer.shadowOpacity = 0.6
            containerView.layer.shadowColor = UIColor.gray.cgColor
            containerView.layer.shadowOffset = .zero
            containerView.layer.shadowRadius = 14
            containerView.layer.cornerRadius = 20
            containerView.addParallax()
        }
    }
    @IBOutlet weak var shinyView: ShinyView! {
        didSet {
            shinyView.colors = [UIColor.red, UIColor.orange, UIColor.green, UIColor.blue, UIColor.purple, UIColor.pink, UIColor.gray].map { $0.withAlphaComponent(0.5) }
            shinyView.locations = [0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 1]
            shinyView.startUpdates()
            shinyView.layer.cornerRadius = 20
            shinyView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var imageView1: UIImageView! {
        didSet {
            imageView1.contentMode = .scaleAspectFill
            imageView1.tintColor = .background
        }
    }
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var cardLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
