//
//  AuthNavigator.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit.UIViewController

final class AuthNavigator: Navigator {
  enum Destination {
    case auth
  }

  private let presenter = NavigationPresenter()
  weak var baseController: UIViewController?

  init(withBaseController baseVC: UIViewController? = nil) {
    self.baseController = baseVC
  }

  func navigate(to destination: Destination, withCofniguration config: NavigatorConfigurable = NavigatorConfig.initial()) {
    guard let sourceController = baseController else {
      return
    }
    let destinationController = makeViewController(for: destination)
    presenter.navigate(to: destinationController, using: sourceController, withCofniguration: config)
  }

  private func makeViewController(for destination: Destination) -> UIViewController {
    switch destination {
    case .auth:
      return ControllersFactory.authController()
    }
  }

  deinit {
    print("⬅️🗑 deinit AuthNavigator")
  }
}
