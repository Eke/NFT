//
//  FeedNavigator.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import UIKit.UIViewController

final class FeedNavigator: Navigator {
  enum Destination {
    case feed
    case details(item: FeedItem)
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
    case .feed:
      return ControllersFactory.feedController()
    case .details(let item):
      return ControllersFactory.feedDetailsController(item: item)
    }
  }

  deinit {
    print("⬅️🗑 deinit FeedNavigator")
  }
}
