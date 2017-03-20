//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

public protocol FormableView: class {
    
    func updateWithViewFormer(_ viewFormer: ViewFormer)
}

open class ViewFormer {
    
    // MARK: Public
    
    open var viewHeight: CGFloat = 10
    
    internal init<T: UITableViewHeaderFooterView>(
        viewType: T.Type,
        instantiateType: Former.InstantiateType,
        viewSetup: ((T) -> Void)? = nil) {
            self.viewType = viewType
            self.instantiateType = instantiateType
            self.viewSetup = { viewSetup?(($0 as! T)) }
            initialized()
    }
    
    @discardableResult
    public func dynamicViewHeight(_ handler: @escaping ((UITableView, /*section:*/Int) -> CGFloat)) -> Self {
        dynamicViewHeight = handler
        return self
    }
    
    open func initialized() {}
    
    public func update() {
        if let formableView = viewInstance as? FormableView {
            formableView.updateWithViewFormer(self)
        }
    }
    
    // MARK: Internal
    
    internal final var dynamicViewHeight: ((UITableView, Int) -> CGFloat)?
    
    internal final var viewInstance: UITableViewHeaderFooterView {
        if _viewInstance == nil {
            var view: UITableViewHeaderFooterView?
            switch instantiateType {
            case .Class:
                view = viewType.init(reuseIdentifier: nil)
            case .Nib(nibName: let nibName):
                view = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)!.first as? UITableViewHeaderFooterView
                assert(view != nil, "[Former] Failed to load header footer view from nib (\(nibName)).")
            case .NibBundle(nibName: let nibName, bundle: let bundle):
                view = bundle.loadNibNamed(nibName, owner: nil, options: nil)!.first as? UITableViewHeaderFooterView
                assert(view != nil, "[Former] Failed to load header footer view from nib (nibName: \(nibName)), bundle: (\(bundle)).")
            }
            _viewInstance = view
            viewInstanceInitialized(view!)
            viewSetup(view!)
        }
        return _viewInstance!
    }
    
    internal func viewInstanceInitialized(_ view: UITableViewHeaderFooterView) {}
    
    // MARK: Private
    
    private var _viewInstance: UITableViewHeaderFooterView?
    private final let viewType: UITableViewHeaderFooterView.Type
    private final let instantiateType: Former.InstantiateType
    private final let viewSetup: ((UITableViewHeaderFooterView) -> Void)
}
