//
//  FeedDetailsController.swift
//  NFT
//
//  Created by Erekle Meskhi on 31.07.22.
//

import UIKit
import RxSwift

class FeedDetailsController: BaseViewController {
  override var hasDefaultBackground: Bool {
    return false
  }

  private let viewModel: FeedDetailsViewModelType

  private let compositionalLayout: UICollectionViewCompositionalLayout = {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
      let sectionLayoutKind = FeedDetailsViewModel.FeedDetailsSection.allCases[sectionIndex]
      switch sectionLayoutKind {
      case .general:
        return CollectionViewLaoutBuilder.standartSection()
      case .tags, .specs:
        return CollectionViewLaoutBuilder.horizontalPills(hasHeader: sectionLayoutKind == .specs)
      case .stats:
        return CollectionViewLaoutBuilder.horizontalPills(scroll: false)
      }
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
  /// - Parameter vm: instance of `FeedDetailsViewModelType`
  init(withViewModel vm: FeedDetailsViewModelType) {
    viewModel = vm
    super.init(nibName: nil, bundle: nil)

    title = NSLocalizedString("feed".uppercased(), comment: "")

    viewModel.inputs.bind(collectionView: collectionView)
  }

  deinit {
    print("⬅️🗑 deinit FeedDetailsController")
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
