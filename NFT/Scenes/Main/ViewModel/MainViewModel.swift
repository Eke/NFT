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
  /// Leaving actions here just to showcase how I usualy do this
  let actions: Observable<ViewActions>

  /// data or ui related actions dispatched by viewmodel
  private let actionsSubject: PublishSubject<ViewActions> = PublishSubject<ViewActions>()

  // MARK: LifeCycle

  override init() {
    actions = actionsSubject.asObserver()

    super.init()
  }

  deinit {
    print("⬅️🗑 deinit MainViewModel")
  }

  // MARK: Inputs

  func viewDidLoad() {
    actionsSubject.onNext(.presentSplash)
    Task.detached(priority: .high) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      try await Task.sleep(seconds: 0.5)
      // TODO: Restore session
      strongSelf.didFinishPreparingLaunch()
    }
  }

  // MARK: Private Implementations

  func didFinishPreparingLaunch() {
    CurrentSessionProvider.shared.isAuthed
      .withUnretained(self)
      .subscribe { owner, isAuthed in
        if isAuthed {
          owner.userAuthorizedHandler()
        } else {
          owner.userUnauthorizedHandler()
        }
      }
      .disposed(by: disposeBag)
  }

  private func userAuthorizedHandler() {
    actionsSubject.onNext(.presentApplication)
  }

  private func userUnauthorizedHandler() {
    actionsSubject.onNext(.presentAuth)
  }
}
