//
//  MainViewModelType.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import RxSwift
import RxSwift

extension MainViewModel {
  /// Enum for `MainViewModel.ViewActions`
  enum ViewActions {
    case presentSplash
    case presentAuth
    case presentApplication
  }
}

/// Protocol for MainViewModelType setters
protocol MainViewModelInputs {
  func viewDidLoad()
}

/// Protocol for MainViewModelType getters
protocol MainViewModelOutputs {
  var actions: Observable<MainViewModel.ViewActions> { get }
}

/// Main view model  protocol. each view model used for feed representation must conform to this one.
protocol MainViewModelType {
  /// inputs are used to give data to view model
  var inputs: MainViewModelInputs { get }
  /// getters are used to recieve data from view model
  var outputs: MainViewModelOutputs { get }
}

extension MainViewModel: MainViewModelType {
  var inputs: MainViewModelInputs { return self }
  var outputs: MainViewModelOutputs { return self }
}
