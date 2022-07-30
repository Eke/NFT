//
//  NavigatorConfig.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit

enum NavigatorNavigationType: Equatable {
  case push
  case modal(style: UIModalPresentationStyle = .automatic)

  var modalPresentationStyle: UIModalPresentationStyle? {
    switch self {
    case .modal(let style):
      return style
    default:
      return nil
    }
  }
}

protocol NavigatorConfigurable {
  var animated: Bool { get }
  var navigationType: NavigatorNavigationType { get }
  var wrapInNavigationController: Bool { get }
}

struct NavigatorConfig: NavigatorConfigurable {
  let animated: Bool
  let navigationType: NavigatorNavigationType
  let wrapInNavigationController: Bool

  init(
    isAnimated: Bool = true,
    navigationType navType: NavigatorNavigationType = .push,
    wrapInNavigationController wrapInNavController: Bool = false
  ) {
    animated = isAnimated
    navigationType = navType
    wrapInNavigationController = wrapInNavController
  }

  static func initial() -> NavigatorConfig {
    return NavigatorConfig(isAnimated: true, navigationType: .push)
  }
}
