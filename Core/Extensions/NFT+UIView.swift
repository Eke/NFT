//
//  NFT+UIView.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit.UIView

public extension CACornerMask {
  static var allCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
}

extension UIView {
  func makeRoundedCorners(_ corners: CACornerMask, withRadius radius: CGFloat = 8.0) {
    clipsToBounds = true
    layer.cornerRadius = radius
    layer.maskedCorners = corners
  }

  func makePillCorners() {
    let radius = bounds.size.height > bounds.size.width
    ? bounds.size.width / 2.0
    : bounds.size.height / 2.0
    makeRoundedCorners(.allCorners, withRadius: radius)
  }
}
