//
//  SFCustomIconKit.swift
//  SnapGyft
//
//  Created by Patra, Sachin Kumar (TekSystems) on 3/25/17.
//  Copyright © 2017 Patra, Sachin Kumar (TekSystems). All rights reserved.
//

import UIKit
import CoreText

// MARK: - Public

/// A Octicons extension to UIFont.
public extension UIFont {
    
    /// Get a UIFont object of Octicons.
    ///
    /// - parameter size: The preferred font size.
    /// - returns: A UIFont object of Octicons.
    public class func octicon(of size: CGFloat) -> UIFont {
        let name = "octicons"
        if UIFont.fontNames(forFamilyName: name).isEmpty {
            FontLoader.load(name)
        }
        
        return UIFont(name: name, size: size)!
    }
}

/// A Octicons extension to UIImage.
public extension UIImage {
    
    /// Get a Octicons image with the given icon name, text color, size and an optional background color.
    ///
    /// - parameter name: The preferred icon name.
    /// - parameter textColor: The text color.
    /// - parameter size: The image size.
    /// - parameter backgroundColor: The background color (optional).
    /// - returns: A string that will appear as icon with Octicons
    public static func octicon(with imageString: String, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clear) -> UIImage {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        let fontSize = min(size.width, size.height)
        let attributedString = NSAttributedString(string: imageString, attributes: [NSFontAttributeName: UIFont.octicon(of: fontSize), NSForegroundColorAttributeName: textColor, NSBackgroundColorAttributeName: backgroundColor, NSParagraphStyleAttributeName: paragraph])
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) / 2, width: size.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

// MARK: - Private

private class FontLoader {
    class func load(_ name: String) {
        let bundle = Bundle(for: FontLoader.self)
        let identifier = bundle.bundleIdentifier
        var fontURL: URL
        if identifier?.hasPrefix("org.cocoapods") == true {
            // If this framework is added using CocoaPods, resources is placed under a subdirectory
            fontURL = bundle.url(forResource: name, withExtension: "ttf", subdirectory: "OcticonsKit.bundle")!
        } else {
            fontURL = bundle.url(forResource: name, withExtension: "ttf")!
        }
        
        let data = try! Data(contentsOf: fontURL)
        
        let provider = CGDataProvider(data: data as CFData)
        let font = CGFont(provider!)
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
            let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
            NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
    }
}
