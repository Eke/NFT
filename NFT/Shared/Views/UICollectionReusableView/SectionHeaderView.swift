//
//  SectionHeaderView.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
  static let reuseIdentifier: String = "SectionHeaderView"

  private lazy var titleLabel: UILabel = {
    let view = UILabel(frame: .zero)
    view.textColor = .neutral8
    view.font = .preferredFont(forTextStyle: .title1).bold()
    return view
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    root: do {
      setup()
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func awakeFromNib() {
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    isOpaque = true
  }

  private func setup() {

    addSubview(titleLabel)

    layout()
  }

  private func layout() {
    titleLabel.snp.remakeConstraints { make in
      make.width.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }

  func set(title: String?) {
    titleLabel.text = title?.uppercased()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
  }

  deinit {
    print("⬅️🗑 deinit SectionHeaderView")
  }
}
