//
//  Extensions.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/8/21.
//

import Foundation

extension UIDeviceOrientation {
    func toDisplay() -> String {
        switch self {
        case .unknown:
            "unknown"
        case .portrait:
            "portrait"
        case .portraitUpsideDown:
            "portraitUpsideDown"
        case .landscapeLeft:
            "landscapeLeft"
        case .landscapeRight:
            "landscapeRight"
        case .faceUp:
            "faceUp"
        case .faceDown:
            "faceDown"
        default:
            "unknow"
        }
    }
}

extension UIInterfaceOrientationMask {
    func getDisplay() -> String {
        switch self {
        case .portrait: "portrait"
        case .portraitUpsideDown: "portraitUpsideDown"
        case .landscape: "landscape"
        case .landscapeLeft: "landscapeLeft"
        case .landscapeRight: "landscapeRight"
        case .all: "all"
        case .allButUpsideDown: "allButUpsideDown"
        default:
            "unknown"
        }
    }
}

extension UIInterfaceOrientation {
    func getDisplay() -> String {
        switch self {
        case .unknown:
            "unknown"
        case .portrait:
            "portrait"
        case .portraitUpsideDown:
            "portraitUpsideDown"
        case .landscapeLeft:
            "landscapeLeft"
        case .landscapeRight:
            "landscapeRight"
        default:
            "unknown"
        }
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red: Double.random(in: 1...255) / 255.0,
                       green: Double.random(in: 1...255) / 255.0,
                       blue: Double.random(in: 1...255) / 255.0, alpha: 1)
    }
}

extension UIView {
    func randomBGColor() {
        self.backgroundColor = .randomColor()
        for v in self.subviews { v.randomBGColor() }
    }
    
    func randomBorderColor() {
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.randomColor().cgColor
        for v in self.subviews { v.randomBorderColor() }
    }
}

extension String {
    static func randomString(maxlen: Int = 500) -> String {
        let str = " abcd efghijk lmnopqrs tuvwxyz ABCDEFGHI JKLMNOPQR STUVWXYZ "
        var result = [Character]()
        (0...Int.random(in: 1...maxlen)).forEach { _ in
            result.append(str.randomElement()!)
        }
        return String(result)
    }
}

extension UIViewController {
    func embedInNavigationController() -> UIViewController {
        let navigationController = UINavigationController(rootViewController: self)
        return navigationController
    }
}