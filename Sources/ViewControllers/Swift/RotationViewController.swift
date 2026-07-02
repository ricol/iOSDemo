//
//  RotationViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/7/5.
//

import UIKit

class RotationViewController: UIViewController {

    @IBOutlet weak var lblDesc: UILabel!
    let sb = UIStoryboard(name: "Main", bundle: nil)
    var orientations: UIInterfaceOrientationMask = .all
    var orientationsDisplay: String { orientations.getDisplay() }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barItem = UIBarButtonItem(image: UIImage(systemName: "xmark.circle"), style: .plain, target: self, action: #selector(closeVC))
        self.navigationItem.rightBarButtonItem = barItem
        // Do any additional setup after loading the view.
        self.title = "Rotation Demo"
        lblDesc.text = "Current View Controller Supports: \(orientationsDisplay)"
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { orientations }

    @IBAction func btnLandscapeOnlyOnTapped(_ sender: Any) {
        if let vc = sb.instantiateViewController(withIdentifier: "RotationViewController") as? RotationViewController {
            vc.orientations = .landscape
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnPortraitOnlyOntapped(_ sender: Any) {
        if let vc = sb.instantiateViewController(withIdentifier: "RotationViewController") as? RotationViewController {
            vc.orientations = .portrait
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnAllOnTapped(_ sender: Any) {
        if let vc = sb.instantiateViewController(withIdentifier: "RotationViewController") as? RotationViewController {
            vc.orientations = .all
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true)
    }
}
