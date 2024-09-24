//
//  NetworkViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/8/22.
//

import UIKit
import SwiftUI

class NetworkTableViewController: ListTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @objc func testWebView() {
        guard let vc = WebViewController.getVC(url: nil) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func testWebViewForRemoteURL() {
        guard let vc = WebViewController.getVC(url: URL(string: "https://www.baidu.com")) else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func testStartMonitorCellularData() {
        NetworkAvailability.startMonitor()
    }
    
    @objc func testStopMonitorCellularData() {
        NetworkAvailability.stopMonitor()
    }
    
    @objc func testFireAPICall() {
        guard let url = URL(string: "https://www.china.com") else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("error: \(error)")
            }
            print("response: \(response)")
            print("data: \(data?.count ?? 0)")
        }.resume()
    }
    
    @objc func testCheckCellularDataPermission() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                let alert = UIAlertController(title: "Cellular Data Permission", message: "Please enable cellular data for this app in Settings.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                // Present the alert (assuming this is within a UIViewController)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
