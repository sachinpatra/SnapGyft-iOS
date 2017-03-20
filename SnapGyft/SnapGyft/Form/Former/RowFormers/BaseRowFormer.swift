//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

open class BaseRowFormer<T: UITableViewCell>: RowFormer {
    
    // MARK: Public
    
    public var cell: T {
        return cellInstance as! T
    }
    
    required public init(
        instantiateType: Former.InstantiateType = .Class,
        cellSetup: ((T) -> Void)? = nil) {
        super.init(
            cellType: T.self,
            instantiateType: instantiateType,
            cellSetup: cellSetup
            )
    }

    @discardableResult
    public final func cellSetup(_ handler: @escaping ((T) -> Void)) -> Self {
        cellSetup = { handler(($0 as! T)) }
        return self
    }
    
    @discardableResult
    public final func cellUpdate(_ update: ((T) -> Void)) -> Self {
        update(cell)
        return self
    }
    
    open func cellInitialized(_ cell: T) {}
    
    // MARK: Internal
    
    override func cellInstanceInitialized(_ cell: UITableViewCell) {
        cellInitialized(cell as! T)
    }
}
