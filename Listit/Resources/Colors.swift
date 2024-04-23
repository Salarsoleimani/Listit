//
//  Colors.swift
//  Listit
//
//  Created by Salar Soleimani on 2020-06-02.
//  Copyright © 2020 ssmobileapps.com All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum Colors {
  case background
  case secondBackground

  case title
  case main
  case second
  
  case error
  case shadow
  case red
  
  case listCellBackground
  case listCellTitle
  case listCellDescription
  
  case itemCellTitle
  case itemCellDescription
  
  case white
  
  case custom(hex: Int, alpha: Double)
  case customWithDarkModeString(hexForDarkMode: Int, hexForLightMode: Int, alpha: Double)
  case customWithDarkModeColor(colorForDarkMode: UIColor, colorForLightMode: UIColor, alpha: Double)
  
  func withAlpha(_ alpha: Double) -> Color {
    return self.value.opacity(alpha)
  }
}

extension Colors {
  var value: Color {
    var instanceColor = Color(UIColor.clear)
    
    switch self {
      // Shared
    case .background:
      instanceColor = Color(UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0x232323), lightModeColor: UIColor(hex: 0xf0f0f0)))
    case .secondBackground:
      instanceColor =  Color(UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0x353535), lightModeColor: UIColor(hex: 0xDADADA)))
      
    case .title:
      instanceColor = Color(UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0xF2F2F2), lightModeColor: UIColor(hex: 0x686868)))
    case .main:
      instanceColor = Color(UIColor(hex: 0x02C39A))
    case .second:
      instanceColor = Color(UIColor(hex: 0xe76f51))
      
      
      // Lists
    case .listCellBackground:
      instanceColor = Color(UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0x1C1C1E), lightModeColor: UIColor(hex: 0xDDDDDD).withAlphaComponent(0.5)))
    case .listCellTitle:
      instanceColor = Color(UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0xDDDDDD), lightModeColor: UIColor(hex: 0x686868)))
    case .listCellDescription:
      instanceColor = Color(UIColor(hex: 0x666666))
      
      // Items
      
    case .itemCellTitle:
      instanceColor = Color(UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0xDDDDDD), lightModeColor: UIColor(hex: 0x686868)))
    case .itemCellDescription:
      instanceColor = Color(UIColor.secondaryLabel)
      
    //
    case .error:
      instanceColor = Color(UIColor(hex: 0xFF3C30))
    case .shadow:
      instanceColor = Color(UIColor.UITraitCollectionColor(darkModeColor: UIColor(hex: 0xD9D9D9), lightModeColor: UIColor(hex: 0x232323)))
    case .red:
      instanceColor = Color(UIColor(hex: 0xff0800))
      
    case .white:
      instanceColor = .white
      
    // Custom
    case .custom(let hexString, let opacity):
      instanceColor = Color(UIColor(hex: hexString).withAlphaComponent(CGFloat(opacity)))
    case .customWithDarkModeString(let hexStringForDarkMode, let hexStringForLightMode, let opacity):
      instanceColor = Color(UIColor.UITraitCollectionColor(darkModeHex: hexStringForDarkMode, lightModeHex: hexStringForLightMode)).opacity(opacity)
    case .customWithDarkModeColor(let colorForDarkMode, let colorForLightMode, let opacity):
      instanceColor = Color(UIColor.UITraitCollectionColor(darkModeColor: colorForDarkMode, lightModeColor: colorForLightMode)).opacity(opacity)
    }
    return instanceColor
  }
}

