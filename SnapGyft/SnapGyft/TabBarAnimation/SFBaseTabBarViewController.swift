//
//  SFBaseTabBarViewController.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/17/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//


import UIKit
import MMTabBarAnimation

let kIconSize:CGFloat = 32

class SFBaseTabBarViewController: MMTabBarAnimateController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ((self.tabBar.items?[0])! as UITabBarItem).image =   UIImage.octicon(with: "\u{f018}", textColor: .formerSubColor(), size: CGSize(width: kIconSize, height: kIconSize))
        ((self.tabBar.items?[1])! as UITabBarItem).image =   UIImage.octicon(with: "\u{f042}", textColor: .formerSubColor(), size: CGSize(width: kIconSize, height: kIconSize))
        ((self.tabBar.items?[2])! as UITabBarItem).image =   UIImage.octicon(with: "\u{f02a}", textColor: .formerSubColor(), size: CGSize(width: kIconSize, height: kIconSize))
        ((self.tabBar.items?[3])! as UITabBarItem).image =   UIImage.octicon(with: "\u{f031}", textColor: .formerSubColor(), size: CGSize(width: kIconSize, height: kIconSize))


        // .iconExpand  type dont set select Image or you will not animation //#imageLiteral(resourceName: "icon_tab_home_on")
//        super.setAnimate(index: 0, animate: .iconExpand(image: UIImage(named: "icon_tab_home_on")!), duration: 0.2)
       // super.setAnimate(index: 0, animate: .iconExpand(image: UIImage.octicon(with: "\u{f018}", textColor: .formerSubColor(), size: CGSize(width: kIconSize, height: kIconSize))), duration: 0.2)
        
        
        super.setAnimate(index: 0, animate: .icon(type: .jump))
        super.setAnimate(index: 1, animate: .icon(type: .rotation(type: .left)))
        super.setAnimate(index: 2, animate: .icon(type: .scale(rate: 1.2)))
        super.setAnimate(index: 3, animate: .label(type: .shake))
        
        super.setAllBadgeAnimate(animate: .scale(rate: 1.2))
        
//        super.setBadgeAnimate(index: 0, animate: .jump)
//        super.setBadgeAnimate(index: 1, animate: .rotation(type: .left))
//        super.setBadgeAnimate(index: 2, animate: .scale(rate: 1.2))
        // super.setBadgeAnimate(index: 3, animate: .shake)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
