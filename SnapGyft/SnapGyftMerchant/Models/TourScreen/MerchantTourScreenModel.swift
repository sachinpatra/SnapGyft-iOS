//
//  MerchantTourScreenModel.swift
//  SnapGyftMerchant
//
//  Created by Patra, Sachin Kumar (TekSystems) on 12/15/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import OnboardingKit

class MerchantTourScreenModel: NSObject, OnboardingViewDelegate, OnboardingViewDataSource {
    
    public var didShow: ((Int) -> Void)?
    public var willShow: ((Int) -> Void)?
    
    public func numberOfPages() -> Int {
        return 5
    }
    
    public func onboardingView(_ onboardingView: OnboardingView, configurationForPage page: Int) -> OnboardingConfiguration {
        switch page {
            
        case 0:
            return OnboardingConfiguration(
                image: UIImage(named: "PageMetricsImage")!,
                itemImage: UIImage(named: "ItemMetricsIcon")!,
                pageTitle: "Gift Cards",
                pageDescription: "Efficient gift card options without much expenses! \n\nBe part of the gift card business growing exponentially. Get new customers thru gifts",
                //backgroundImage: UIImage(named: "BackgroundOrange"),
                backgroundImage: UIImage(named: "BackgroundBlue"),
                topBackgroundImage: nil,
                bottomBackgroundImage: UIImage(named: "WavesImage")
            )
            
        case 1:
            return OnboardingConfiguration(
                image: UIImage(named: "PageHeartImage")!,
                itemImage: UIImage(named: "ItemHeartIcon")!,
                pageTitle: "Member Base",
                pageDescription: "Have access to huge local members wanting to gift as SnapGyft grows! \n\nLocal members searching for businesses for themselves or friends",
                //backgroundImage: UIImage(named: "BackgroundOrange"),
                backgroundImage: UIImage(named: "BackgroundRed"),
                topBackgroundImage: nil,
                bottomBackgroundImage: UIImage(named: "WavesImage")
            )
            
        case 2:
            return OnboardingConfiguration(
                image: UIImage(named: "PageActivityImage")!,
                itemImage: UIImage(named: "ItemActivityIcon")!,
                pageTitle: "Targeted Promotion",
                pageDescription: "Run targeted promotions using SnapGyfts algorithms!\nSnapGyft will have more information about members and their choices based on history and/or preferences and can show your business ad to the right members",
                backgroundImage: UIImage(named: "BackgroundOrange"),
                topBackgroundImage: nil,
                bottomBackgroundImage: UIImage(named: "WavesImage")
            )
            
        case 3:
            return OnboardingConfiguration(
                image: UIImage(named: "PageNutritionImage")!,
                itemImage: UIImage(named: "ItemNutritionIcon")!,
                pageTitle: "Promotions",
                pageDescription: "Run controlled promotions based on time and amount from your app! \n\nNo need to share all your profits just to have a good promotion and attract customers",
                //backgroundImage: UIImage(named: "BackgroundOrange"),
                backgroundImage: UIImage(named: "BackgroundGreen"),
                topBackgroundImage: nil,
                bottomBackgroundImage: UIImage(named: "WavesImage")
            )
            
        case 4:
            return OnboardingConfiguration(
                image: UIImage(named: "PageTimelapseImage")!,
                itemImage: UIImage(named: "ItemTimelapseIcon")!,
                pageTitle: "Efficiency",
                pageDescription: "Get clear understanding of your payments or transactions! \n\nGet all the details about your payments, transactions, promotion effectiveness in one place in the app",
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
