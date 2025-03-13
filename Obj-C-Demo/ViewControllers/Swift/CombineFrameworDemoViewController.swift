//
//  CombineFrameworDemoViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/3/13.
//

import UIKit
import Combine

class CombineFrameworDemoViewController: BaseTableViewController {
    class CombineDemo {
        let btn: UIButton = UIButton()
        let lbl: UILabel = UILabel()
        @Published var flag: Bool = false {
            didSet {
                print("didSet...expecting \(flag)")
                print("btn.isEnabled: \(btn.isEnabled)")
                print("lbl.text: \(lbl.text)")
            }
        }
    }
    
    var cancellables: [AnyCancellable] = []
    let c = CombineDemo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        c.$flag.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: c.btn).store(in: &cancellables)
        c.$flag.receive(on: DispatchQueue.main).map({ output in
            "\(output)"
        }).assign(to: \.text, on: c.lbl).store(in: &cancellables)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let text = cell?.textLabel?.text {
            let sel: Selector = Selector("test\(text)")
            if self.responds(to: sel) {
                print("perform selector: \(sel.description)")
                self.perform(sel)
            }else {
                print("unknown selector: \(sel.description)")
            }
        }
    }
    
    @objc func testNotificationWithExplicitSubscribers() {
        NotificationCenter.default.publisher(for: .myNotif).map { notif in
            notif.object as? String
        }.subscribe(Subscribers.Assign(object: c.lbl, keyPath: \.text))
        print("posting notification...")
        NotificationCenter.default.post(name: .myNotif, object: "Test combine framework in Notification with explicit Subscriber")
        print("lbl text: \(String(describing: c.lbl.text))")
    }
    
    @objc func testNotificationWithAssign() {
        NotificationCenter.default.publisher(for: .myNotif).map { notif in
            notif.object as? String
        }.assign(to: \.text, on: c.lbl).store(in: &cancellables)
        print("posting notification...")
        NotificationCenter.default.post(name: .myNotif, object: "Test combine framework in Notification with assign")
        print("lbl text: \(String(describing: c.lbl.text))")
    }

    @objc func testPublisher() {
        func delay(_ block: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: DispatchWorkItem(block: {
                block()
            }))
        }
        func show() {
            print("after 1 second...expecting \(self.c.flag)")
            print("btn.isEnabled: \(self.c.btn.isEnabled)")
            print("lbl.text: \(String(describing: self.c.lbl.text))")
        }
        
        delay {
            self.c.flag.toggle()
            delay {
                show()
                delay {
                    self.c.flag.toggle()
                    delay {
                        show()
                        self.c.flag = true
                        delay {
                            show()
                            self.c.flag = false
                            delay {
                                show()
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func testTimer() {
        var count = 0
        self.store = []
        print("test timer publisher to count til 10 and stop...")
        Timer.publish(every: 1, on: RunLoop.main, in: .common).autoconnect().sink { complete in
            print("complete: \(complete)")
        } receiveValue: { output in
            print("output: \(output), count: \(count)")
            count += 1
            if count > 10 {
                self.store.forEach { any in
                    any.cancel()
                }
                self.store.removeAll()
                print("stop.")
            }
        }.store(in: &store)
    }
    
    var store: [AnyCancellable] = []
}

extension Notification.Name {
    static let myNotif = Notification.Name("notification")
}
