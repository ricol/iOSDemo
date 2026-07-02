//
//  SwiftDelegateDemoViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/6/24.
//

import Foundation

protocol SwiftDelegateDemoViewControllerDelegate {
    func SwiftDelegateDemoViewControllerDidClose()
}

class SwiftDelegateDemoViewControllerDelegateTemplate: SwiftDelegateDemoViewControllerDelegate {
    func SwiftDelegateDemoViewControllerDidClose() {
        print("SwiftDelegateDemoViewControllerDidClose...")
    }
}

class SwiftDelegateDemoViewController: BaseViewController {
    var delegate: SwiftDelegateDemoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "SwiftDelegateDemo"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.SwiftDelegateDemoViewControllerDidClose()
    }
}
