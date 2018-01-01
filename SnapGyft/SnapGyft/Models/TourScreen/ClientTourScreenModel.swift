//
//  ClientTourScreenModel.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/7/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import OnboardingKit

class ClientTourScreenModel: NSObject, OnboardingViewDelegate, OnboardingViewDataSource {
    
    public var didShow: ((Int) -> Void)?
    public var willShow: ((Int) -> Void)?
    
    public func numberOfPages() -> Int {
        return 5
    }
    
    public func onboardingView(_ onboardingView: OnboardingView, configurationForPage page: Int) -> OnboardingConfiguration {
        switch page {
            
        case 0:
            return OnboardingConfiguration(
                image: UIImage(named: "PageHeartImage")!,
                itemImage: UIImage(named: "ItemHeartIcon")!,
                pageTitle: "ShareIT",
                pageDescription: "A new kind share to trust! \n\n100% free, because great health should be accessible to all!",
                //backgroundImage: UIImage(named: "BackgroundOrange"),
                backgroundImage: UIImage(named: "BackgroundRed"),
                topBackgroundImage: nil,
                bottomBackgroundImage: UIImage(named: "WavesImage")
            )
            
        case 1:
            return OnboardingConfiguration(
                image: UIImage(named: "PageMetricsImage")!,
                itemImage: UIImage(named: "ItemMetricsIcon")!,
                pageTitle: "Gift Cards",
                pageDescription: "Gift Cards will never be the same! \n\nTrack Gift Card, purchase Gift Card, share Gift Card of your progress!",
                //backgroundImage: UIImage(named: "BackgroundOrange"),
                backgroundImage: UIImage(named: "BackgroundBlue"),
                topBackgroundImage: nil,
                bottomBackgroundImage: UIImage(named: "WavesImage")
            )
            
        case 2:
            return OnboardingConfiguration(
                image: UIImage(named: "PageActivityImage")!,
                itemImage: UIImage(named: "ItemActivityIcon")!,
                pageTitle: "Merchant",
                pageDescription: "View activity collected by your Gift Cards and your other mobile apps! \n\nData has never been more beautiful or easier to understand!",
                backgroundImage: UIImage(named: "BackgroundOrange"),
                topBackgroundImage: nil,
                bottomBackgroundImage: UIImage(named: "WavesImage")
            )
            
        case 3:
            return OnboardingConfiguration(
                image: UIImage(named: "PageNutritionImage")!,
                itemImage: UIImage(named: "ItemNutritionIcon")!,
                pageTitle: "BUY",
                pageDescription: "Nutrition tracking can be difficult! \n\nContinue to use your favorite calorie tracking apps if you want, but check out your results here and make sure your macros are in check!",
                //backgroundImage: UIImage(named: "BackgroundOrange"),
                backgroundImage: UIImage(named: "BackgroundGreen"),
                topBackgroundImage: nil,
                bottomBackgroundImage: UIImage(named: "WavesImage")
            )
            
        case 4:
            return OnboardingConfiguration(
                image: UIImage(named: "PageTimelapseImage")!,
                itemImage: UIImage(named: "ItemTimelapseIcon")!,
                pageTitle: "Profile",
                pageDescription: "Your Profile photos are being put to good use! \n\nThe photoLAPSE feature allows you to view your results over custom time periods!",
                //backgroundImage: UIImage(named: "BackgroundOrange"),
                backgroundImage: UIImage(named: "BackgroundPurple"),
                topBackgroundImage: nil,
                bottomBackgroundImage: UIImage(named: "WavesImage")
            )
            
        default:
            fatalError("Out of range!")
        }
    }
    
    public func onboardingView(_ onboardingView: OnboardingView, configurePageView pageView: PageView, atPage page: Int) {
        pageView.titleLabel.textColor = UIColor.white
        pageView.titleLabel.layer.shadowOpacity = 0.6
        pageView.titleLabel.layer.shadowColor = UIColor.black.cgColor
        pageView.titleLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        pageView.titleLabel.layer.shouldRasterize = true
        pageView.titleLabel.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    public func onboardingView(_ onboardingView: OnboardingView, didSelectPage page: Int) {
        print("Did select pge \(page)")
        didShow?(page)
    }
    
    public func onboardingView(_ onboardingView: OnboardingView, willSelectPage page: Int) {
        print("Will select page \(page)")
        willShow?(page)
    }
}
