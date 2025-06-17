//
//  ListTableViewController.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/4/11.
//

import UIKit

class ListTableViewController: BaseTableViewController {
	
	lazy var theIndicator: UIActivityIndicatorView = {
		let v = UIActivityIndicatorView(style: .medium)
		v.hidesWhenStopped = true
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: theIndicator)
	}

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let text = cell?.textLabel?.text {
            let sel: Selector = Selector("test\(text)")
            if self.responds(to: sel) {
                print("perform selector: \(sel.description)")
                self.perform(sel)
            }else {
                print("unknown selector: \(sel.description)")
            }
        }
    }

}
