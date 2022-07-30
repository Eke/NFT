//
//  Navigator.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit.UIViewController

protocol Navigator: AnyObject {
  associatedtype Destination

  func navigate(to destination: Destination, withCofniguration config: NavigatorConfigurable)
}
