//
//  NFT+UIFont.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit.UIFont

extension UIFont {
  func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
    let descriptor = fontDescriptor.withSymbolicTraits(traits)
    return UIFont(descriptor: descriptor!, size: 0)
  }

  func bold() -> UIFont {
    return withTraits(traits: .traitBold)
  }

  func italic() -> UIFont {
    return withTraits(traits: .traitItalic)
  }
}
