//
//  PillContentView.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import UIKit

extension UICollectionViewCell {
    func pillConfiguration(title: String, icon: String? = nil, backgroundColor: UIColor? = nil, textColor: UIColor? = nil) -> PillContentView.Configuration {
      PillContentView.Configuration(title: title, icon: icon, backgroundColor: backgroundColor, textColor: textColor)
    }
}

class PillContentView: UIView, UIContentView {
  struct Configuration: UIContentConfiguration {
    let title: String
    let icon: String?
    let backgroundColor: UIColor?
    let textColor: UIColor?

    func updated(for state: UIConfigurationState) -> PillContentView.Configuration {
      return self
    }

    func makeContentView() -> UIView & UIContentView {
      return PillContentView(self)
    }
  }

  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }

  private lazy var iconView: UIImageView = {
    let view = UIImageView()
    return view
  }()

  private lazy var label: UILabel = {
    let view = UILabel()
    view.font = .preferredFont(forTextStyle: .caption1)
    return view
  }()

  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)

    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    makeRoundedCorners(.allCorners, withRadius: CornerRadius.radius7)
  }

  private func setup() {
    addSubview(iconView)
    addSubview(label)
    layout()
  }

  private func layout() {
    iconView.snp.remakeConstraints { make in
      make.leading.equalToSuperview().offset(Spacing.spacing8)
      make.centerY.equalToSuperview()
      make.size.equalTo(22.0).priority(999)
    }


    label.snp.remakeConstraints { make in
      make.leading.equalTo(iconView.snp.trailing).offset(Spacing.spacing8)
      make.trailing.equalToSuperview().offset(Spacing.spacing8.negative)
      make.centerY.equalToSuperview()
      make.width.lessThanOrEqualTo(150)
    }
  }

  func configure(configuration: UIContentConfiguration) {
    guard let conf = configuration as? Configuration else { return }

    backgroundColor = conf.backgroundColor ?? .neutral2

    label.text = conf.title
    label.textColor = conf.textColor ?? .neutral8

    let image = UIImage(systemName: conf.icon ?? "circle.fill")
    iconView.image = image
    iconView.tintColor = label.textColor

    layout()
  }
}
