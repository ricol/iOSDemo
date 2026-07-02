//
//  Constants.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/7/23.
//

import Foundation

class Constants {
    static let liusisi: [UIImage] = {
        var result = [UIImage]()
        if let path = Bundle.main.path(forResource: "liusisi", ofType: "bundle"), let bundle = Bundle(path: path)  {
            if let contents = try? FileManager.default.contentsOfDirectory(at: bundle.bundleURL, includingPropertiesForKeys: nil) {
                for c in contents {
                    if let image = UIImage(named: c.lastPathComponent, in: bundle, with: nil) {
                        result.append(image)
                    }
                }
            }
        }
        return result
    }()
}
