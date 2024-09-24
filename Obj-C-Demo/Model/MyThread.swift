//
//  MyThread.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/22.
//

import Foundation

@objc class MyThread: Thread {
    static var count: Int = 0
    var object: NSObject?
    
    override init() {
        super.init()
        MyThread.count += 1
        print("[\(Thread.current)]create thread...[\(MyThread.count)]")
    }
    
    override func start() {
        print("[\(Thread.current)]start...")
        super.start()
    }
    
    override func main() {
        super.main()
        print("[\(Thread.current)]main...begin")
//        RunLoop.current.run(until: Date().addingTimeInterval(5))
        print("[\(Thread.current)]main...end")
    }
    
    @objc func calculate(from: Int, to: Int) -> [Int] {
        func isPrime(n: Int) -> Bool {
            if n < 2 { return false }
            if n == 2 { return true }
            if n / 2 >= 2 {
                for i in (2...(n / 2)) {
                    if n % i == 0 { return false }
                }
            }
            return true
        }
        var primes = [Int]()
        for n in (from...to) {
            if isPrime(n: n) { primes.append(n) }
        }
        return primes
    }
    
    @objc func calculateWithPair(p: Pair) -> [Int] {
        let r = self.calculate(from: Int(p.from), to: Int(p.to))
        print("[\(self)] r: \(r)")
        return r
    }
    
    deinit {
        MyThread.count -= 1
        print("[\(Thread.current)]deinit...[\(MyThread.count)]")
    }
}

class MyRunLoopDemoClass: NSObject {
    var data: Int = 0
    var timer: Timer?
    
    func testRunLoop() {
        data = 0;
        self.timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            guard let s = self else { return }
//            guard let t = s.timer else { return }
            print("\(Thread.current)...timer..\(Date())...data: \(s.data)")
            s.data += 1
            if s.data > 10 {
                CFRunLoopStop(RunLoop.current.getCFRunLoop())
//                CFRunLoopTimerInvalidate(t)
            }
        }
        guard let timer else { return }
        let thread = MyThread {
            print("[\(Thread.current)]...running...and sleep for 5 seconds...")
            sleep(5)
            RunLoop.current.add(timer, forMode: .default)
            RunLoop.current.run()
            print("[\(Thread.current)]...wake up.")
        }
        thread.object = self
        thread.start()
    }
    
    func testPerformSelectorOnThread() -> Thread {
        let thread = MyThread {
            print("[\(Thread.current)]...running...begin")
            print("[\(Thread.current)]...running...end.")
        }
        thread.object = self
        thread.start()
        self.perform(#selector(myfunction), on: thread, with: nil, waitUntilDone: true)
        print("after perform")
        return thread
    }
    
    func testRunLoopButNoInputSource() -> Thread {
        let thread = MyThread {
            print("[\(Thread.current)]...running...begin")
            print("[\(Thread.current)]...running...end.")
        }
        thread.object = self
        thread.start()
//        self.perform(#selector(myfunction), on: thread, with: nil, waitUntilDone: true)
        print("after perform")
        return thread
    }
    
    @objc func myfunction() {
        print("[\(Thread.current)]...myfunction is running...begin")
        print("[\(Thread.current)]...myfunction is running...end.")
    }
}
