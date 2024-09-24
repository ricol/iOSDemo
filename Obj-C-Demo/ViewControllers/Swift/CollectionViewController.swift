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
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Collection View Demo"
        data = ["Liusisi": [(String.randomString(), Constants.liusisi[0]),
                            (String.randomString(), Constants.liusisi[1]),
                            (String.randomString(), Constants.liusisi[2]),
                            (String.randomString(), Constants.liusisi[3]),
                            (String.randomString(), Constants.liusisi[4])],
                "Wang": [(String.randomString(), Constants.liusisi[5]),
                                    (String.randomString(), Constants.liusisi[6]),
                                    (String.randomString(), Constants.liusisi[0]),
                                    (String.randomString(), Constants.liusisi[1]),
                                    (String.randomString(), Constants.liusisi[2])]]
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        self.theCollectionView.collectionViewLayout = layout
        
        let provider = { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .estimated(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [NSCollectionLayoutItem(layoutSize: groupSize)])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        let advancedLayout = UICollectionViewCompositionalLayout(sectionProvider: provider, configuration: config)
//        self.theCollectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell_ID")
        self.theCollectionView.collectionViewLayout = advancedLayout
        self.theCollectionView.dataSource = self
        self.theCollectionView.reloadData()
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
}
