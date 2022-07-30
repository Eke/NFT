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
    return AuthController()
  }
}
