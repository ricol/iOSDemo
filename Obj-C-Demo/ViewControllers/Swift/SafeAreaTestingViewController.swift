//
//  SafeAreaTestingViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2026/3/10.
//

class SafeAreaView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("[\(self)]\n====== \nframe: \(self.frame) bounds: (\(self.bounds) safearea: \(self.safeAreaInsets)")
        super.touchesBegan(touches, with: event)
        var hasSafeAreaInsets = false
        if self.safeAreaInsets.left > 0 || self.safeAreaInsets.right > 0 || self.safeAreaInsets.bottom > 0 || self.safeAreaInsets.top > 0 {
            hasSafeAreaInsets = true
        }
        self.layer.borderColor = hasSafeAreaInsets ? UIColor.red.cgColor : UIColor.black.cgColor
        self.layer.borderWidth = hasSafeAreaInsets ? 5 : 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: DispatchWorkItem(block: {
            self.layer.borderColor = nil
            self.layer.borderWidth = 0
        }))
    }
}

class SafeAreaTestingViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("[\(self)]")
        super.touchesBegan(touches, with: event)
    }
}
