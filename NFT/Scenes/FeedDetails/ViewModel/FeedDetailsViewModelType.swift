//
//  FeedDetailsViewModelType.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import RxSwift
import UIKit

/// Protocol for FeedDetailsViewModelType setters
protocol FeedDetailsViewModelInputs {
  func bind(collectionView view: UICollectionView)
}

/// Protocol for FeedDetailsViewModelType getters
protocol FeedDetailsViewModelOutputs {
}

protocol FeedDetailsViewModelType {
  /// inputs are used to give data to view model
  var inputs: FeedDetailsViewModelInputs { get }
  /// getters are used to recieve data from view model
  var outputs: FeedDetailsViewModelOutputs { get }
}

extension FeedDetailsViewModel: FeedDetailsViewModelType {
  var inputs: FeedDetailsViewModelInputs { return self }
  var outputs: FeedDetailsViewModelOutputs { return self }
}

