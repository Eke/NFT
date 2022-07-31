//
//  CollectionViewLaoutBuilder.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import UIKit

class CollectionViewLaoutBuilder {
  static func standartSection() -> NSCollectionLayoutSection {
    // Item
    let inset: CGFloat = Spacing.spacing7
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    // Group
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Spacing.spacing7, bottom: 0, trailing: Spacing.spacing7)

    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = inset
    section.contentInsets = NSDirectionalEdgeInsets(top: Spacing.spacing7, leading: 0, bottom: Spacing.spacing7, trailing: 0)
    return section
  }

  static func horizontalPills(scroll: Bool = true, hasHeader: Bool = false) -> NSCollectionLayoutSection {
    // Item
    let inset: CGFloat = Spacing.spacing7
    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    // Group
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(34))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.interItemSpacing = .fixed(Spacing.spacing8)

    if !scroll {
      group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(0), trailing: .fixed(0), bottom: .fixed(Spacing.spacing7))
    }
    let globalHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(64.0))
    let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: globalHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    // Set true or false depending on the desired behavior
    globalHeader.pinToVisibleBounds = false

    // Section
    let section = NSCollectionLayoutSection(group: group)
    section.boundarySupplementaryItems = hasHeader ? [globalHeader] : []
    if scroll {
      section.orthogonalScrollingBehavior = .continuous
    }
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: inset, bottom: Spacing.spacing7, trailing: 0)
    return section
  }
}
