//
//  RegistrationViewModel.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import RxSwift
import RxCocoa
import Resolver

typealias RegistrationFormErrors = (email: String?, password: String?, age: String?)

class RegistrationViewModel: NSObject, RegistrationViewModelInputs, RegistrationViewModelOutputs {
  @Injected private var navigator: AuthNavigator

  private let disposeBag = DisposeBag()

  @Injected var userRepository: UserRepositoring

  lazy var submitButtonEnabled: Driver<Bool> = {
    return Observable.combineLatest(password.asObservable(), email.asObservable(), age.asObservable(), isAuthenticating) { [weak self] password, email, age, isAuthenticating in
      guard let strognSelf = self, !isAuthenticating else {
        return false
      }

      return strognSelf.credentialsAreValid(email: email, password: password, age: age)
    }
    .distinctUntilChanged()
    .asDriver(onErrorJustReturn: false)
  }()

  let formErrors: Driver<RegistrationFormErrors>

  private let password: BehaviorRelay<String> = BehaviorRelay(value: "")
  private let email: BehaviorRelay<String> = BehaviorRelay(value: "")
  private let age: BehaviorRelay<Int> = BehaviorRelay(value: -1)

  private let isAuthenticating: BehaviorSubject<Bool> = BehaviorSubject<Bool>(value: false)

  lazy var showSpinner: Driver<Bool> = {
    return isAuthenticating.asDriver(onErrorJustReturn: false)
  }()

  // MARK: LifeCycle

  override init() {
    formErrors = Observable.combineLatest(password.asObservable(), email.asObservable(), age.asObservable()) { password, email, age in
      let emailError: String? = email.isValidEmail || email.isEmpty
        ? nil
        : "Email is not valid."

      let passwordError: String? = password.isValidPassword || password.isEmpty
        ? nil
        : "Password should be min. 6 and max. 16 characters long."

      let ageError: String? = 18...90 ~= age || age == -1
        ? nil
        : age < 18 ? "You are too young." : "You are too old."

      return (emailError, passwordError, ageError)
    }
    .distinctUntilChanged({ lhs, rhs in
      return lhs.email == rhs.email && lhs.password == rhs.password && lhs.age == rhs.age
    })
    .asDriver(onErrorJustReturn: (nil, nil, nil))

    super.init()
  }

  deinit {
    print("⬅️🗑 deinit RegistrationViewModel")
  }

  // MARK: Inputs

  func bind(emailField: UITextField, passwordField: UITextField, andAgeField ageField: UITextField) {
    emailField.rx.text.orEmpty
      .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
      .bind(to: email)
      .disposed(by: disposeBag)

    passwordField.rx.text.orEmpty
      .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
      .bind(to: password)
      .disposed(by: disposeBag)

    ageField.rx.text.orEmpty
      .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
      .map { value in
        guard let int = Int(value) else {
          return -1
        }

        return int
      }
      .bind(to: age)
      .disposed(by: disposeBag)
  }

  func bind(submitButton: UIButton) {
    _ = submitButton.rx.tap
      .withUnretained(self)
      .subscribe { owner, _ in
        owner.registerUser()
      }
  }

  // MARK: Private Implementations
  func credentialsAreValid(email: String, password: String, age: Int) -> Bool {
    return email.isValidEmail && password.isValidPassword && 18...90 ~= age
  }

  func registerUser() {
    let password = password.value
    let email = email.value
    let age = age.value

    guard credentialsAreValid(email: email, password: password, age: age) else {
      return
    }

    navigator.baseController?.view.endEditing(true)

    isAuthenticating.onNext(true)

    _ = userRepository.register(withEmail: email, password: password, andAge: age)
      .flatMapLatest({ [weak self] registeredUser -> Observable<User> in
        guard let strongSelf = self else {
          return Observable.error(CustomError.authFailed)
        }
        return strongSelf.userRepository.auth(withEmail: email, andPassword: password)
      })
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
}
