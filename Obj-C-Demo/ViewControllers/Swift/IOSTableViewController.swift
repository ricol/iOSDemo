//
//  IOSTableViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/9/27.
//

import UIKit

extension UIStoryboard {
    static func main() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static func getVC() -> StatusBarDemoViewController? {
        return UIStoryboard.main().instantiateViewController(withIdentifier: "StatusBarDemoViewController") as? StatusBarDemoViewController
    }
}

class StatusBarDemoViewController: UIViewController {

    @IBOutlet weak var btnClose: UIBarButtonItem!
    @IBOutlet weak var childView: UIView!
    var darkContent: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle { darkContent ? .darkContent : .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.childView.backgroundColor = .clear
        self.view.backgroundColor = darkContent ? .white : .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnClose.isEnabled = self.presentingViewController != nil
    }
    
    @IBAction func btnDoneOnTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnLightContentOnTapped(_ sender: Any) {
        if let vc = UIStoryboard.getVC() {
            vc.darkContent = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnDarkContentOnTapped(_ sender: Any) {
        if let vc = UIStoryboard.getVC() {
            vc.darkContent = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnPresentWithLightContentOnTapped(_ sender: Any) {
        if let vc = UIStoryboard.getVC() {
            vc.darkContent = false
            let nav = vc.embedInNavigationController()
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    @IBAction func btnPresentWithDarContentOnTapped(_ sender: Any) {
        if let vc = UIStoryboard.getVC() {
            vc.darkContent = true
            let nav = vc.embedInNavigationController()
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
}

class IOSTableViewController: BaseTableViewController {

}
