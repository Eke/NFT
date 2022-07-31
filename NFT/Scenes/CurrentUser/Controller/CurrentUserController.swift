//
//  CurrentUserController.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import UIKit
import SnapKit
import RxSwift

class CurrentUserController: BaseViewController {
  private let disposeBag = DisposeBag()

  private let viewModel: CurrentUserViewModelType

  private lazy var avatarView: UIImageView = {
    let image = UIImage(named: "logo")
    let view = UIImageView(image: image)
    view.contentMode = .scaleAspectFill
    view.backgroundColor = .primary2
    return view
  }()

  private lazy var emailLabel: UILabel = {
    let view = UILabel()
    view.textAlignment = .center
    view.textColor = .neutral8
    view.font = .systemFont(ofSize: 32.0, weight: .bold)
    return view
  }()

  private lazy var ageLabel: UILabel = {
    let view = UILabel()
    view.textAlignment = .center
    view.textColor = .neutral8
    view.font = .systemFont(ofSize: 16.0, weight: .bold)
    return view
  }()

  private lazy var logoutButton: UIButton = {
    var config = UIButton.Configuration.filled()
    config.baseBackgroundColor = .primary3
    config.background.cornerRadius = CornerRadius.radius7

    config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
      var outgoing = incoming
      outgoing.font = .preferredFont(forTextStyle: .body).bold()
      return outgoing
    }

    let view = UIButton(configuration: config)
    view.configurationUpdateHandler = { [weak self] button in
      guard let strongSelf = self else {
        return
      }

      button.configuration?.title = NSLocalizedString("log out".uppercased(), comment: "")
    }

    return view
  }()

  // MARK: Lifecycle

  /// Default initializer
  /// - Parameter vm: instance of `CurrentUserViewModelType`
  init(withViewModel vm: CurrentUserViewModelType) {
    viewModel = vm
    super.init(nibName: nil, bundle: nil)

    setup()
  }

  deinit {
    print("⬅️🗑 deinit CurrentUserController")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.outputs.user
      .subscribe(on: MainScheduler.instance)
      .observe(on: MainScheduler.instance)
      .withUnretained(self)
      .subscribe(onNext: { owner, user in
        owner.didReceive(user: user)
      })
      .disposed(by: disposeBag)

    viewModel.inputs.bind(logoutButton: logoutButton)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    avatarView.makeRoundedCorners(.allCorners, withRadius: avatarView.bounds.size.width / 2.0)
  }

  private func setup() {
    view.addSubview(avatarView)
    view.addSubview(emailLabel)
    view.addSubview(ageLabel)
    view.addSubview(logoutButton)
    layout()
  }

  private func layout() {
    avatarView.snp.makeConstraints { make in
      make.bottom.equalTo(emailLabel.snp.top).offset(Spacing.spacing7.negative)
      make.centerX.equalToSuperview()
      make.height.equalTo(150.0)
      make.width.equalTo(avatarView.snp.height)
    }

    emailLabel.snp.remakeConstraints { make in
      make.center.equalToSuperview()
    }

    ageLabel.snp.remakeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(emailLabel.snp.bottom).offset(Spacing.spacing8)
    }

    logoutButton.snp.remakeConstraints { make in
      make.centerX.equalToSuperview()
      make.height.equalTo(44.0)
      make.top.equalTo(ageLabel.snp.bottom).offset(Spacing.spacing4)
    }
  }

  // MARK: Private Implementations

  func didReceive(user: User) {
    emailLabel.text = user.email
    ageLabel.text = "\(user.age) years old"
  }
}
