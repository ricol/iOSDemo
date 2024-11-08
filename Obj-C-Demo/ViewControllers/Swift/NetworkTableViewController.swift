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
    
    @objc func testURLSession() {
        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        let task = urlSession.downloadTask(with: URL(string: "https://wallpapercave.com/wp/wp2309567.jpg")!)
        task.resume()
    }
}

extension NetworkTableViewController: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("[\(Thread.current)] didFinishDownloadingTo \(location.absoluteString)")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("[\(Thread.current)] Progress \(downloadTask.progress.fractionCompleted * 100)%")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        print("[\(Thread.current)] didCompleteWithError: \(error))")
    }
}
