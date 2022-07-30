//
//  UserRepository.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import Foundation
import RxSwift

enum CustomError: Error {
  case userNotFound
}

var availableUser = [
  User(id: UUID().uuidString, email: "demo@demo.com", password: "123456", age: 30)
]

protocol UserRepositoring {
  /// Auth user with an email and password
  /// - Parameters:
  ///   - email: `String` email of user
  ///   - andPassword: `String` password of user
  func auth(withEmail email: String, andPassword password: String) -> Observable<User>
}

final class UserLocalRepository: UserRepositoring {
  func auth(withEmail email: String, andPassword password: String) -> Observable<User> {
    return Observable.create { observer in

      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
        guard let user = availableUser.first(where: { $0.email == email && $0.password == password } ) else {
          observer.onError(CustomError.userNotFound)
          return
        }

        observer.onNext(user)
        observer.onCompleted()
      }

      return Disposables.create { }
    }
  }
}
