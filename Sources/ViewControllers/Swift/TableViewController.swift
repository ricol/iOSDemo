//
//  TableViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/9/9.
//

import Foundation

class TableViewCell: UITableViewCell {
    @IBOutlet weak var theTitle: UILabel!
    @IBOutlet weak var theImageView: UIImageView!
}

class TableViewController: BaseViewController, UITableViewDataSource {
    @IBOutlet weak var theTableView: UITableView!
    
    var data = [String: [(String, UIImage)]]()
    var sections: [String] {
        get {
            return data.keys.sorted()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Table View Demo"
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
        self.theTableView.register(UINib(nibName: "ImageTitleTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTitleTableViewCell")
        self.theTableView.dataSource = self
        self.theTableView.delegate = self
        self.theTableView.reloadData()
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[sections[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTitleTableViewCell", for: indexPath) as? ImageTitleTableViewCell {
            if let row = data[sections[indexPath.section]]?[indexPath.row] {
                cell.theTitle.text = row.0
                cell.theImageView.image = row.1
                cell.randomBorderColor()
                return cell
            }
        }
        return ImageTitleTableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}

extension TableViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
