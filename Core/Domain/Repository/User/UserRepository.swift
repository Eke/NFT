//
//  UserRepository.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import Foundation
import RxSwift

enum CustomError: Error {
  case authFailed
}

var availableUser = [
  User(id: UUID().uuidString, email: "demo@demo.com", password: "123456", age: 30)
]

protocol UserRepositoring {
  /// Auth user with an email and password
  /// - Parameters:
  ///   - email: `String` email of user
  ///   - andPassword: `String` password of user
  /// - Returns: `Observable<User>`
  func auth(withEmail email: String, andPassword password: String) -> Observable<User>

  /// Register new user
  /// - Parameters:
  ///   - email: `String` email of user
  ///   - password: `String` password of user
  ///   - age: `Int` age of user
  /// - Returns: `Observable<User>`
  func register(withEmail email: String, password: String, andAge age: Int) -> Observable<User>
}

final class UserLocalRepository: UserRepositoring {
  func register(withEmail email: String, password: String, andAge age: Int) -> Observable<User> {
    return Observable.create { observer in
      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        let user = User(id: UUID().uuidString, email: email, password: password, age: age)
        availableUser.append(user)

        observer.onNext(user)
        observer.onCompleted()
      }

      return Disposables.create { }
    }
  }

  func auth(withEmail email: String, andPassword password: String) -> Observable<User> {
    return Observable.create { observer in

      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        guard let user = availableUser.first(where: { $0.email == email && $0.password == password } ) else {
          observer.onError(CustomError.authFailed)
          return
        }

        observer.onNext(user)
        observer.onCompleted()
      }

      return Disposables.create { }
    }
  }
}
