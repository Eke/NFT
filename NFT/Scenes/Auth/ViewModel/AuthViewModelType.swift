//
//  AuthViewModelType.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import RxSwift
import UIKit
import RxCocoa

/// Protocol for AuthViewModelType setters
protocol AuthViewModelInputs {
  func bind(emailField: UITextField, andPasswordField passwordField: UITextField)
  func bind(submitButton: UIButton)
}

/// Protocol for AuthViewModelType getters
protocol AuthViewModelOutputs {
  var submitButtonEnabled: Driver<Bool> { get }
  var formErrors: Driver<AuthFormErrors> { get }
}

/// Main view model  protocol. each view model used for feed representation must conform to this one.
protocol AuthViewModelType {
  /// inputs are used to give data to view model
  var inputs: AuthViewModelInputs { get }
  /// getters are used to recieve data from view model
  var outputs: AuthViewModelOutputs { get }
}

extension AuthViewModel: AuthViewModelType {
  var inputs: AuthViewModelInputs { return self }
  var outputs: AuthViewModelOutputs { return self }
}
