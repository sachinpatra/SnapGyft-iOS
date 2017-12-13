//
//  CardDetailTableController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/13/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import expanding_collection

class CardDetailTableController: ExpandingTableViewController {
    
    fileprivate var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = Asset.backgroundImage.image
        tableView.backgroundView = UIImageView(image: image1)
        
    }
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleImageViewXConstraint: NSLayoutConstraint!
    
}

// MARK: Actions
extension CardDetailTableController {
    
    @IBAction func backButtonHandler(_ sender: AnyObject) {
        popTransitionAnimation()
    }
}

// MARK: UIScrollViewDelegate
extension CardDetailTableController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //    if scrollView.contentOffset.y < -25 {
        //      // buttonAnimation
        //      let viewControllers: [DemoViewController?] = navigationController?.viewControllers.map { $0 as? DemoViewController } ?? []
        //
        //      for viewController in viewControllers {
        //        if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
        //          rightButton.animationSelected(false)
        //        }
        //      }
        //      popTransitionAnimation()
        //    }
        
        scrollOffsetY = scrollView.contentOffset.y
    }
}

