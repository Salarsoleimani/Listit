//
//  Attributes.swift
//  Veneer
//
//  Created by Wesley Cope on 7/13/16.
//  Copyright © 2016 Wess Cope. All rights reserved.
//

import Foundation
import UIKit

public enum TextEffectStyle {
    case letterPress
    
    public var attributeName:String {
        switch self {
        case .letterPress:
          return NSAttributedString.TextEffectStyle.letterpressStyle.rawValue
        }
    }
}

public enum TextDirection : Int {
    case horizontal = 0
    case vertical   = 1
}

public enum StringAttribute {
    case font(UIFont)
    case paragraphStyle(NSParagraphStyle)
    case color(UIColor)
    case backgroundColor(UIColor)
    case ligature(Bool)
    case kerning(CGFloat)
    case strikethrough(NSUnderlineStyle)
    case underlineStyle(NSUnderlineStyle)
    case underlineColor(UIColor)
    case strikethroughColor(UIColor)
    case strokeColor(UIColor)
    case strokeWidth(CGFloat)
    case shadow(NSShadow)
    case textEffect(TextEffectStyle)
    case attachment(NSTextAttachment)
    case link(URL)
    case linkString(String)
    case baseLineOffset(CGFloat)
    case obliqueness(CGFloat)
    case expansion(CGFloat)
    case writingDirection([NSWritingDirectionFormatType])
    case direction(TextDirection)
    
    public var map:(String, AnyObject) {
        switch self {
        case .font(let font):
          return (NSAttributedString.Key.font.rawValue, font)
        case .paragraphStyle(let style):
          return (NSAttributedString.Key.paragraphStyle.rawValue, style)
        case .color(let color):
          return (NSAttributedString.Key.foregroundColor.rawValue, color)
        case .backgroundColor(let color):
          return (NSAttributedString.Key.backgroundColor.rawValue, color)
        case .ligature(let ligature):
          return (NSAttributedString.Key.ligature.rawValue, ligature as AnyObject)
        case .kerning(let kerning):
          return (NSAttributedString.Key.kern.rawValue, kerning as AnyObject)
        case .strikethrough(let strikethrough):
          return (NSAttributedString.Key.strikethroughStyle.rawValue, strikethrough.rawValue as AnyObject)
        case .underlineStyle(let underline):
          return (NSAttributedString.Key.underlineStyle.rawValue, underline.rawValue as AnyObject)
        case .strokeColor(let color):
          return (NSAttributedString.Key.strokeColor.rawValue, color)
        case .strokeWidth(let width):
          return (NSAttributedString.Key.strokeWidth.rawValue, width as AnyObject)
        case .shadow(let shadow):
          return (NSAttributedString.Key.shadow.rawValue, shadow)
        case .textEffect(let effect):
          return (NSAttributedString.Key.textEffect.rawValue, effect.attributeName as AnyObject)
        case .attachment(let attachment):
          return (NSAttributedString.Key.attachment.rawValue, attachment)
        case .link(let link):
          return (NSAttributedString.Key.link.rawValue, link as AnyObject)
        case .linkString(let link):
          return (NSAttributedString.Key.link.rawValue, link as AnyObject)
        case .baseLineOffset(let offset):
          return (NSAttributedString.Key.baselineOffset.rawValue, offset as AnyObject)
        case .underlineColor(let color):
          return (NSAttributedString.Key.underlineColor.rawValue, color)
        case .strikethroughColor(let color):
          return (NSAttributedString.Key.strikethroughColor.rawValue, color)
        case .obliqueness(let obliqueness):
          return (NSAttributedString.Key.obliqueness.rawValue, obliqueness as AnyObject)
        case .expansion(let expansion):
          return (NSAttributedString.Key.expansion.rawValue, expansion as AnyObject)
        case .writingDirection(let directions):
          return (NSAttributedString.Key.writingDirection.rawValue, (directions.map{ $0.rawValue } as AnyObject))
        case .direction(let direction):
          return (NSAttributedString.Key.verticalGlyphForm.rawValue, direction.rawValue as AnyObject)
        }
    }
}
