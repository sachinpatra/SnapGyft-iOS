//
//  Constants.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 11/24/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import Foundation

class Constants {
    static let API_ISREGISTERED_ACCOUNT = "https://snapgift.azurewebsites.net/api/account/IsRegisteredAccount"
    static let API_UPDATE_ACCOUNT_STATUS = "https://snapgift.azurewebsites.net/api/register/UpdateAccountStatus"
    static let API_ACCOUNT_DETAILS = "https://snapgift.azurewebsites.net/api/account/GetAccountDetails"
    static let API_MERCHANT_REGISTER = "https://snapgiftapi-staging.azurewebsites.net/api/merchant/register"
    
}

extension AACoreData {
    // MARK:- Add your entities here
    static let ProfileEntityName = AACoreDataEntity<String>("Profile")
    static let MerchantProfileEntityName = AACoreDataEntity<String>("MerchantProfile")

}

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit.UIImage
    typealias Image = UIImage
#elseif os(OSX)
    import AppKit.NSImage
    typealias Image = NSImage
#endif

enum Asset: String {
    case backgroundImage = "BackgroundImage"
    case closeButton = "CloseButton"
    case dots = "dots"
    case face1 = "face1"
    case face2 = "face2"
    case heand = "heand"
    case icons = "icons"
    case image = "image"
    case item0 = "item0"
    case item1 = "item1"
    case item2 = "item2"
    case item3 = "item3"
    case locationButton = "locationButton"
    case map = "map"
    case pinIcon = "pinIcon"
    case searchIcon = "searchIcon"
    case stars = "stars"
    case title = "Title"
    
    var image: Image {
        let bundle = Bundle(for: BundleToken.self)
        #if os(iOS) || os(tvOS) || os(watchOS)
            let image = Image(named: rawValue, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            let image = bundle.image(forResource: rawValue)
        #endif
        guard let result = image else { fatalError("Unable to load image \(rawValue).") }
        return result
    }
}

extension Image {
    convenience init!(asset: Asset) {
        #if os(iOS) || os(tvOS) || os(watchOS)
            let bundle = Bundle(for: BundleToken.self)
            self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            self.init(named: asset.rawValue)
        #endif
    }
}

private final class BundleToken {}


extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
