//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

open class FormCell: UITableViewCell, FormableRow {
    
    // MARK: Public
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open func updateWithRowFormer(_ rowFormer: RowFormer) {}
    
    open func setup() {
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        textLabel?.backgroundColor = .clear
    }
}
