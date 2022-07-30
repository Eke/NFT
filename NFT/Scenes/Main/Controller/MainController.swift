//
//  MainController.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit
import SnapKit
import RiveRuntime
import RxSwift
import Resolver

class MainController: UIViewController {
  /// DisposeBag instance for subscriptions
  private let disposeBag = DisposeBag()

  /// ViewModel instance
  private let viewModel: MainViewModelType

  /// Stores currentrly visible `UIViewController` instance
  private var current: UIViewController?

  // MARK: Lifecycle

  /// Default initializer
  /// - Parameter vm: instance of `MainViewModelType`
  init(withViewModel vm: MainViewModelType) {
    viewModel = vm
    super.init(nibName: nil, bundle: nil)

    setup()
  }

  deinit {
    print("⬅️🗑 deinit MainController")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.outputs.actions
      .subscribe(on: MainScheduler.instance)
      .observe(on: MainScheduler.instance)
      .withUnretained(self)
      .subscribe(onNext: { owner, action in
        owner.didReceive(newAction: action)
      })
      .disposed(by: disposeBag)

    viewModel.inputs.viewDidLoad()
  }

  private func setup() {
    layout()
  }

  private func layout() {
  }

  // MARK: Data getters

  /// Triggered when `viewModel` emits new action
  /// - Parameter action: `MainViewModel.ViewActions`
  private func didReceive(newAction action: MainViewModel.ViewActions) {
    switch action {
    case .presentSplash:
      presentSplash()
    case .presentAuth:
      presentAuthGate()
    case .presentApplication:
      presentApplication()
    }
  }

  // MARK: Private Implementations

  /// Present splash screen
  func presentSplash() {
    current = SplashController()
    addChild(current!)
    current!.view.frame = view.bounds
    view.addSubview(current!.view)
    current!.didMove(toParent: self)
  }

  /// Present auth flow
  func presentAuthGate() {
    let authNavigator = Resolver.resolve(AuthNavigator.self)
    let authController = ControllersFactory.authController()
    let initialViewController = UINavigationController(rootViewController: authController)
    initialViewController.view.backgroundColor = .red
    authNavigator.baseController = initialViewController

    animateFadeTransition(to: initialViewController) { [weak self] in
      guard let weakSelf = self else {
        fatalError("Missing weakSelf")
      }
      weakSelf.setNeedsStatusBarAppearanceUpdate()
    }
  }

  /// Present main application flow
  func presentApplication() {
    print("presentApplication")
  }

  private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
    guard let current = current else {
      return
    }

    new.view.alpha = .zero
    addChild(new)
    current.willMove(toParent: nil)
    new.willMove(toParent: self)
    self.view.addSubview(new.view)

    UIView.animate(withDuration: 0.3, delay: .zero, options: []) {
      current.view.alpha = .zero
      new.view.alpha = 1.0
    } completion: { _ in
      current.didMove(toParent: nil)
      current.removeFromParent()
      current.view.removeFromSuperview()
      new.didMove(toParent: self)
      self.view.addSubview(new.view)
      self.current = new
      completion?()
    }
  }
}
