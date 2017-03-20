//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems).
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    // For SelectorRow
    
    override open var inputView: UIView? {
        if let pickerRow = self as? SelectorPickerFormableRow {
            return pickerRow.selectorPickerView
        } else if let datePickerRow = self as? SelectorDatePickerFormableRow {
            return datePickerRow.selectorDatePicker
        }
        return super.inputView
    }
    
    override open var inputAccessoryView: UIView? {
        if let pickerRow = self as? SelectorPickerFormableRow {
            return pickerRow.selectorAccessoryView
        } else if let datePickerRow = self as? SelectorDatePickerFormableRow {
            return datePickerRow.selectorAccessoryView
        }
        return super.inputAccessoryView
    }

    override open var canBecomeFirstResponder: Bool {
        if self is SelectorPickerFormableRow ||
            self is SelectorDatePickerFormableRow {
                return true
        }        
        return super.canBecomeFirstResponder
    }
}
