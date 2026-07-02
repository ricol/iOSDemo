//
//  MyNotificationCenter.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/8/2.
//

import Foundation

class MyNotificationCenter: NSObject, UNUserNotificationCenterDelegate {
    @objc func registerNotification() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
                    .requestAuthorization(options: [.alert, .sound, .badge]) {
                        granted, error in
                        print("Permission granted: \(granted)")
                    }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive...\(response)")
        completionHandler()
        Utils.showDialog(title: "didReceive", msg: "title: \(response.notification.request.content.title)\nbody: \(response.notification.request.content.body)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent...\(notification)")
        Utils.showDialog(title: "willPresent", msg: "\(notification)")
        completionHandler(.banner)
    }
    
    @objc func handleNotification(data: [String: Any])
    {
        if data.isEmpty {
            Utils.showDialog(msg: "no data")
        }else {
            if let notif = data[UIApplication.LaunchOptionsKey.remoteNotification.rawValue] as? [String: Any] {
                print("\(notif)")
                if let aps = notif["aps"] as? [String: Any] {
                    if let alert = aps["alert"] as? [String: Any] {
                        Utils.showDialog(title: alert["title"] as? String ?? "", msg: alert["message"] as? String ?? "")
                    }else {
                        Utils.showDialog(msg: "no")
                    }
                }else {
                    Utils.showDialog(msg: "no aps")
                }
            }else {
                Utils.showDialog(msg: "no notif")
            }
        }
    }
}

@objc class Utils: NSObject {
    @objc static func showDialog(title: String = "", msg: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let a = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "ok", style: .destructive))
            UIApplication.shared.keyWindow?.rootViewController?.present(a, animated: true)
        }
    }
}
