//
//  CombineFrameworDemoViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/3/13.
//

import UIKit
import Combine

class CombineFrameworDemoViewController: BaseTableViewController {
    class ViewModel {
        let btn: UIButton = UIButton()
        let lbl: UILabel = UILabel()
        let object = Object()
        class Object {
            var text: String = ""
            var flag: Bool = false
        }
        @Published var flag: Bool = false {
            didSet {
                print("[didSet] expecting \(flag).....")
                print("btn.isEnabled: \(btn.isEnabled) -> \(btn.isEnabled == flag ? "pass" : "fail")")
                print("lbl.text: \(lbl.text) -> \(lbl.text == "\(flag)" ? "pass" : "fail")")
                print("object.text: \(object.text) -> \(object.text == "\(flag)" ? "pass" : "fail")")
                print("object.flag: \(object.flag) -> \(object.flag == flag ? "pass" : "fail")")
            }
        }
    }
    
    var cancellables: [AnyCancellable] = []
    let vm = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.$flag.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: vm.btn).store(in: &cancellables)
        vm.$flag.receive(on: DispatchQueue.main).map({ output in
            "\(output)"
        }).assign(to: \.text, on: vm.lbl).store(in: &cancellables)
        vm.$flag.receive(on: DispatchQueue.main).assign(to: \.flag, on: vm.object).store(in: &cancellables)
        vm.$flag.receive(on: DispatchQueue.main).map { output in
            "\(output)"
        }.assign(to: \.text, on: vm.object).store(in: &cancellables)
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
        }.subscribe(Subscribers.Assign(object: vm.lbl, keyPath: \.text))
        print("posting notification...")
        NotificationCenter.default.post(name: .myNotif, object: "Test combine framework in Notification with explicit Subscriber")
        print("lbl text: \(String(describing: vm.lbl.text))")
    }
    
    @objc func testNotificationWithAssign() {
        NotificationCenter.default.publisher(for: .myNotif).map { notif in
            notif.object as? String
        }.assign(to: \.text, on: vm.lbl).store(in: &cancellables)
        print("posting notification...")
        NotificationCenter.default.post(name: .myNotif, object: "Test combine framework in Notification with assign")
        print("lbl text: \(String(describing: vm.lbl.text))")
    }

    @objc func testPublisher() {
        func delay(_ block: @escaping () -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: DispatchWorkItem(block: {
                block()
            }))
        }
        func show() {
            print("[after 1 second] expecting \(self.vm.flag)......")
            print("btn.isEnabled: \(self.vm.btn.isEnabled) -> \(self.vm.btn.isEnabled == self.vm.flag ? "pass": "fail")")
            print("lbl.text: \(String(describing: self.vm.lbl.text)) -> \(self.vm.lbl.text == "\(self.vm.flag)" ? "pass" : "fail")")
            print("object.text: \(self.vm.object.text) -> \(self.vm.object.text == "\(self.vm.flag)" ? "pass" : "fail")")
            print("object.flag: \(self.vm.object.flag) -> \(self.vm.object.flag == self.vm.flag ? "pass" : "fail")")
        }
        
        delay {
            self.vm.flag.toggle()
            delay {
                show()
                delay {
                    self.vm.flag.toggle()
                    delay {
                        show()
                        self.vm.flag = true
                        delay {
                            show()
                            self.vm.flag = false
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
