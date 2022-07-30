//
//  AuthViewModel.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import RxSwift
import RxCocoa

typealias AuthFormErrors = (email: String?, password: String?)

class AuthViewModel: NSObject, AuthViewModelInputs, AuthViewModelOutputs {
  private let disposeBag = DisposeBag()

  let submitButtonEnabled: Driver<Bool>
  let formErrors: Driver<AuthFormErrors>

  private let password: BehaviorRelay<String> = BehaviorRelay(value: "")
  private let email: BehaviorRelay<String> = BehaviorRelay(value: "")

  // MARK: LifeCycle

  override init() {
    submitButtonEnabled = Observable.combineLatest(password.asObservable(), email.asObservable()) { password, email in
      return email.isValidEmail == true && password.isValidPassword == true
    }
    .distinctUntilChanged()
    .asDriver(onErrorJustReturn: false)

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
    submitButton.rx.tap
      .bind {
        print("AAA")
      }
      .disposed(by: disposeBag)
  }

  deinit {
    print("⬅️🗑 deinit AuthViewModel")
  }
}
