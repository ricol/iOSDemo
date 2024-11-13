//
//  CollectionViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/9/9.
//

import Foundation

class CollectionViewBaseHeaderView: UICollectionReusableView {
    lazy var lblTitle: UILabel = {
        let lblTitle = UILabel(frame: frame)
        self.addSubview(lblTitle)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: self.topAnchor),
            lblTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        lblTitle.textAlignment = .center
        lblTitle.text = ""
        return lblTitle
    }()
}

class GroupHeaderView: CollectionViewBaseHeaderView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.backgroundColor = .orange
    }
}

class GroupHeaderViewAlternative: CollectionViewBaseHeaderView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.backgroundColor = .yellow
    }
}

class SectionHeaderView: CollectionViewBaseHeaderView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.backgroundColor = .red
    }
}

class SectionHeaderViewCollectionTop: CollectionViewBaseHeaderView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.backgroundColor = .green
    }
}

class SectionHeaderViewCollectionBottom: CollectionViewBaseHeaderView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.backgroundColor = .purple
    }
}

class CollectionViewCell: UICollectionViewCell {
//    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var constraintTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    @IBOutlet weak var constraintLeading: NSLayoutConstraint!
    @IBOutlet weak var constraintTrailing: NSLayoutConstraint!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var theTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [constraintTop, constraintBottom, constraintLeading, constraintTrailing].forEach { constraint in
            constraint?.constant = 1
        }
    }
}

