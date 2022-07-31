//
//  CurrentUserViewModelType.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import RxSwift
import UIKit

/// Protocol for CurrentUserViewModelType setters
protocol CurrentUserViewModelInputs {
  func bind(logoutButton: UIButton)
}

/// Protocol for CurrentUserViewModelType getters
protocol CurrentUserViewModelOutputs {
  var user: Observable<User> { get }
}

protocol CurrentUserViewModelType {
  /// inputs are used to give data to view model
  var inputs: CurrentUserViewModelInputs { get }
  /// getters are used to recieve data from view model
  var outputs: CurrentUserViewModelOutputs { get }
}

extension CurrentUserViewModel: CurrentUserViewModelType {
  var inputs: CurrentUserViewModelInputs { return self }
  var outputs: CurrentUserViewModelOutputs { return self }
}
