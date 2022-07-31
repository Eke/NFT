//
//  CurrentUserViewModel.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import RxSwift

class CurrentUserViewModel: NSObject, CurrentUserViewModelInputs, CurrentUserViewModelOutputs {
  // MARK: LifeCycle

  let user: Observable<User>

  override init() {
    user = CurrentSessionProvider.shared.currentUser
      .compactMap { $0 }
      .distinctUntilChanged()
      .share(replay: 1)

    super.init()
  }

  deinit {
    print("⬅️🗑 deinit CurrentUserViewModel")
  }

  // MARK: Inputs

  func bind(logoutButton: UIButton) {
    _ = logoutButton.rx.tap
      .withUnretained(self)
      .subscribe { owner, _ in
        CurrentSessionProvider.shared.set(user: nil)
      }
  }
}
