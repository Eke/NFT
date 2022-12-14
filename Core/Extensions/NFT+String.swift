//
//  NFT+String.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import Foundation


extension String {
  var isValidEmail: Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: self)
  }

  var isValidPassword: Bool {
    6...16 ~= self.count
  }

  var isValidAge: Bool {
    guard let int = Int(self) else {
      return false
    }

    return 18...90 ~= int
  }
}
