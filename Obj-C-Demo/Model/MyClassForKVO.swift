//
//  MyClassForKVO.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/22.
//

import UIKit

@objc class MyClassForKVO: NSObject {
    @objc var name: String?
    @objc var age: Int = 0 {
        willSet {
            willChangeValue(forKey: "age")
        }
        didSet {
            didChangeValue(forKey: "age")
        }
    }
    
    deinit {
        print("\(self)deinit...")
    }
    
    @objc func observeProperty(o: NSObject) {
        self.addObserver(o, forKeyPath: "name", context: nil)
        self.addObserver(o, forKeyPath: "age", context: nil)
    }
    
    @objc func changeProperty() {
        self.name = "ricol wang"
        self.age = 23
        print("propery changed in swift, but looks like no effect")
    }
    
    override class func automaticallyNotifiesObservers(forKey key: String) -> Bool {
        if key == "age" { return false }
        return super.automaticallyNotifiesObservers(forKey: key)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("value changed for keyPath: \(keyPath) of object: \(object)")
    }
}
