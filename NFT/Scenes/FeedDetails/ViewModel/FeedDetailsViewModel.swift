//
//  FeedDetailsViewModel.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import UIKit
import RxSwift
import Resolver
import RxRelay
import SDWebImage

class FeedDetailsViewModel: NSObject, FeedDetailsViewModelInputs, FeedDetailsViewModelOutputs {
  enum FeedDetailsRow: Hashable {
    case photo
    case pill(name: String, icon: String? = nil, backgroundColor: UIColor? = nil, textColor: UIColor? = nil)
  }

  enum FeedDetailsSection: Hashable, CaseIterable {
    case general
    case tags
    case specs
    case stats

    var title: String? {
      switch self {
      case .general:
        return nil
      case .tags:
        return "Tags"
      case .specs:
        return "Specifications"
      case .stats:
        return "Stats"
      }
    }
  }

  typealias DataSource = UICollectionViewDiffableDataSource<FeedDetailsSection, FeedDetailsRow>
  typealias Snapshot = NSDiffableDataSourceSnapshot<FeedDetailsSection, FeedDetailsRow>

  private let disposeBag = DisposeBag()

  // MARK: LifeCycle

  private weak var collectionView: UICollectionView?

  /// CollectionView data source instance. Used to init cells
  private var dataSource: DataSource?

  let feedItem: FeedItem

  init(withItem item: FeedItem) {
    feedItem = item
    super.init()
  }

  deinit {
    print("⬅️🗑 deinit FeedDetailsViewModel")
  }

  // MARK: Inputs
  func bind(collectionView view: UICollectionView) {
    collectionView = view
    collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "detailsCell")
    collectionView?.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)

    dataSource = makeDataSource()

    apply()
  }

  // MARK: Private implementations

  /// Creates data source instance
  /// - Returns: DataSource instance or nil
  private func makeDataSource() -> DataSource? {
    guard let view = collectionView else {
      return nil
    }

    let dataSource = DataSource(collectionView: view) { [weak self] collectionView, indexPath, itemIdentifier in
      guard let strongSelf = self else {
        return nil
      }

      let cell = strongSelf.cell(collectionView: collectionView, indexPath: indexPath, item: itemIdentifier)

      return cell
    }

    dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
      guard let weakSelf = self else {
        return nil
      }
      return weakSelf.supplementary(collectionView: collectionView, kind: kind, indexPath: indexPath)
  }

    return dataSource
  }

  /// Creates Cell. This in future may be moved to Cell factory
  /// - Parameters:
  ///   - collectionView: instance of `UICollectionView`
  ///   - indexPath: `IndexPath` of item
  ///   - item: `AnyHashable` item
  /// - Returns: returns `Optional UICollectionViewCell`
  private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: FeedDetailsRow) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCell", for: indexPath)
    switch item {
    case .photo:
      cell.contentConfiguration = cell.feedConfiguration(forItem: feedItem)
    case .pill(let name, let icon, let backgroundColor, let textColor):
      cell.contentConfiguration = cell.pillConfiguration(title: name, icon: icon, backgroundColor: backgroundColor, textColor: textColor)
    }
    return cell
  }

  private func apply() {
    guard let source = dataSource else {
      return
    }

    var snapshot = source.snapshot()

    if snapshot.sectionIdentifiers.isEmpty {
      snapshot.appendSections(FeedDetailsSection.allCases)
    }

    for section in snapshot.sectionIdentifiers {
      switch section {
      case .general:
        snapshot.appendItems([.photo], toSection: section)
      case .tags:
        let tags = Set(feedItem.tags.components(separatedBy: ","))
          .map { item in FeedDetailsRow.pill(name: item, icon: "tag.fill", backgroundColor: .primary1) }
        snapshot.appendItems(tags, toSection: .tags)
      case .specs:
        let specs: [FeedDetailsRow] = [
          .pill(name: "Type: \(feedItem.type)", icon: "photo.circle.fill", backgroundColor: .primary4, textColor: .neutral2),
          .pill(name: "\(feedItem.imageWidth)px / \(feedItem.imageHeight)px", icon: "aspectratio.fill", backgroundColor: .secondary4, textColor: .neutral2)
        ]
        snapshot.appendItems(specs, toSection: .specs)
      case .stats:
        let stats: [FeedDetailsRow] = [
          .pill(name: "\(feedItem.views)", icon: "eye.circle", backgroundColor: .secondary2, textColor: .neutral2),
          .pill(name: "\(feedItem.likes)", icon: "heart.fill", backgroundColor: .primary3),
          .pill(name: "\(feedItem.comments)", icon: "bubble.left.circle", backgroundColor: .secondary3, textColor: .neutral2),
          .pill(name: "\(feedItem.downloads)", icon: "square.and.arrow.down.fill", backgroundColor: .primary1),
          .pill(name: "\(feedItem.collections)", icon: "star.circle", backgroundColor: .primary2),
        ]
        snapshot.appendItems(stats, toSection: .stats)
      }
    }

    source.apply(snapshot, animatingDifferences: false)
  }

  private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
    let section = FeedDetailsViewModel.FeedDetailsSection.allCases[indexPath.section]
    guard let title = section.title else {
      return UICollectionReusableView()
    }

    switch kind {
    case UICollectionView.elementKindSectionHeader:
      guard let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: SectionHeaderView.reuseIdentifier,
        for: indexPath
      ) as? SectionHeaderView else {
        return nil
      }
      header.set(title: title)
      return header
    default:
      return nil
    }
  }
}
