//
//  BaseControllerView.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit

class BaseControllerView: UIView {
  private lazy var imageView: UIImageView = {
    let image = UIImage(named: "blur-background")
    return UIImageView(image: image)
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  private func setup() {
    autoresizingMask = [.flexibleWidth, .flexibleHeight]
    isOpaque = true

    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)

    imageView.snp.remakeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// Invoked when deallocated
  deinit {
    print("⬅️🗑 deinit BaseControllerView")
  }
}
