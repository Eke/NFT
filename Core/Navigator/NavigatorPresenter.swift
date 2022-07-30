//
//  NavigatorPresenter.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit

class NavigationPresenter {
  func navigate(to destination: UIViewController, using sourceController: UIViewController, withCofniguration config: NavigatorConfigurable) {
    switch config.navigationType {
    case .push:
      guard let navVC = sourceController as? UINavigationController else {
        fatalError("NavigationPresenter needs UINavigationController for push operations")
        break
      }
      push(controller: destination, to: navVC, withCofniguration: config)
    case .modal:
      present(controller: destination, in: sourceController, withCofniguration: config)
    }
  }

  private func push(
    controller destinationController: UIViewController,
    to sourceController: UINavigationController,
    withCofniguration config: NavigatorConfigurable
  ) {
    sourceController.pushViewController(destinationController, animated: config.animated)
  }

  private func present(
    controller destinationController: UIViewController,
    in sourceController: UIViewController,
    withCofniguration config: NavigatorConfigurable
  ) {
    if let modalPresentationStyle = config.navigationType.modalPresentationStyle {
      destinationController.modalPresentationStyle = modalPresentationStyle
    }

    sourceController.present(destinationController, animated: config.animated, completion: nil)
  }
}
