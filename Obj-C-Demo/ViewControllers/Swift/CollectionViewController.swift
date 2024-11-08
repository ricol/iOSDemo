//
//  CollectionViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/9/9.
//

import Foundation

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var theTitle: UILabel!
}

class CollectionViewController: BaseViewController, UICollectionViewDataSource {
    var data = [String: [(String, UIImage)]]()
    var sections: [String] {
        get {
            return data.keys.sorted()
        }
    }
    enum LayoutType {
        case flowlayout, composelayout
    }
    var layoutType = LayoutType.composelayout
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(btnOnTapped))
        self.navigationItem.rightBarButtonItem = btn
        reload()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[sections[section]]?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cell for section: \(indexPath.section), row: \(indexPath.row), item: \(indexPath.item)...")
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell_ID", for: indexPath) as? CollectionViewCell {
            let s = indexPath.section
            let r = indexPath.row
            if s < sections.count, let value = data[sections[s]], r < value.count {
                let row = value[r]
                cell.theImageView.image = row.1
                cell.theTitle.text = row.0
                cell.randomBorderColor()
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    @objc private func btnOnTapped() {
        layoutType = layoutType == .flowlayout ? .composelayout : .flowlayout
        reload()
    }
    
    private func reload() {
        self.title = layoutType == .composelayout ? "Collection view with compositional layout" : "Collection View with flow layout"
        data = ["Liusisi": [(String.randomString(), Constants.liusisi[0]),
                            (String.randomString(), Constants.liusisi[1]),
                            (String.randomString(), Constants.liusisi[2]),
                            (String.randomString(), Constants.liusisi[3])],
                "Wang": [(String.randomString(), Constants.liusisi[4]),
                         (String.randomString(), Constants.liusisi[5]),
                         (String.randomString(), Constants.liusisi[6]),
                         (String.randomString(), Constants.liusisi[0]),
                         (String.randomString(), Constants.liusisi[1]),
                         (String.randomString(), Constants.liusisi[2])],
                "Ricol": [(String.randomString(), Constants.liusisi[0])]]
        
        let provider = { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(100),
                                                   heightDimension: .absolute(100))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [NSCollectionLayoutItem(layoutSize: itemSize)])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0 //no effect?
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 50
        let compositionalLayout = UICollectionViewCompositionalLayout(sectionProvider: provider, configuration: config)
//        self.theCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell_ID")
        
        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(width: 100, height: 100)
//        flowLayout.estimatedItemSize = CGSize(width: 100, height: 100)
        self.theCollectionView.collectionViewLayout = layoutType == .composelayout ? compositionalLayout : flowLayout
        self.theCollectionView.dataSource = self
        if layoutType == .flowlayout {
            self.theCollectionView.delegate = self
        }
        self.theCollectionView.reloadData()
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            
            return UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
        }
        // Method 2
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            
            return 5
        }
        // Method 3
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            
            return 10
        }
        //Method 4
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let collectionViewWidth = collectionView.frame.width
            let collectionViewHeight =  collectionView.frame.height
            
            let cellWidth = (collectionViewWidth - 30 ) / 3
            let cellHeight = collectionViewHeight * 0.5
            
            return CGSize(width: cellWidth , height: cellHeight)
            
        }
}
