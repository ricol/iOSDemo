//
//  MemoryTestViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/6/29.
//

import UIKit

class MemoryTestViewController: ListTableViewController {
    lazy var oc_object = MyMemoryDemoObject()
    var timer: Timer?
    
    @objc func testOCObjectWithStrongSelf() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: DispatchWorkItem(block: {
            self.oc_object.update() //strong self.
        }))
        //will continue fetch the content. vc won't be released right away.
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func testOCObjectWithWeakSelf() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: DispatchWorkItem(block: { [weak self] in
            self?.oc_object.update() //weak self.
        }))
        //will release the vc right away
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func testOCObjectWithWeakSelfWithGuard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: DispatchWorkItem(block: { [weak self] in
            guard let self else { return }
            self.oc_object.update() //weak self.
        }))
        //will release the vc right away
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func testOCObjectWithWeakSelfWithRetain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: DispatchWorkItem(block: { [weak self] in
            let self_retain = self
            self_retain?.oc_object.update() //weak self.
        }))
        //will release the vc right away
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func testLocalOCObjectWithStrong() {
        let oc_object = MyMemoryDemoObject()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: DispatchWorkItem(block: {
            oc_object.update() //strong oc_object.
        }))
        //will continue fetch the content. vc won't be released right away.
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func testLocalOCObjectWithWeak() {
        let oc_object = MyMemoryDemoObject()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: DispatchWorkItem(block: { [weak oc_object] in
            oc_object?.update() //weak oc_object.
        }))
        //will release the oc_object right away
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func testLocalOCObjectWithWeakButGuard() {
        let oc_object = MyMemoryDemoObject()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: DispatchWorkItem(block: { [weak oc_object] in
            guard let oc_object else { return }
            oc_object.update() //weak oc_object.
        }))
        //will release the oc_object right away
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func testLocalOCObjectWithWeakButRetain() {
        let oc_object = MyMemoryDemoObject()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: DispatchWorkItem(block: { [weak oc_object] in
            let oc_retain = oc_object
            oc_retain?.update() //weak oc_object.
        }))
        //will release the oc_object right away
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func testScheduledTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            print("timer...") //as long as the block doesn't refence the self, vc will release after popup.
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func testNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifcation(notif:)), name: .myNotif, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: DispatchWorkItem(block: {
            print("post notification...")
            NotificationCenter.default.post(name: .myNotif, object: nil)
        }))
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func testNotificationCenterWithBlock() {
        NotificationCenter.default.addObserver(forName: .myNotif, object: nil, queue: .main) { notif in
            print("notification received: \(notif)")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: DispatchWorkItem(block: {
            print("post notification...")
            NotificationCenter.default.post(name: .myNotif, object: nil)
        }))
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNotifcation(notif: Notification) {
        print("notif: \(notif)")
    }
    
    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}
