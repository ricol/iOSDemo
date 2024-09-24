//
//  WebViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/8/12.
//

import Foundation
import WebKit

class WebViewController: BaseViewController, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("didReceive: \(message)...name: \(message.name), body: \(message.body)")
        if message.name == "toMobile" {
            if let str = message.body as? String {
                if str == "popup" {
                    let alertcontroller = UIAlertController(title: "popup", message: str, preferredStyle: .alert)
                    alertcontroller.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.present(alertcontroller, animated: true)
                }
            }
        }else if message.name == "fromMobile" {
            self.theWebView.evaluateJavaScript("webkit.messageHandlers.fromMobile.onMessage('hi javascript!')")
        }else if message.name == "jsMessageHandler" {
            
        }
    }
    
    @IBOutlet weak var theWebView: WKWebView!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Web View Demo"
        theWebView.configuration.userContentController.add(self, name: "toMobile")
        theWebView.configuration.userContentController.add(self, name: "fromMobile")
        theWebView.configuration.userContentController.add(self, name: "jsMessageHandler")
        
        if let url {
            theWebView.load(URLRequest(url: url))
        }else {
            if let url = Bundle.main.url(forResource: "web", withExtension: "html") {
                let request = URLRequest(url: url)
                theWebView.load(request)
            }
        }
    }
    
    static func getVC(url: URL? = nil) -> Self? {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "WebViewController") as? Self {
            vc.url = url
            return vc
        }
        return nil
    }
    
    deinit {
        theWebView.configuration.userContentController.removeAllScriptMessageHandlers()
    }
}
