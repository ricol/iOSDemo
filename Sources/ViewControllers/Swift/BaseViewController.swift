//
//  BaseViewController.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/25.
//

import UIKit

@MainActor
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        CountVC.shared.alloc(vc: self)
    }

    @MainActor
    deinit {
        CountVC.shared.dealloc(vc: self)
    }
}
