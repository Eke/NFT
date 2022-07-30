//
//  SplashController.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit
import RiveRuntime
import SpriteKit

class SplashController: UIViewController {
  private let animationViewModel = RiveViewModel(fileName: "splash")
  private let animationView = RiveView()

  private lazy var logoView: UIImageView = {
    let image = UIImage(named: "logo")
    return UIImageView(image: image)
  }()

  // MARK: Lifecycle

  init() {
    super.init(nibName: nil, bundle: nil)

    setup()
  }

  deinit {
    print("⬅️🗑 deinit SplashController")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  /// Setup Views
  private func setup() {
    animationViewModel.setView(animationView)
    view.addSubview(animationView)
    view.addSubview(logoView)
    layout()
  }

  /// Layout Views
  private func layout() {
    animationView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    logoView.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
