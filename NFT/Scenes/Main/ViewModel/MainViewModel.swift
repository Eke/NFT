//
//  MainViewModel.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import RxSwift
import RxCocoa

/// MainViewModel: ViewModel for MainController
class MainViewModel: NSObject, MainViewModelInputs, MainViewModelOutputs {
  private let disposeBag = DisposeBag()

  /// data or ui related actions dispatched by viewmodel
  let actions: Observable<ViewActions>

  /// data or ui related actions dispatched by viewmodel
  private let actionsSubject: PublishSubject<ViewActions> = PublishSubject<ViewActions>()

  override init() {
    actions = actionsSubject.asObserver()

    super.init()
  }

  deinit {
    print("⬅️🗑 deinit MainViewModel")
  }

  func viewDidLoad() {
    actionsSubject.onNext(.presentSplash)
    Task.detached(priority: .high) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      try await Task.sleep(seconds: 2)
      // TODO: Restore session
      strongSelf.didFinishPreparingLaunch()
    }
  }

  func didFinishPreparingLaunch() {
    authStateDidChange()
    // TODO: Validate session
  }

  private func authStateDidChange() {
    let isAuthed = false
    if isAuthed {
      userAuthorizedHandler()
    } else {
      userUnauthorizedHandler()
    }
  }

  private func userAuthorizedHandler() {
    actionsSubject.onNext(.presentApplication)
  }

  private func userUnauthorizedHandler() {
    actionsSubject.onNext(.presentAuth)
  }
}
