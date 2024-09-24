//
//  TouchViewController.swift
//  AppDemo
//
//  Created by Ricol Wang on 2024/2/11.
//

import UIKit

class MyBaseView: UIView {
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.tag = 0
        var i = 0
        if let p = self.superview, p is MyBaseView {
            for s in p.subviews {
                if s == self {
                    self.tag = i
                    self.setNeedsDisplay()
                    break
                }
                i += 1
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let font = UIFont.systemFont(ofSize: 12)
        let str = NSAttributedString(string: "\(getTag())", attributes: [.font: font])
        str.draw(at: CGPoint(x: 0, y: 0))
    }
    
    private var _tag: String?
    
    func getTag() -> String {
        if let _tag { return _tag }
        var parent: UIView? = self.superview
        var r = "\(tag)"
        while let p = parent, parent is MyBaseView {
            r = "\(p.tag)-" + r
            parent = p.superview
        }
        _tag = r
        return r
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event) //disable this will prevent parent from handling the touch event
        print("\(getTag())...touchesBegan...")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("\(getTag())...touchesEnded.")
    }
    
    //decide whether need to search subviews
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let r = super.point(inside: point, with: event)
        print("\(getTag())...pointInside...\(r), event: \(event)")
        if r {
            self.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 255, alpha: 1)
            self.layer.borderWidth = 5
            DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(1))) {
                self.layer.borderWidth = 0
            }
        } else {
            self.layer.borderColor = CGColor.init(red: 255, green: 0, blue: 0, alpha: 1)
            self.layer.borderWidth = 5
            DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(1))) {
                self.layer.borderWidth = 0
            }
        }
        return r
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("\(getTag())...before hitTest...")
        let v = super.hitTest(point, with: event)
        print("\(getTag())...after hitTest...v: \(v)")
        return v
    }
}

class MyTargetView: MyBaseView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let _ = super.point(inside: point, with: event)
        return true
    }
}

class MyView: MyBaseView {

}

class TouchViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Touch Demo"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("controller...touchesBegan...")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("controller...touchesEnded.")
    }
}

