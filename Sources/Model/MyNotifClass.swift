//
//  MyNotifClass.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/22.
//

import Foundation

@objc class MyNotifClass: NSObject {
    override init() {
        super.init()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "mynotif"), object: nil, queue: nil) { notif in
            print("[\(Thread.current)]notif: \(notif)")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotif(_:)), name: Notification.Name(rawValue: "mynotif"), object: "test")
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotif(_:)), name: Notification.Name(rawValue: "mynotif"), object: nil)
    }
    
    @objc func handleNotif(_ notif: Notification) {
        print("[\(self)]\(Thread.current)]notif: \(notif)")
    }
    
    @objc func testNotif() {
        DispatchQueue.global().async {
            print("being testNotif...")
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "mynotif"), object: nil, userInfo: nil))
            print("end testNotif.")
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    @objc func testNotificationQueue() {
        NotificationQueue.default.enqueue(Notification(name: Notification.Name(rawValue: "mynotif")), postingStyle: .now)
    }
    
    deinit {
        print("[\(self)]deinit...")
    }
}
