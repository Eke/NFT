//
//  CurrentSessionProvider.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import RxSwift
import RxRelay
import Resolver

final class CurrentSessionProvider: NSObject {
  @Injected var userRepository: UserRepositoring

  private let currentUserRelay: BehaviorSubject<User?> = BehaviorSubject<User?>(value: nil)

  lazy var currentUser: Observable<User?> = {
    return currentUserRelay.asObservable().share(replay: 1)
  }()

  lazy var isAuthed: Observable<Bool> = {
    return currentUser.map { $0 != nil }
  }()

  static let shared = CurrentSessionProvider()

  private override init() {
    super.init()
  }

  func set(user: User?) {
    currentUserRelay.onNext(user)
  }

  deinit {
    print("⬅️🗑 deinit CurrentSessionProvider")
  }
}
