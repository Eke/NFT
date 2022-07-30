//
//  AuthController.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit
import Resolver

class AuthController: BaseViewController {
  @Injected private var navigator: AuthNavigator

  // MARK: Lifecycle

  init() {
    super.init(nibName: nil, bundle: nil)
    title = "Auth"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("⬅️🗑 deinit AuthController")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    title = "Test"
  }
}
