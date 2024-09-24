//
//  CountVC.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/4/7.
//

import Foundation

@objc class CountVC: NSObject {
    @objc static let shared = CountVC()
    var countMapping = NSMapTable<NSString, NSNumber>()
    @objc func alloc(vc: NSObject) {
        increaseCountFor(vc: vc)
        showCount(msg: "created", vc: vc)
    }
    
    @objc func dealloc(vc: NSObject) {
        decreaseCountFor(vc: vc)
        showCount(msg: "deinit", vc: vc)
    }

    private func increaseCountFor(vc: NSObject) {
        let key: NSString = NSStringFromClass(vc.classForCoder) as NSString
        if countMapping.object(forKey: key) == nil {
            countMapping.setObject(NSNumber(integerLiteral: 0), forKey: key)
        }
        if let k = countMapping.object(forKey: key) {
            let n = NSNumber(integerLiteral: k.intValue + 1)
            countMapping.setObject(n, forKey: key)
        }
    }
    
    private func decreaseCountFor(vc: NSObject) {
        let key: NSString = NSStringFromClass(vc.classForCoder) as NSString
        if let k = countMapping.object(forKey: key) {
            let n = NSNumber(integerLiteral: k.intValue - 1)
            if n.intValue <= 0 { countMapping.removeObject(forKey: key) }
            else { countMapping.setObject(n, forKey: key) }
        }
    }
    
    private func showCount(msg: String, vc: NSObject) {
        let key: NSString = NSStringFromClass(vc.classForCoder) as NSString
        var count = 0
        if let k = countMapping.object(forKey: key) { count = k.intValue }
        print("[\(vc)]\(msg)...[\(count)]")
    }
}
