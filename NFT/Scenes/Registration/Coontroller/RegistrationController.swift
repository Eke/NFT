//
//  RegistrationController.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit
import RxSwift

class RegistrationController: BaseViewController {
  private let disposeBag = DisposeBag()

  private let viewModel: RegistrationViewModelType

  private let wrapperView: UIView = UIView(frame: .zero)

  private lazy var formHolder: UIView = {
    let view = UIView(frame: .zero)
    return view
  }()

  private lazy var formWrapper: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = .neutral2
    return view
  }()

  private lazy var emailField: UITextField = {
    let view = UITextField(frame: .zero)
    view.placeholder = NSLocalizedString("email".capitalized, comment: "")
    view.backgroundColor = .neutral1
    view.setLeftPaddingPoints(Spacing.spacing7)
    view.textColor = .neutral8
    view.autocorrectionType = .no
    view.autocapitalizationType = .none
    view.textContentType = .username
    view.keyboardType = .emailAddress
    return view
  }()

  private lazy var passwordField: UITextField = {
    let view = UITextField(frame: .zero)
    view.placeholder = NSLocalizedString("password".capitalized, comment: "")
    view.backgroundColor = .neutral1
    view.setLeftPaddingPoints(Spacing.spacing7)
    view.textColor = .neutral8
    view.isSecureTextEntry = true
    view.textContentType = .password
    return view
  }()

  private lazy var ageField: UITextField = {
    let view = UITextField(frame: .zero)
    view.placeholder = NSLocalizedString("age".capitalized, comment: "")
    view.backgroundColor = .neutral1
    view.setLeftPaddingPoints(Spacing.spacing7)
    view.textColor = .neutral8
    view.autocorrectionType = .no
    view.autocapitalizationType = .none
    view.keyboardType = .numberPad
    return view
  }()

  private lazy var submitButton: UIButton = {
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

      button.configuration?.title = NSLocalizedString("let's go".uppercased(), comment: "")

      button.configuration?.showsActivityIndicator = strongSelf.submitButtonSpinnerVisible
    }

    return view
  }()

  private lazy var emailErrorLabel: UILabel = {
    let view = UILabel()
    view.textColor = .primary3
    view.font = .preferredFont(forTextStyle: .caption1)
    return view
  }()

  private lazy var passwordErrorLabel: UILabel = {
    let view = UILabel()
    view.textColor = .primary3
    view.font = .preferredFont(forTextStyle: .caption1)
    return view
  }()

  private lazy var ageErrorLabel: UILabel = {
    let view = UILabel()
    view.textColor = .primary3
    view.font = .preferredFont(forTextStyle: .caption1)
    return view
  }()

  private var submitButtonSpinnerVisible: Bool = false

  // MARK: Lifecycle

  init(withViewModel vm: RegistrationViewModelType) {
    viewModel = vm
    super.init(nibName: nil, bundle: nil)

    title = NSLocalizedString("registration".uppercased(), comment: "")

    setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    print("⬅️🗑 deinit RegistrationController")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.outputs.submitButtonEnabled
      .drive(with: self) { owner, isEnabled in
        owner.didReceive(submitButtonAvailability: isEnabled)
      }
      .disposed(by: disposeBag)

    viewModel.outputs.formErrors
      .drive(with: self) { owner, errors in
        owner.didReceive(formErrors: errors)
      }
      .disposed(by: disposeBag)

    viewModel.outputs.showSpinner
      .drive(with: self) { owner, visible in
        owner.didReceive(spinnerVisibility: visible)
      }
      .disposed(by: disposeBag)

    viewModel.inputs.bind(emailField: emailField, passwordField: passwordField, andAgeField: ageField)
    viewModel.inputs.bind(submitButton: submitButton)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    formWrapper.makeRoundedCorners(.allCorners, withRadius: CornerRadius.radius2)

    for field in [emailField, passwordField, ageField] {
      field.layer.cornerRadius = CornerRadius.radius7
      field.layer.borderWidth = 1.0
      field.layer.borderColor = UIColor.clear.cgColor
    }
  }

  private func setup() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
    view.addGestureRecognizer(tapGesture)

    wrapperView.addSubview(formWrapper)

    formWrapper.addSubview(emailField)
    formWrapper.addSubview(emailErrorLabel)
    formWrapper.addSubview(passwordField)
    formWrapper.addSubview(passwordErrorLabel)
    formWrapper.addSubview(ageField)
    formWrapper.addSubview(ageErrorLabel)
    formWrapper.addSubview(submitButton)
    formHolder.addSubview(formWrapper)

    wrapperView.addSubview(formHolder)

    view.addSubview(wrapperView)

    layout()
  }

  private func layout() {
    wrapperView.snp.makeConstraints { make in
      make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
      make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
    }

    formHolder.snp.remakeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.centerY.equalTo(wrapperView.snp.centerY)
    }

    formWrapper.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(Spacing.spacing7)
      make.trailing.equalToSuperview().offset(Spacing.spacing7.negative).priority(999)
      make.top.equalToSuperview().offset(Spacing.spacing7)//.priority(.medium)
      make.bottom.lessThanOrEqualToSuperview().offset(Spacing.spacing7.negative)
    }

    emailField.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().offset(Spacing.spacing7)
      make.trailing.equalToSuperview().offset(Spacing.spacing7.negative).priority(999)
      make.height.equalTo(48.0)
    }

    emailErrorLabel.snp.makeConstraints { make in
      make.leading.trailing.equalTo(emailField)
      make.top.equalTo(emailField.snp.bottom).offset(Spacing.spacing8)
    }

    passwordField.snp.makeConstraints { make in
      make.leading.trailing.equalTo(emailField)
      make.height.equalTo(emailField)
      make.top.equalTo(emailErrorLabel.snp.bottom).offset(Spacing.spacing8)
    }

    passwordErrorLabel.snp.makeConstraints { make in
      make.leading.trailing.equalTo(emailField)
      make.top.equalTo(passwordField.snp.bottom).offset(Spacing.spacing8)
    }

    ageField.snp.makeConstraints { make in
      make.leading.trailing.equalTo(emailField)
      make.height.equalTo(emailField)
      make.top.equalTo(passwordErrorLabel.snp.bottom).offset(Spacing.spacing8)
    }

    ageErrorLabel.snp.makeConstraints { make in
      make.leading.trailing.equalTo(emailField)
      make.top.equalTo(ageField.snp.bottom).offset(Spacing.spacing8)
    }

    submitButton.snp.makeConstraints { make in
      make.leading.trailing.equalTo(emailField)
      make.height.equalTo(44.0)
      make.top.equalTo(ageErrorLabel.snp.bottom).offset(Spacing.spacing8)
      make.bottom.equalTo(formWrapper.snp.bottom).offset(Spacing.spacing7.negative)
    }
  }

  // MARK: Private Implementations
  private func didReceive(submitButtonAvailability isEnabled: Bool) {
    submitButton.isEnabled = isEnabled
  }

  private func didReceive(spinnerVisibility show: Bool) {
    submitButtonSpinnerVisible = show
    submitButton.setNeedsUpdateConfiguration()
  }

  private func didReceive(formErrors: RegistrationFormErrors) {
    emailErrorLabel.text = formErrors.email
    passwordErrorLabel.text = formErrors.password
    ageErrorLabel.text = formErrors.age

    UIView.animate(withDuration: 0.15, delay: 0) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      strongSelf.view.layoutIfNeeded()
    }
  }


  // MARK: Actions

  /// Invoked when root view is tapped
  @objc func didTapView() {
    view.endEditing(true)
  }
}
