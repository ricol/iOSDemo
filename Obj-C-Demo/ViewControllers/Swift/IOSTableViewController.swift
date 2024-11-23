//
//  IOSTableViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/9/27.
//

import UIKit
import SwiftUI

class IOSTableViewController: ListTableViewController {
    @objc func testSwiftUI() {
        let hosting = UIHostingController(rootView: SwiftUIMainView())
        self.navigationController?.pushViewController(hosting, animated: true)
    }
}
