//
//  MainNavigationController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/7/5.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.isNavigationBarHidden = false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let topViewController {
//            print("[\(self)]supportedInterfaceOrientations: \(topViewController) -> \(topViewController.supportedInterfaceOrientations.getDisplay())")
            return topViewController.supportedInterfaceOrientations
        }
//        print("[\(self)] .all")
        return .all
//        return .portrait
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if let preferredStatusBarStyle = self.topViewController?.preferredStatusBarStyle {
            print("[\(self)]get preferredStatusBarStyle: \(preferredStatusBarStyle)")
            return preferredStatusBarStyle
        }
        print("[\(self)]preferredStatusBarStyle: default")
        return .default
    }
}
