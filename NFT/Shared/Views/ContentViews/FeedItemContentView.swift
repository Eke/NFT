//
//  FeedItemContentView.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import UIKit
import SDWebImage

extension UICollectionViewCell {
    func feedConfiguration(forItem item: FeedItem) -> FeedItemContentView.Configuration {
      FeedItemContentView.Configuration(item: item)
    }
}


class FeedItemContentView: UIView, UIContentView {
  struct Configuration: UIContentConfiguration {
    func updated(for state: UIConfigurationState) -> FeedItemContentView.Configuration {
      return self
    }

    let item: FeedItem

    func makeContentView() -> UIView & UIContentView {
      return FeedItemContentView(self)
    }
  }

  var configuration: UIContentConfiguration {
    didSet {
      configure(configuration: configuration)
    }
  }

  private var currentID: Int?

  private lazy var imageView: UIImageView = {
    let view = UIImageView(frame: .zero)
    view.contentMode = .scaleAspectFill
    return view
  }()

  private lazy var userWrapper: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .dark)
    let view = UIVisualEffectView(effect: blurEffect)
    return view
  }()

  private lazy var avatarView: UIImageView = {
    let view = UIImageView(frame: .zero)
    view.contentMode = .scaleAspectFill
    view.backgroundColor = .neutral1
    return view
  }()

  private lazy var userNameLabel: UILabel = {
    let view = UILabel()
    view.textColor = .neutral8
    view.font = .preferredFont(forTextStyle: .caption1)
    return view
  }()

  private lazy var statsWrapper: UIVisualEffectView = {
    let blurEffect = UIBlurEffect(style: .dark)
    let view = UIVisualEffectView(effect: blurEffect)
    return view
  }()

  init(_ configuration: UIContentConfiguration) {
    self.configuration = configuration
    super.init(frame: .zero)
    backgroundColor = .neutral2

    setup()
  }

  private lazy var heartView: UIImageView = {
    let image = UIImage(systemName: "heart.circle")
    let view = UIImageView(image: image)
    view.tintColor = .primary3
    return view
  }()

  private lazy var likesLabel: UILabel = {
    let view = UILabel()
    view.textColor = .neutral8
    view.font = .preferredFont(forTextStyle: .caption1)
    return view
  }()

  private lazy var commentView: UIImageView = {
    let image = UIImage(systemName: "bubble.left.circle")
    let view = UIImageView(image: image)
    view.tintColor = .secondary3
    return view
  }()

  private lazy var commentsLabel: UILabel = {
    let view = UILabel()
    view.textColor = .neutral8
    view.font = .preferredFont(forTextStyle: .caption1)
    return view
  }()

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    makeRoundedCorners(.allCorners, withRadius: CornerRadius.radius5)
    userWrapper.makeRoundedCorners(.allCorners, withRadius: CornerRadius.radius7)
    statsWrapper.makeRoundedCorners(.allCorners, withRadius: CornerRadius.radius7)
    avatarView.makeRoundedCorners(.allCorners, withRadius: 12.0)
  }

  private func setup() {
    addSubview(imageView)

    addSubview(userWrapper)
    userWrapper.contentView.addSubview(avatarView)
    userWrapper.contentView.addSubview(userNameLabel)

    addSubview(statsWrapper)
    statsWrapper.contentView.addSubview(heartView)
    statsWrapper.contentView.addSubview(likesLabel)
    statsWrapper.contentView.addSubview(commentView)
    statsWrapper.contentView.addSubview(commentsLabel)

    layout()
  }

  private func layout() {
    guard let conf = configuration as? Configuration else { return }

    let ratio = Double(conf.item.imageWidth) / Double(conf.item.imageHeight)

    imageView.snp.remakeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(imageView.snp.width).dividedBy(ratio).priority(999)
    }

    userWrapper.snp.remakeConstraints { make in
      make.bottom.equalToSuperview().offset(Spacing.spacing8.negative)
      make.leading.equalToSuperview().offset(Spacing.spacing8)
    }

    avatarView.snp.remakeConstraints { make in
      make.size.equalTo(22.0)
      make.leading.top.equalToSuperview().offset(Spacing.spacing8)
      make.bottom.equalToSuperview().offset(Spacing.spacing8.negative)
    }

    userNameLabel.snp.remakeConstraints { make in
      make.centerY.equalTo(avatarView.snp.centerY)
      make.trailing.equalToSuperview().offset(Spacing.spacing8.negative)
      make.leading.equalTo(avatarView.snp.trailing).offset(Spacing.spacing8)
    }

    statsWrapper.snp.remakeConstraints { make in
      make.height.equalTo(userWrapper.snp.height)
      make.bottom.trailing.equalToSuperview().offset(Spacing.spacing8.negative)
    }

    heartView.snp.remakeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(Spacing.spacing8)
    }

    likesLabel.snp.remakeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(heartView.snp.trailing).offset(Spacing.spacing8)
    }

    commentView.snp.remakeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(likesLabel.snp.trailing).offset(Spacing.spacing8)
    }

    commentsLabel.snp.remakeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(commentView.snp.trailing).offset(Spacing.spacing8)
      make.trailing.equalToSuperview().offset(Spacing.spacing8.negative)
    }
  }

  func configure(configuration: UIContentConfiguration) {
    guard let conf = configuration as? Configuration else { return }

    if currentID == conf.item.id {
      return
    }

    currentID = conf.item.id

    imageView.sd_cancelCurrentImageLoad()
    imageView.sd_setImage(
      with: conf.item.webformatURL
    )

    avatarView.sd_setImage(
      with: conf.item.avatarURL
    )

    userNameLabel.text = conf.item.user
    likesLabel.text = "\(conf.item.likes)"
    commentsLabel.text = "\(conf.item.comments)"

    layout()
  }
}