class CollectionViewController: BaseViewController {
    var data = [String: [(String, CGFloat?)]]()
    var sizeMapping = [String: (CGFloat, Bool, Bool)]()
    var sections: [String] {
        get {
            return data.keys.sorted()
        }
    }
    enum LayoutType {
        case flowlayout, composelayout
    }
    let itemHeight: CGFloat = 300
    let itemEdgeInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let gapBetweenSpace: CGFloat = 0
    let sectionHeight: CGFloat = 30
    var layoutType = LayoutType.composelayout
    var ignorePredefined = true
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(btnOnTapped))
        let btnRebuildModel = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(btnRebuildModelOnTapped))
        self.navigationItem.rightBarButtonItems = [btn, btnRebuildModel]
        self.theCollectionView.register(GroupHeaderView.self, forSupplementaryViewOfKind: "GroupHeaderView", withReuseIdentifier: "GroupHeaderView")
        self.theCollectionView.register(GroupHeaderViewAlternative.self, forSupplementaryViewOfKind: "GroupHeaderViewAlternative", withReuseIdentifier: "GroupHeaderViewAlternative")
        self.theCollectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: "SectionHeaderView", withReuseIdentifier: "SectionHeaderView")
        self.theCollectionView.register(SectionHeaderViewCollectionTop.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderViewCollectionTop")
        self.theCollectionView.register(SectionHeaderViewCollectionBottom.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "SectionHeaderViewCollectionBottom")
        rebuildModel()
    }
    
    @objc private func btnOnTapped() {
        layoutType = layoutType == .flowlayout ? .composelayout : .flowlayout
        relayout()
    }
    
    @objc private func btnRebuildModelOnTapped() {
        rebuildModel()
    }
    
    private func rebuildModel() {
        print("rebuild model...")
        data.removeAll()
        
        for k in ["a", "b", "c", "d", "e", "f", "g"] {
            let count = Int.random(in: 1...20)
            var value: [(String, CGFloat?)] = []
            for _ in stride(from: 1, to: count, by: 1) {
                value.append((String.randomString(), Int.random(in: 1...10) > 5 ? [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0].randomElement() : nil))
            }
            data[k] = value
        }
        /*
        data["a"] = [(String.randomString(), nil)]
        data["b"] = [(String.randomString(), 0.5),
                     (String.randomString(), 0.5)]
        data["c"] = [(String.randomString(), 0.1),
                     (String.randomString(), 0.2),
                     (String.randomString(), 0.7)]
        data["d"] = [(String.randomString(), 0.1),
                     (String.randomString(), 0.2),
                     (String.randomString(), nil),
                     (String.randomString(), 0.3)]
        data["e"] = [(String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil)]
        data["f"] = [(String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil)]
        data["g"] = [(String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil)]
        data["h"] = [(String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil)]
        data["i"] = [(String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil)]
        data["j"] = [(String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil),
                     (String.randomString(), nil)]
         */
        relayout()
    }
    
    private func relayout() {
        print("layout...")
        sizeMapping.removeAll()
        self.title = layoutType == .composelayout ? "Collection view with compositional layout" : "Collection View with flow layout"
        
        if layoutType == .composelayout {
            if let _ = self.theCollectionView.collectionViewLayout as? UICollectionViewCompositionalLayout {
                
            }else {
                let provider = { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
                    let height: CGFloat = 300
                    let width: CGFloat = 200
                    
                    let item = NSCollectionLayoutItem(layoutSize:
                                                        NSCollectionLayoutSize(widthDimension: .absolute(width),
                                                                               heightDimension: .absolute(height)))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize:
                                                                    NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                           heightDimension: .absolute(height)),
                                                                   subitems: [item])
                    let groupHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(50)), elementKind: "GroupHeaderView", alignment: .bottom)
                    let groupHeaderAlternative = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(50)), elementKind: "GroupHeaderViewAlternative", alignment: .trailing)
                    group.supplementaryItems = [groupHeader, groupHeaderAlternative]
                    
                    let section = NSCollectionLayoutSection(group: group)
                    section.interGroupSpacing = 0 //no effect?
                    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(width), heightDimension: .absolute(50)), elementKind: "SectionHeaderView", alignment: .top)
                    section.boundarySupplementaryItems = [sectionHeader]
        //            section.contentInsets = NSDirectionalEdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50)
                    return section
                }
                let config = UICollectionViewCompositionalLayoutConfiguration()
                config.interSectionSpacing = 10
                let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: provider, configuration: config)
                self.theCollectionView.collectionViewLayout = compositionalLayout
            }
        }else {
            self.theCollectionView.delegate = self
            if let _ = self.theCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                
            }else {
                let flowLayout = UICollectionViewFlowLayout()
                flowLayout.scrollDirection = .vertical
                self.theCollectionView.collectionViewLayout = flowLayout
            }
        }
        self.theCollectionView.dataSource = self
        self.theCollectionView.reloadData()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.relayout()
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[sections[section]]?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell_ID", for: indexPath) as? CollectionViewCell {
            let s = indexPath.section
            let r = indexPath.row
            if s < sections.count, let value = data[sections[s]], r < value.count {
                let row = value[r]
                cell.clearBG()
                cell.theTitle.text = row.0
                cell.theTitle.textColor = .black
                cell.viewBG.backgroundColor = row.1 != nil ? .red : .blue
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let total = data[sections[indexPath.section]]?.count ?? 0
        if kind == UICollectionView.elementKindSectionHeader {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderViewCollectionTop", for: indexPath) as! SectionHeaderViewCollectionTop
            v.lblTitle.text = "SectionHeaderTop \(indexPath) (\(total))"
            return v
        }else if kind == UICollectionView.elementKindSectionFooter {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderViewCollectionBottom", for: indexPath) as! SectionHeaderViewCollectionBottom
            v.lblTitle.text = "SectionHeaderBottom \(indexPath)"
            return v
        }else {
            let v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath) as! CollectionViewBaseHeaderView
            if let header = v as? GroupHeaderView {
                header.lblTitle.text = "GroupHeader (\(indexPath)"
            }else if let header = v as? GroupHeaderViewAlternative {
                header.lblTitle.text = "GroupHeader(Alter) \(indexPath)"
            }else if let header = v as? SectionHeaderView {
                header.lblTitle.text = "SectionHeader \(indexPath)"
            }
            return v
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return itemEdgeInset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return gapBetweenSpace
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getExpectedWidthFor(indexPath: indexPath).0, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: sectionHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: sectionHeight)
    }
    
    private func getExpectedWidthFor(indexPath: IndexPath) -> (CGFloat, Bool, Bool) {
        
        func getPreviousTotal(indexPath: IndexPath) -> CGFloat {
            var previousTotal: CGFloat = 0
            for i in (0..<row) {
                let value = getExpectedWidthFor(indexPath: IndexPath(row: i, section: section))
                if value.1 { previousTotal = 0 }
                previousTotal += value.0 + itemEdgeInset.left + itemEdgeInset.right
            }
            return previousTotal
        }
        
        print("\(indexPath) getExpectedWidthFor...")
        let row = indexPath.row
        let section = indexPath.section
        if let value = sizeMapping["\(section)_\(row)"] {
            print("\(indexPath) find in mapping.")
            return value
        }
        let containerWidth = self.theCollectionView.frame.width
        var value: CGFloat = containerWidth / 3
        let previousTotal = getPreviousTotal(indexPath: indexPath)
        
        print("\(indexPath) calculating...previous: \(previousTotal) + value: \(value) = \(previousTotal + value) containerWidth: \(containerWidth)")
        var newLine = false
        
        var predefined = false
        if !ignorePredefined, let ratio = data[sections[section]]?[row].1 {
            let predefinedWidth = ratio * containerWidth
            if predefinedWidth <= containerWidth {
                value = predefinedWidth
                if predefinedWidth + previousTotal > containerWidth {
                    newLine = true
                    print("\(indexPath) new line with predefined width [\(value)]")
                }else {
                    print("\(indexPath) same line with predefined width [\(value)]")
                }
                predefined = true
            }
        }
        
        if !predefined {
            if previousTotal + value > containerWidth {
                //next line
                //decide whether should cover the whole available space
                newLine = true
                if let values = data[sections[section]], row >= values.count - 1 { //is the last row of the section
                    value = containerWidth
                    print("\(indexPath) new line cover all space [\(value)]")
                }else {
                    print("\(indexPath) new line normal size [\(value)]")
                }
            }else {
                //same line
                if let values = data[sections[section]], row >= values.count - 1 { // is the last row of the section
                    value = containerWidth - previousTotal
                    print("\(indexPath) same line cover all remaining space [\(value)]")
                }else {
                    print("\(indexPath) same line normal size [\(value)]")
                }
            }
        }
        
        value -= itemEdgeInset.left + itemEdgeInset.right
        let result = (value, newLine, predefined)
        sizeMapping["\(section)_\(row)"] = result
        return result
    }
}
