//
//  FeedController.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import UIKit
import SnapKit
import RxSwift

class FeedController: BaseViewController {
  override var hasDefaultBackground: Bool {
    return false
  }

  private let disposeBag = DisposeBag()

  private let viewModel: FeedViewModelType

  private let compositionalLayout: UICollectionViewCompositionalLayout = {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
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
      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: Spacing.spacing7, trailing: 0)
      return section
    }

    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .vertical

    layout.configuration = config

    return layout
  }()

  private lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
    view.backgroundColor = .clear
    view.backgroundView = BaseControllerView(frame: .zero)
    view.showsVerticalScrollIndicator = false
    return view
  }()

  // MARK: Lifecycle

  /// Default initializer
  /// - Parameter vm: instance of `FeedViewModelType`
  init(withViewModel vm: FeedViewModelType) {
    viewModel = vm
    super.init(nibName: nil, bundle: nil)

    title = NSLocalizedString("feed".uppercased(), comment: "")

    viewModel.inputs.bind(collectionView: collectionView)
  }

  deinit {
    print("⬅️🗑 deinit FeedController")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()
    setup()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.largeTitleDisplayMode = .automatic
  }


  private func setup() {
    view.addSubview(collectionView)
    layout()
  }

  private func layout() {
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
