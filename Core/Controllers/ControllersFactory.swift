//
//  ControllersFactory.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit.UIViewController

final class ControllersFactory {
  static func mainController() -> MainController {
    let viewModel = MainViewModel()
    return MainController(withViewModel: viewModel)
  }

  static func authController() -> AuthController {
    let viewModel = AuthViewModel()
    return AuthController(withViewModel: viewModel)
  }

  static func registrationController() -> RegistrationController {
    let viewModel = RegistrationViewModel()
    return RegistrationController(withViewModel: viewModel)
  }

  static func currentUserController() -> CurrentUserController {
    let viewModel = CurrentUserViewModel()
    return CurrentUserController(withViewModel: viewModel)
  }

  static func feedController() -> FeedController {
    let viewModel = FeedViewModel()
    return FeedController(withViewModel: viewModel)
  }

  static func feedDetailsController(item: FeedItem) -> FeedDetailsController {
    let viewModel = FeedDetailsViewModel(withItem: item)
    return FeedDetailsController(withViewModel: viewModel)
  }
}
