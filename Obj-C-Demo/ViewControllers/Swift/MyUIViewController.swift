//
//  MyUIViewController.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/5.
//

import UIKit

class MyUIViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImageView(image: UIImage(named: "liusisi"))
        self.view.addSubview(img)
        img.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     img.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     img.widthAnchor.constraint(equalToConstant: 100),
                                     img.heightAnchor.constraint(equalToConstant: 100)])
        let lbl = UILabel()
        lbl.text = "Hello world"
        lbl.backgroundColor = .blue
        self.view.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([lbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     lbl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                                     lbl.heightAnchor.constraint(equalToConstant: 40)])
        
        let lblleft = UILabel()
        lblleft.text = "left label"
        lblleft.backgroundColor = .yellow
        self.view.addSubview(lblleft)
        lblleft.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([lblleft.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     lblleft.heightAnchor.constraint(equalToConstant: 40),
                                     lblleft.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 20)])
        
        let lblright = UILabel()
        lblright.text = "right label"
        lblright.backgroundColor = .yellow
        self.view.addSubview(lblright)
        lblright.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([lblright.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     lblright.heightAnchor.constraint(equalToConstant: 40),
                                     lblright.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)])
        
        let lblleftAlign = UILabel()
        lblleftAlign.text = "left label aligned"
        lblleftAlign.backgroundColor = .brown
        self.view.addSubview(lblleftAlign)
        lblleftAlign.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([lblleftAlign.leadingAnchor.constraint(equalTo: lblleft.leadingAnchor),
                                     lblleftAlign.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                                     lblleftAlign.heightAnchor.constraint(equalToConstant: 40)])
        
        let lblrightAlign = UILabel()
        lblrightAlign.text = "right label aligned"
        lblrightAlign.backgroundColor = .orange
        self.view.addSubview(lblrightAlign)
        lblrightAlign.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([lblrightAlign.trailingAnchor.constraint(equalTo: lblright.trailingAnchor),
                                     lblrightAlign.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                                     lblrightAlign.heightAnchor.constraint(equalToConstant: 40)])
        
        let lblcenterAlign = UILabel()
        lblcenterAlign.text = "center label aligned"
        lblcenterAlign.backgroundColor = .red
        self.view.addSubview(lblcenterAlign)
        lblcenterAlign.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([lblcenterAlign.centerXAnchor.constraint(equalTo: lbl.centerXAnchor),
                                     lblcenterAlign.widthAnchor.constraint(equalTo: lbl.widthAnchor),
                                     lblcenterAlign.heightAnchor.constraint(equalTo: lbl.heightAnchor),
                                     lblcenterAlign.topAnchor.constraint(equalTo: lblrightAlign.topAnchor)])
        
        let btn = UIButton(type: .system)
        btn.setTitle("Update", for: .normal)
        self.view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([btn.centerXAnchor.constraint(equalTo: img.centerXAnchor),
                                     btn.heightAnchor.constraint(equalToConstant: 40),
                                     btn.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 0)])
    }
}
