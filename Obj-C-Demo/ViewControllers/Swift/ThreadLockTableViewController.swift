//
//  ThreadLockTableViewController.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/4/11.
//

import Foundation

class ThreadLockTableViewController: ListTableViewController {
    @objc func testNSLock() {
        var data: [Int] = []
        var quit = false
        let lock = NSLock()
        Thread.detachNewThread {
            print("\(Thread.current)...write data...")
            while true {
                sleep(1)
                lock.lock()
                if quit { lock.unlock(); break }
                data.append((1...10).randomElement()!)
                print("value added. [\(data.count)]")
                lock.unlock()
            }
            print("\(Thread.current)...write data...end.")
        }
        Thread.detachNewThread {
            print("\(Thread.current)...read data...")
            while true {
                sleep(2)
                lock.lock()
                if quit { lock.unlock(); break }
                let value = data.removeFirst()
                print("get value: \(value) remaining: \(data.count)")
                lock.unlock()
            }
            print("\(Thread.current)...read data...end.")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            lock.withLock {
                quit = true
                print("set quit.")
            }
        })
    }
    
    @objc func testNSCondition() {
        class MyConditionLock: NSCondition {
            override func lock() {
                print("\(self)lock...")
                super.lock()
            }
            override func unlock() {
                print("\(self)unlock...")
                super.unlock()
            }
            override func wait() {
                print("\(self)wait...")
                super.wait()
            }
            override func signal() {
                print("\(self)signal...")
                super.signal()
            }
        }
        var data: [Int] = []
        var quit = false
        let lock = MyConditionLock()
        Thread.detachNewThread {
            print("\(Thread.current)...write data...")
            while true {
                sleep(1)
                lock.lock()
                if quit { lock.signal(); lock.unlock(); break }
                let num = (1...10).randomElement()!
                data.append(num)
                print("\(Thread.current)...value \(num) added. [\(data.count)]")
                lock.signal()
                lock.unlock()
            }
            print("\(Thread.current)...write data...end.")
        }
        Thread.detachNewThread {
            print("\(Thread.current)...read data...")
            while true {
                lock.lock()
                if quit { lock.unlock(); break }
                if data.count <= 0 {
                    print("\(Thread.current)...no data to read...wait...")
                    lock.wait()
                }else {
                    let value = data.removeFirst()
                    print("\(Thread.current)...get value: \(value) remaining: \(data.count)")
                }
                lock.unlock()
            }
            print("\(Thread.current)...read data...end.")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            lock.withLock {
                quit = true
                print("set quit.")
            }
        })
    }
    
    @objc func testNSConditionLock() {
        var data: [Int] = []
        var quit = false
        let lock = NSConditionLock()
        Thread.detachNewThread {
            print("\(Thread.current)...write data...")
            while true {
                sleep(1)
                lock.lock()
                if quit { lock.unlock(withCondition: 1); break }
                let num = (1...10).randomElement()!
                data.append(num)
                print("\(Thread.current)...value \(num) added. [\(data.count)]")
                lock.unlock(withCondition: 1)
            }
            print("\(Thread.current)...write data...end.")
        }
        Thread.detachNewThread {
            print("\(Thread.current)...read data...")
            while true {
                lock.lock(whenCondition: 1)
                if quit { lock.unlock(); break }
                if data.count <= 0 {
                    print("\(Thread.current)...no data to read...wait...")
                }
                if data.count > 0 {
                    let value = data.removeFirst()
                    print("\(Thread.current)...get value: \(value) remaining: \(data.count)")
                }
                lock.unlock(withCondition: 0)
            }
            print("\(Thread.current)...read data...end.")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            lock.withLock {
                quit = true
                print("set quit.")
            }
        })
    }
    
    @objc func testNSRecursiveLock() {
        let lock = NSRecursiveLock()
        Thread.detachNewThread {
            for i in 0...10 {
                lock.lock()
                print("[\(Thread.current)lock...\(i)")
            }
            for i in 0...10 {
                lock.unlock()
                print("[\(Thread.current)unlock...\(i)")
            }
        }
        Thread.detachNewThread {
            for i in 0...10 {
                lock.lock()
                print("[\(Thread.current)]lock...\(i)")
            }
            for i in 0...10 {
                lock.unlock()
                print("[\(Thread.current)unlock...\(i)")
            }
        }
        print("end")
    }
    
    @objc func testDispatchQueueSync() {
        var data = [Int]()
        let queue = DispatchQueue(label: "myqueue")
        Thread.detachNewThread {
            for i in 0...1000 {
                queue.async {
                    data.append(i)
                }
            }
        }
        Thread.detachNewThread {
            for i in 1001...2000 {
                queue.async {
                    data.append(i)
                }
            }
        }
        Thread.detachNewThread {
            var i = 0
            while i < 5 {
                sleep(1)
                i += 1
                queue.async {
                    print("data.count: \(data.count)")
                }
            }
            print("end.")
        }
    }
}
