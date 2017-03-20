//
//  TextSelectorViewContorller.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/17/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit

final class TextSelectorViewContoller: FormViewController {
    
    // MARK: Public
    
    var texts = [String]() {
        didSet {
            reloadForm()
        }
    }
    
    var selectedText: String? {
        didSet {
            former.rowFormers.forEach {
                if let LabelRowFormer = $0 as? LabelRowFormer<FormLabelCell>
                 , LabelRowFormer.text == selectedText {
                    LabelRowFormer.cellUpdate({ $0.accessoryType = .checkmark })
                }
            }
        }
    }
    
    var onSelected: ((String) -> Void)?
    
    private func reloadForm() {
        
        // Create RowFormers
        
        let rowFormers = texts.map { text -> LabelRowFormer<FormLabelCell> in
            return LabelRowFormer<FormLabelCell>() { [weak self] in
                if let sSelf = self {
                    $0.titleLabel.textColor = .formerColor()
                    $0.titleLabel.font = .boldSystemFont(ofSize: 16)
                    $0.tintColor = .formerSubColor()
                    $0.accessoryType = (text == sSelf.selectedText) ? .checkmark : .none
                }
                }.configure {
                    $0.text = text
                }.onSelected { [weak self] _ in
                    self?.onSelected?(text)
                    _ = self?.navigationController?.popViewController(animated: true)
            }
        }
        
        // Create SectionFormers
        
        let sectionFormer = SectionFormer(rowFormers: rowFormers)
        
        former.removeAll().append(sectionFormer: sectionFormer).reload()
    }
}
