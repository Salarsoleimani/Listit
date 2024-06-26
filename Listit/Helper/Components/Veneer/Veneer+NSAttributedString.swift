//
//  AttributeString.swift
//  Veneer
//
//  Created by Wesley Cope on 7/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

public extension NSAttributedString {
  internal class func make(_ string:String, block:((_ make:AttributesTransform) -> Void)) -> NSAttributedString {
    let transformer = AttributesTransform()
    block(transformer)
    
    return NSAttributedString(string: string, attributes: transformer.attributes)
  }
  
  convenience init(string:String, block:((_ make:AttributesTransform) -> Void)) {
    self.init(attributedString: NSAttributedString.make(string, block: block))
  }
}

















