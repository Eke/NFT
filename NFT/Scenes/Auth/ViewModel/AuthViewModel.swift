//
//  AuthViewModel.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import RxSwift
import RxCocoa
import Resolver

typealias AuthFormErrors = (email: String?, password: String?)

class AuthViewModel: NSObject, AuthViewModelInputs, AuthViewModelOutputs {
  private let disposeBag = DisposeBag()

  @Injected var userRepository: UserRepositoring

  lazy var submitButtonEnabled: Driver<Bool> = {
    return Observable.combineLatest(password.asObservable(), email.asObservable(), isAuthenticating) { [weak self] password, email, isAuthenticating in
      guard let strognSelf = self, !isAuthenticating else {
        return false
      }

      return strognSelf.credentialsAreValid(email: email, password: password)
    }
    .distinctUntilChanged()
    .asDriver(onErrorJustReturn: false)
  }()

  let formErrors: Driver<AuthFormErrors>

  private let password: BehaviorRelay<String> = BehaviorRelay(value: "")
  private let email: BehaviorRelay<String> = BehaviorRelay(value: "")

  private let isAuthenticating: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)

  lazy var showSpinner: Driver<Bool> = {
    return isAuthenticating.asDriver(onErrorJustReturn: false)
  }()

  // MARK: LifeCycle

  override init() {
    formErrors = Observable.combineLatest(password.asObservable(), email.asObservable()) { password, email in
      let emailError: String? = email.isValidEmail || email.isEmpty
        ? nil
        : "Email is not valid"

      let passwordError: String? = password.isValidPassword || password.isEmpty
        ? nil
        : "Password should be min. 6 and max. 16 characters long"

      return (emailError, passwordError)
    }
    .distinctUntilChanged({ lhs, rhs in
      return lhs.email == rhs.email && lhs.password == rhs.password
    })
    .asDriver(onErrorJustReturn: (nil, nil))

    super.init()
  }

  // MARK: Inputs

  func bind(emailField: UITextField, andPasswordField passwordField: UITextField) {
    emailField.rx.text.orEmpty
      .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
      .bind(to: email)
      .disposed(by: disposeBag)

    passwordField.rx.text.orEmpty
      .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
      .bind(to: password)
      .disposed(by: disposeBag)
  }

  func bind(submitButton: UIButton) {
    _ = submitButton.rx.tap
      .withUnretained(self)
      .subscribe { owner, _ in
        owner.authUser()
      }
  }

  // MARK: Private Implementations
  func credentialsAreValid(email: String, password: String) -> Bool {
    return email.isValidEmail && password.isValidPassword
  }

  func authUser() {
    let password = password.value
    let email = email.value

    guard credentialsAreValid(email: email, password: password) else {
      return
    }

    isAuthenticating.onNext(true)

    _ = userRepository.auth(withEmail: email, andPassword: password)
      .withUnretained(self)
      .subscribe(onNext: { owner, user in
        CurrentSessionProvider.shared.set(user: user)
      }, onError: { [weak self] error in
        guard let strongSelf = self else {
          return
        }
        strongSelf.isAuthenticating.onNext(false)
      })
  }

  deinit {
    print("⬅️🗑 deinit AuthViewModel")
  }
}
