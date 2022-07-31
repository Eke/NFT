//
//  FeedViewModelType.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import RxSwift
import UIKit

/// Protocol for FeedViewModelType setters
protocol FeedViewModelInputs {
  func bind(collectionView view: UICollectionView)
}

/// Protocol for FeedViewModelType getters
protocol FeedViewModelOutputs {
}

protocol FeedViewModelType {
  /// inputs are used to give data to view model
  var inputs: FeedViewModelInputs { get }
  /// getters are used to recieve data from view model
  var outputs: FeedViewModelOutputs { get }
}

extension FeedViewModel: FeedViewModelType {
  var inputs: FeedViewModelInputs { return self }
  var outputs: FeedViewModelOutputs { return self }
}
