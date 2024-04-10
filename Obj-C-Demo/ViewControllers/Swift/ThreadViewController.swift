//
//  ThreadViewController.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/23.
//

import UIKit

class ThreadViewController: BaseViewController {
    @IBOutlet weak var lblText: UILabel!
    var mythread: Thread?
    
    @IBAction func btnPerformSelectorOnThreadOnTapped(_ sender: Any) {
        let object = MyRunLoopDemoClass()
        mythread = object.testPerformSelectorOnThread()
    }
    
    @IBAction func btnTestRunloopWithouthInputSource(_ sender: Any) {
        let object = MyRunLoopDemoClass()
        mythread = object.testRunLoopButNoInputSource()
    }
    
    @IBAction func btnTestRunloopOntapped(_ sender: Any) {
        let o = MyRunLoopDemoClass()
        o.testRunLoop()
    }
    
    @IBAction func btnTestRunloopOnThreadOnTapped(_ sender: Any) 
    {
        DispatchQueue.global().async {
            print("[\(Thread.current)]begin perform...")
            self.perform(#selector(self.test))
            self.perform(#selector(self.test), with: nil, afterDelay: 10) //essentionally add a timer to triggle the perform action
            RunLoop.current.run(until: Date().addingTimeInterval(15))
            print("[\(Thread.current)]after perform...")
        }
    }
    
    @objc func test() {
        print("[\(Thread.current)]test...")
    }
    
    @IBAction func btnRefreshUIWhileScrollingOnTapped(_ sender: Any) {
        DispatchQueue.global().async {
            print("\(Thread.current)getting data after 5 seconds...")
            sleep(5)
            print("\(Thread.current)getting data...")
            DispatchQueue.main.async {
                self.refreshUI(s: "welcome to ios world.\((1...10).randomElement()!)")
            }
            print("\(Thread.current)getting data...end")
        }
    }
    
    @objc func refreshUI(s: String) {
        lblText.text = s
    }
}
