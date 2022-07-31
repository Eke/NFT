//
//  FeedViewModel.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import UIKit
import RxSwift
import Resolver
import RxRelay
import SDWebImage

class FeedViewModel: NSObject, FeedViewModelInputs, FeedViewModelOutputs {
  typealias DataSource = UICollectionViewDiffableDataSource<Int, Int>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Int>

  private let disposeBag = DisposeBag()

  @Injected private var pixabayAPI: ApiClient<PixabayService>
  @Injected private var navigator: FeedNavigator

  // MARK: LifeCycle

  private let feedData: BehaviorRelay<[FeedItem]> = BehaviorRelay<[FeedItem]>(value: [])

  private weak var collectionView: UICollectionView?

  private var currentPage = 1
  private var isLoading = false

  /// CollectionView data source instance. Used to init cells
  private var dataSource: DataSource?

  override init() {
    super.init()
  }

  deinit {
    print("⬅️🗑 deinit FeedViewModel")
  }

  // MARK: Inputs
  func bind(collectionView view: UICollectionView) {
    collectionView = view
    collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "feedcell")
    collectionView?.delegate = self

    dataSource = makeDataSource()

    loadFeed(page: currentPage)
  }

  // MARK: Private implementations

  /// Creates data source instance
  /// - Returns: DataSource instance or nil
  private func makeDataSource() -> DataSource? {
    guard let view = collectionView else {
      return nil
    }

    let dataSource = DataSource(collectionView: view) { [weak self] collectionView, indexPath, itemIdentifier in
      guard let weakSelf = self else {
        return nil
      }
      return weakSelf.cell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)
    }

    return dataSource
  }

  /// Creates Cell. This in future may be moved to Cell factory
  /// - Parameters:
  ///   - collectionView: instance of `UICollectionView`
  ///   - indexPath: `IndexPath` of item
  ///   - item: `AnyHashable` item
  /// - Returns: returns `Optional UICollectionViewCell`
  private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Int) -> UICollectionViewCell? {
    guard let model = feedData.value.first(where: { $0.id == item }) else {
      return nil
    }

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedcell", for: indexPath)
    cell.contentConfiguration = cell.feedConfiguration(forItem: model)

    return cell
  }

  private func loadFeed(page: Int) {
    isLoading = true
    _ = pixabayAPI.request(.getFeed(page: page), mapTo: FeedResponse.self)
      .withUnretained(self)
      .subscribe(onNext: { owner, data in
        // Little bit ugly fix. Api sometimes returns same elements which is not so good for diffable data source
        let unique = data.hits.filter { item in !owner.feedData.value.contains(where: { item.id == $0.id }) }

        let newData = owner.feedData.value + unique
        owner.feedData.accept(newData)
        owner.didReceive(feedData: unique)
        owner.currentPage = page
      }, onError: { error in
        print(error)
      }, onDisposed: { [weak self] in
        guard let strongSelf = self else {
          return
        }
        strongSelf.isLoading = false
      })
  }

  private func didReceive(feedData: [FeedItem]) {
    guard let source = dataSource else {
      return
    }

    var snapshot = source.snapshot()

    if !snapshot.sectionIdentifiers.contains(where: { $0 == 0 }) {
      snapshot.appendSections([0])
    }

    let data = feedData.map { $0.id }
    snapshot.appendItems(data, toSection: 0)

    source.apply(snapshot, animatingDifferences: false)
  }
}


extension FeedViewModel: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if isLoading {
      return
    }

    if feedData.value.count - indexPath.row <= 10 {
      loadFeed(page: currentPage + 1)
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    navigator.navigate(
      to: .details(item: feedData.value[indexPath.row]),
      withCofniguration: NavigatorConfig(
        navigationType: .modal(style: .automatic)
      )
    )
  }
}
