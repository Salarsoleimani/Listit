//
//  UIColorExtensions.swift
//  ListHub
//
//  Created by Salar Soleimani on 2020-04-14.
//  Copyright © 2020 BEKSAS. All rights reserved.
//

import UIKit

public extension UIColor {
  /**
   Creates an UIColor from HEX Int in 0x363636"format
   
   - parameter hex: HEX Int in 0x363636 format
   
   - returns: UIColor from HexString
   */
  convenience init(hex: Int) {
    self.init(
      red: (hex >> 16) & 0xFF,
      green: (hex >> 8) & 0xFF,
      blue: hex & 0xFF
    )
  }
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
  }
  convenience init(hexString: String, alpha: CGFloat = 1) {
    var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) { cString.removeFirst() }

    if ((cString.count) != 6) {
      self.init(hexString: "ff0000") // return red color for wrong hex input
      return
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
  }
  static func UITraitCollectionColor(darkModeHex: Int, lightModeHex: Int) -> UIColor {
    let darkModeColor = UIColor(hex: darkModeHex)
    let lightModeColor = UIColor(hex: lightModeHex)
    if #available(iOS 13, *) {
      return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
          /// Return the color for Dark Mode
          return darkModeColor
        } else {
          /// Return the color for Light Mode
          return lightModeColor
        }
      }
    } else {
      /// Return a fallback color for iOS 12 and lower.
      return darkModeColor
    }
  }
  
  static func UITraitCollectionColor(darkModeColor: UIColor, lightModeColor: UIColor) -> UIColor {
    if #available(iOS 13, *) {
      return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
        if UITraitCollection.userInterfaceStyle == .dark {
          /// Return the color for Dark Mode
          return darkModeColor
        } else {
          /// Return the color for Light Mode
          return lightModeColor
        }
      }
    } else {
      /// Return a fallback color for iOS 12 and lower.
      return darkModeColor
    }
  }
}
