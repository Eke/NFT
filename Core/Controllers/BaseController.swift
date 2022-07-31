//
//  BaseController.swift
//  NFT
//
//  Created by Erekle Meskhi on 30.07.22.
//

import UIKit

/// Base UIViewController Subclass. recomended to use everywhere
open class BaseViewController: UIViewController {
  var hasDefaultBackground: Bool { true }

  open override func loadView() {
    guard hasDefaultBackground else {
      self.view = UIView()
      return
    }

    let customView = UIView()
    self.view = customView

    let backgroundView = BaseControllerView(frame: .zero)
    customView.addSubview(backgroundView)
  }
  
}
