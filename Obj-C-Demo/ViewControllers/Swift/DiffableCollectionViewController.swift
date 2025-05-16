//
//  DiffableCollectionViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/5/15.
//

class DiffableCollectionViewController: BaseViewController {
    enum Section: Hashable {
        case main
        case other
        
        var title: String {
            switch self {
            case .main:
                return "Main"
            case .other:
                return "Other"
            }
        }
    }

    struct Item: Hashable {
        let id: UUID
        let title: String
        // Add other properties as needed
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CollectionView(DiffableDataSource)"
        
        weak var weakSelf = self
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Add") { _ in weakSelf?.btnAddOnTapped() },
            UIAction(title: "Delete") { _ in weakSelf?.btnRemoveOnTapped() },
            UIAction(title: "Reset") { _ in weakSelf?.btnResetOnTapped() }
        ])
        let btnMenu = UIBarButtonItem(title: "Menu", menu: menu)
        self.navigationItem.rightBarButtonItem = btnMenu
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.register(
            SectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
        )
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { cell, indexPath, item in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                               for: indexPath,
                                                               item: item)
        }
        
        unowned let unownedSelf = self
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let section = unownedSelf.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                for: indexPath
            ) as? SectionHeaderReusableView
            view?.titleLabel.text = section.title
            return view
        }
        
        btnResetOnTapped()
    }
    
    @objc func btnResetOnTapped() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems([
            Item(id: UUID(), title: "First Item"),
            Item(id: UUID(), title: "Second Item"),
            Item(id: UUID(), title: "Third Item")
        ])
        snapshot.appendSections([.other])
        snapshot.appendItems([
            Item(id: UUID(), title: "A Item"),
            Item(id: UUID(), title: "B Item"),
            Item(id: UUID(), title: "C Item")
        ])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func btnAddOnTapped() {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([Item(id: UUID(), title: "A Item")], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func btnRemoveOnTapped() {
        var snapshot = dataSource.snapshot()
        let itemsToDelete = snapshot.itemIdentifiers.filter { $0.title.contains("A") }
        snapshot.deleteItems(itemsToDelete)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        // Supplementary header view setup
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

class SectionHeaderReusableView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: SectionHeaderReusableView.self)
    }

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(
            ofSize: UIFont.preferredFont(forTextStyle: .title1).pointSize,
            weight: .bold
        )
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh, for: .horizontal
        )
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(
                    equalTo: leadingAnchor,
                    constant: 5
                ),
                titleLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: trailingAnchor,
                    constant: -5
                ),
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(
                    equalTo: readableContentGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(
                    lessThanOrEqualTo: readableContentGuide.trailingAnchor),
            ])
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            ),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
