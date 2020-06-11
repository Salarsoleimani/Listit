//
//  Colors.swift
//  New Todo
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 SaSApps. All rights reserved.
//

import Foundation
import UIKit

enum Colors {
  case background
  
  case title
  case main
  
  case error
  
  case walktroughTarget
  case walktroughBackground
  case walktroughText

  case listCellBackground
  case listCellTitle
  case listCellDescription
  
  case white
  
  case custom(hex: Int, alpha: Double)
  case customWithDarkModeString(hexForDarkMode: Int, hexForLightMode: Int, alpha: Double)
  case customWithDarkModeColor(colorForDarkMode: UIColor, colorForLightMode: UIColor, alpha: Double)
  
  func withAlpha(_ alpha: Double) -> UIColor {
    return self.value.withAlphaComponent(CGFloat(alpha))
  }
}

extension Colors {
  
  var value: UIColor {
    var instanceColor = UIColor.clear
    
    switch self {
    // Shared
    case .background:
      instanceColor = UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0x232323), lightModeColor: UIColor(hex: 0xF9F9F9))
      
    // Shared
    case .title:
      instanceColor = UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0xF2F2F2), lightModeColor: UIColor(hex: 0x686868))
    case .main:
      instanceColor = UIColor(hex: 0x02C39A)

      // Walkthrough
    case .walktroughTarget:
      instanceColor =  UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0x444444), lightModeColor: UIColor(hex: 0x989595))
    case .walktroughBackground:
      instanceColor = UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0x232323), lightModeColor: UIColor(hex: 0xF9F9F9))
    case .walktroughText:
      instanceColor = UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0xF2F2F2), lightModeColor: UIColor(hex: 0x686868))
      
    // Lists
    case .listCellBackground:
      instanceColor = UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0x1C1C1E), lightModeColor: UIColor(hex: 0xF5F5F5).withAlphaComponent(0.5))
    case .listCellTitle:
      instanceColor = UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0xDDDDDD), lightModeColor: UIColor(hex: 0x686868))
    case .listCellDescription:
      instanceColor = UIColor(hex: 0x666666)
      
      //
    case .error:
      instanceColor = .red
    case .white:
      instanceColor = .white
    // Custom
    case .custom(let hexString, let opacity):
      instanceColor = UIColor(hex: hexString).withAlphaComponent(CGFloat(opacity))
    case .customWithDarkModeString(let hexStringForDarkMode, let hexStringForLightMode, let opacity):
      instanceColor = UIColor.UITraitCollectionColor(darkModeHex: hexStringForDarkMode, lightModeHex: hexStringForLightMode).withAlphaComponent(CGFloat(opacity))
    case .customWithDarkModeColor(let colorForDarkMode, let colorForLightMode, let opacity):
      UIColor.UITraitCollectionColor(darkModeColor: colorForDarkMode, lightModeColor: colorForLightMode).withAlphaComponent(CGFloat(opacity))
    }
    return instanceColor
  }
}

