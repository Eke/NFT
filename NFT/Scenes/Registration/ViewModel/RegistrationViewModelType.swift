//
//  RegistrationViewModelType.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import RxSwift
import UIKit
import RxCocoa

/// Protocol for RegistrationViewModelType setters
protocol RegistrationViewModelInputs {
  func bind(emailField: UITextField, passwordField: UITextField, andAgeField ageField: UITextField)
  func bind(submitButton: UIButton)
}

/// Protocol for RegistrationViewModelType getters
protocol RegistrationViewModelOutputs {
  var submitButtonEnabled: Driver<Bool> { get }
  var formErrors: Driver<RegistrationFormErrors> { get }
  var showSpinner: Driver<Bool> { get }
}

protocol RegistrationViewModelType {
  /// inputs are used to give data to view model
  var inputs: RegistrationViewModelInputs { get }
  /// getters are used to recieve data from view model
  var outputs: RegistrationViewModelOutputs { get }
}

extension RegistrationViewModel: RegistrationViewModelType {
  var inputs: RegistrationViewModelInputs { return self }
  var outputs: RegistrationViewModelOutputs { return self }
}


