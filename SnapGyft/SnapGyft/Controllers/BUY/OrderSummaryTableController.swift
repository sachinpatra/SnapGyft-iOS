//
//  OrderSummaryTableController.swift
//  SnapGyft
//
//  Created by Sachin Kumar Patra on 1/6/18.
//  Copyright © 2018 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import Alertift

class OrderSummaryTableController: UITableViewController {

    public private(set) lazy var former: Former = Former(tableView: self.tableView)

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func configure() {
        let appStoreRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "App Store & iTunes Gift Card"
                $0.subText = "$25.00"
                $0.cell.formSubTextLabel()?.textColor = UIColor.formerSubColor()
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
        }
        
        let cardBalanceRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "Gyft Cald Balance $10"
                $0.subText = "-$10.00"
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
        }
        
        let paymentRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "Payment Method"
                $0.subText = "Apple Pay"
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
        }
        let promocodeRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "Enter Promo Code"
                $0.subText = ""
                $0.cell.accessoryType = .detailDisclosureButton
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
        }
        
        let buyRow = LabelRowFormer<CenterLabelCell>()
            .configure {
                $0.text = "Buy Now -> $25"
            }.onSelected(onBuyBtnSelected)
        
        // Create Headers and Footers
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.text = text
                    $0.viewHeight = 35
            }
        }
        
        //Sections
        let section1 = SectionFormer(rowFormer: appStoreRow).set(headerViewFormer: createHeader("  "))
        let section2 = SectionFormer(rowFormer: cardBalanceRow).set(headerViewFormer: createHeader("Account Credit"))
        let section3 = SectionFormer(rowFormer: paymentRow, promocodeRow).set(headerViewFormer: createHeader("Payment"))
        let section4 = SectionFormer(rowFormer: buyRow).set(headerViewFormer: createHeader("    "))


        former.append(sectionFormer: section1, section2, section3, section4)

    }
    
    private func onBuyBtnSelected(rowFormer: RowFormer) {
        rowFormer.former?.deselect(animated: true)
        Alertift.alert(title: "SnapGyft", message: "Sucessfully Purcharged").action(.default("OK")){ _ in
            let navController = (self.tabBarController as! SFBaseTabBarViewController).viewControllers![0] as! UINavigationController
            navController.popViewController(animated: false)
            let accountVC = navController.viewControllers[0] as! SFAccountViewController
            accountVC.items.append(("item0", "Italian"))
            accountVC.collectionView?.reloadData()
            self.tabBarController?.selectedIndex = 0

        }.show()
    }
}
