//
//  CoroutineViewController.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/31.
//

import Foundation

class CoroutineTableViewController: ListTableViewController {
    var task: Task<Void, Never>?
    var primes = [Int]()
    
    func getResult(from start: Int, to end: Int) async -> Int {
        print("calculating start from \(start) to \(end)...")
        var sum: Int = 0
        var i: Int = start
        while i <= end {
            sum += i
            i += 1
        }
        print("calculating complete from \(start) to \(end): \(sum)")
        return sum
    }
    
    func getResultByTaskResult(from start: Int, to end: Int) async -> Int {
        let task = Task {
            print("calculating start from \(start) to \(end)...")
            var sum: Int = 0
            var i: Int = start
            while i <= end {
                sum += i
                i += 1
            }
            print("calculating complete from \(start) to \(end): \(sum)")
            return sum
        }
        switch await task.result {
        case .success(let v):
            return v
        default:
            return 0
        }
    }
    
    func getResultByTaskValue(from start: Int, to end: Int) async -> Int {
        let task = Task {
            print("calculating start from \(start) to \(end)...")
            var sum: Int = 0
            var i: Int = start
            while i <= end {
                sum += i
                i += 1
            }
            print("calculating complete from \(start) to \(end): \(sum)")
            return sum
        }
        return await task.value
    }
    
    @objc func testAsync() {
        let task1 = Task(priority: .background, operation: {
            print("task1...get s1...")
            let s1 = await getResult(from: 0, to: 100)
            print("task1...get s2...")
            let s2 = await getResult(from: 101, to: 200)
            print("task1...get s3...")
            let s3 = await getResult(from: 201, to: 300)
            print("task1...get total...")
            let total = s1 + s2 + s3
            print("task1...s1: \(s1), s2: \(s2), s3: \(s3), total: \(total)")
        })
    }
    
    @objc func testAsyncWithTaskResult() {
        let task2 = Task {
            print("task2...get total...")
            let total = await getResultByTaskResult(from: 0, to: 300)
            print("task2 total: \(total)")
        }
    }
    
    @objc func testAsyncWithTaskValue() {
        let task3 = Task {
            print("Task3...s1...")
            async let s1 = getResultByTaskValue(from: 0, to: 100)
            try? await Task.sleep(nanoseconds: UInt64(3 * 1e9))
            print("Task3...s2...")
            async let s2 = getResultByTaskValue(from: 101, to: 200)
            try? await Task.sleep(nanoseconds: UInt64(3 * 1e9))
            print("Task3...s3...")
            async let s3 = getResultByTaskValue(from: 201, to: 300)
            try? await Task.sleep(nanoseconds: UInt64(3 * 1e9))
            let total = await s1 + s2 + s3
            print("task3...total: \(total)")
        }
    }
    
    @objc func testAsyncWithTaskAndCancel() {
        let task1 = Task {
            print("task1...s1...")
            async let s1 = getResultByTaskValue(from: 0, to: 100)
            try await Task.sleep(nanoseconds: UInt64(3 * 1e9))
            print("task1...s2...")
            async let s2 = getResultByTaskValue(from: 101, to: 200)
            try await Task.sleep(nanoseconds: UInt64(3 * 1e9))
            print("task1...s3...")
            async let s3 = getResultByTaskValue(from: 201, to: 300)
            try await Task.sleep(nanoseconds: UInt64(3 * 1e9))
            let total = await s1 + s2 + s3
            print("task1...total: \(total)")
        }
        let task2 = Task {
            do {
                print("task2...s1...")
                async let s1 = getResultByTaskValue(from: 0, to: 100)
                try await Task.sleep(nanoseconds: UInt64(3 * 1e9))
                print("task2...s2...")
                async let s2 = getResultByTaskValue(from: 101, to: 200)
                try await Task.sleep(nanoseconds: UInt64(3 * 1e9))
                print("task2...s3...")
                async let s3 = getResultByTaskValue(from: 201, to: 300)
                try await Task.sleep(nanoseconds: UInt64(3 * 1e9))
                let total = await s1 + s2 + s3
                print("task2...total: \(total)")
            }catch (let e) {
                print("task2: exception: \(e)")
            }
        }
        let task3 = Task {
            print("task1...s1...")
            async let s1 = getResultByTaskValue(from: 0, to: 100)
            try? await Task.sleep(nanoseconds: UInt64(3 * 1e9))
            print("task1...s2...")
            async let s2 = getResultByTaskValue(from: 101, to: 200)
            try? await Task.sleep(nanoseconds: UInt64(3 * 1e9))
            print("task1...s3...")
            async let s3 = getResultByTaskValue(from: 201, to: 300)
            try? await Task.sleep(nanoseconds: UInt64(3 * 1e9))
            let total = await s1 + s2 + s3
            print("task1...total: \(total)")
        }
        let deadline: DispatchTime = .now().advanced(by: DispatchTimeInterval.seconds(3))
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            task1.cancel()
            task2.cancel()
            task3.cancel()
        }
    }
    
    @objc func testAsyncWithTaskCancellationHandler() {
        func getAllPrimes(from: Int, to: Int) async throws -> [Int] {
            var tasks = [Task<Int?, Error>]()
            (from...to).forEach { n in
                tasks.append(Task {
                    if let v = await findPrimes(from: n, to: n, log: false, checkCancellation: true).first {
                        return v
                    }else { return nil }
                })
            }
            let immutableTasks = tasks
            return try await withTaskCancellationHandler {
                var result = [Int]()
                print("tasks calculating...")
                for t in tasks {
                    if let v = try await t.value { result.append(v) }
                }
                print("resturn result...\(result.count)")
                return result
            } onCancel: {
                print("cancelling all tasks...")
                immutableTasks.forEach { t in
                    t.cancel()
                }
            }
        }
        
        let t = Task {
            do {
                print("calculating...")
                let result = try await getAllPrimes(from: 0, to: Int(1e5))
                print("result.count: \(result.count)")
            }catch {
                print("exception: \(error)")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            t.cancel()
        })
    }
    
    @objc func testParallelAsync() {
        @Sendable func callAPI() async -> Int {
            print("[\(Thread.current)] callAPI...[\(Count.increase())]")
            try? await Task.sleep(nanoseconds: UInt64(Double((1...10).randomElement()!) * 1e9))
            print("[\(Thread.current)] callAPI...end.[\(Count.decrease())]")
            return (1...100).randomElement()!
        }
        
        Task {
            Count.reset()
            async let a = callAPI()
            async let b = callAPI()
            async let c = callAPI()
            var nums = await [a, b, c]
            print("nums: \(nums)")
            async let d = callAPI()
            async let e = callAPI()
            async let f = callAPI()
            nums = [await d, await e, await f]
            print("nums: \(nums)")
            nums = Array(repeating: 0, count: 10)
            await withTaskGroup(of: Void.self) { group in
                for i in 0..<10 {
                    group.addTask {
                        let v = await callAPI()
                        await MainActor.run {
                            print("[\(Thread.current)] assigning...\(i) with \(v)")
                            nums[i] = v
                        }
                    }
                }
            }
            print("nums: \(nums)")
            
            let t = await withTaskGroup(of: Int.self, returning: [Int].self) { group in
                for i in 0..<10 {
                    group.addTask {
                        let v = await callAPI()
                        return v
                    }
                }
                
                nums.removeAll()
                for await v in group {
                    nums.append(v)
                }
                print("nums: \(nums)")
                return nums
            }
            nums.removeAll()
            nums += t
            print("nums: \(nums)")
        }
    }
    
    @objc func testActor() {
        actor Account {
            var amount: Int
            let firstname: String
            let lastname: String
            nonisolated var name: String {
                return "\(firstname.capitalized) \(lastname.capitalized)"
            }
            lazy var displayName: String = {
                return name
            }()
            
            init(amount: Int, firstname: String, lastname: String) {
                self.amount = amount
                self.firstname = firstname
                self.lastname = lastname
            }
            
            func display() {
                print("--------bank account-------")
                print("name: \(displayName)")
                print("amount: \(amount)")
                print("--------------end----------")
            }
            
            func increaseAmountBy(num: Int) {
                print("increasing...\(amount)")
                amount += num
                print("increasing...after \(amount)")
            }
            
            func decreaseAmountBy(num: Int) {
                print("decreasing...\(amount)")
                amount -= num
                print("decreasing...after \(amount)")
            }
        }
        
        let myaccount = Account(amount: 0, firstname: "ricol", lastname: "wang")
        
        (1...100).forEach { n in
            Task {
                await myaccount.increaseAmountBy(num: 1)
                await myaccount.display()
            }
            Task {
                await myaccount.decreaseAmountBy(num: 1)
                await myaccount.display()
            }
        }
    }
    
    @objc func testConvertClosureToAsync() {
        func getContent(url: String, complete: @escaping (String?, Error?) -> Void) {
            if let u = URL(string: url) {
                let r = URLRequest(url: u, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData)
                print("loading \(url)...")
                URLSession.shared.dataTask(with: r) { data, r, error in
                    if let res = r as? HTTPURLResponse {
                        if res.statusCode == 200, let data, let str = String(data: data, encoding: .utf8) {
                            print("loading...\(url) completed.")
                            complete(str, error)
                            return
                        }
                    }
                    complete(nil, error)
                }.resume()
            }
        }
        
        enum WebError: Error {
            case invalidURL(String)
            case netWorkError
        }
        
        func getContentAsync(url: String) async -> (String?, Error?) {
            await withCheckedContinuation { continuation in
                getContent(url: url) { s, e in
                    continuation.resume(returning: (s, e))
                }
            }
        }
        
        func getContentAsyncByResult(url: String) async -> Result<String?, WebError> {
            await withCheckedContinuation { continuation in
                getContent(url: url) { s, e in
                    if let e {
                        continuation.resume(returning: .failure(WebError.invalidURL(e.localizedDescription)))
                    }else {
                        continuation.resume(returning: .success(s))
                    }
                }
            }
        }
        
        let urls = ["https://www.baidu.com",
                    "https://www.bing.com",
                    "https://www.163.com",
                    "https://www.sohu.com",
                    "https://www.china.com",
                    "https://www.qq1.com"]
        urls.forEach { u in
            getContent(url: u) { s, e in
                if let e {
                    print("[\(u)] getContent error: \(e)")
                }else if let s {
                    print("[\(u)] getContent content: \(s.count)")
                }
            }
            Task {
                let (s, e) = await getContentAsync(url:u)
                if let e {
                    print("[\(u)] getContentAsync error: \(e)")
                }else if let s {
                    print("[\(u)] getContentAsync content: \(s.count)")
                }
            }
            Task {
                let r = await getContentAsyncByResult(url: u)
                switch r {
                case .success(let s):
                    if let s {
                        print("[\(u)] getContentAsyncByResult content: \(s.count)")
                    }
                case .failure(let e):
                    print("[\(u)] getContentAsyncByResult error: \(e)")
                }
            }
        }
    }
    
    @objc func testTaskCancel() {
        let t = Task {
            do {
                try Task.checkCancellation()
                print("calculating a...")
                let a = await getResult(from: 0, to: Int(1e5))
                print("finished a and sleep...")
                try? await Task.sleep(nanoseconds: UInt64(1e9))
                print("finished sleep and checkCancellation...")
                try Task.checkCancellation()
                print("finished checkCancellation and calulating b...")
                let b = await getResult(from: Int(1e5 + 1), to: Int(1e6))
                print("finished b and sleep...")
                try? await Task.sleep(nanoseconds: UInt64(1e9))
                print("finished sleep and checkCancellation...")
                try Task.checkCancellation()
                print("finished checkCancellation and calulating c...")
                let c = await getResult(from: Int(1e6 + 1), to: Int(1e7))
                print("finished c and sleep...")
                try? await Task.sleep(nanoseconds: UInt64(1e9))
                print("finished sleep...")
                print("a: \(a), b: \(b), c: \(c), sum: \(a + b + c)")
            }catch (let e) {
                print("exception: \(e)")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: DispatchTimeInterval.seconds(1))) {
            t.cancel()
        }
        
        print("end.")
    }
    
    @objc func testTaskDetach() {
        Task {
            async let a = getResult(from: 0, to: 100)
            async let b = getResult(from: 101, to: 200)
            async let c = getResult(from: 201, to: 300)
            let s = await a + b + c
            print("s: \(s)")
            Task.detached(priority:.background) {
                print("detached task...")
                async let a = self.getResult(from: 0, to: 100)
                async let b = self.getResult(from: 101, to: 200)
                async let c = self.getResult(from: 201, to: 300)
                let s = await a + b + c
                print("detached task: s: \(s)")
                print("detached task...end")
            }
        }
    }
    
    @objc func testTaskGroup() {
        
        func testFun() -> (Int, Int, Int, [Int], Bool) {
            return (1, 2, 3, [1, 2, 3], true)
        }
        
        let t1 = Task {
            async let a = findPrimes(from: 0, to: 10000)
            async let b = findPrimes(from: 10001, to: 20000)
            async let c = findPrimes(from: 20001, to: 30000)
            let (aa, bb, cc) = await (a, b, c)
            let total = await a + b + c
            print("[parallel]total: \(total.count), \((aa + bb + cc).count)")
        }
        let t2 = Task {
            let total = await findPrimes(from: 0, to: 30000)
            print("[single]total: \(total.count)")
        }
        let t3 = Task {
            let total = await withTaskGroup(of: [Int].self) { group in
                group.addTask() {
                    print("task1...")
                    try? await Task.sleep(nanoseconds: UInt64(1e9))
                    return await findPrimes(from: 0, to: 10000)
                }
                group.addTask() {
                    print("task2...")
                    try? await Task.sleep(nanoseconds: UInt64(1e9))
                    return await findPrimes(from: 10001, to: 20000)
                }
                group.addTask() {
                    print("task3...")
                    try? await Task.sleep(nanoseconds: UInt64(1e9))
                    return await findPrimes(from: 20001, to: 30000)
                }
                var result = [Int]()
                for await r in group {
                    result += r
                }
                return result
            }
            print("[taskGroup]total: \(total.count)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: DispatchTimeInterval.seconds(2))) {
            t1.cancel()
            t2.cancel()
            t3.cancel()
        }
    }
    
    @objc func testTaskGroupNext() {
        Task {
            let t = await withTaskGroup(of: [Int].self) { group in
                for i in 0..<10 {
                    group.addTask {
                        let r = (0...10).randomElement()!
                        print("task\(i)...\(r)")
                        try? await Task.sleep(nanoseconds: UInt64(Double(r) * 1e9))
                        return [r]
                    }
                }
                var r = [Int]()
                for i in 0..<10 {
                    print("[\(i)]get next...")
                    if let t = await group.next() {
                        print("[\(i)]next: \(t)")
                        r += t
                    }
                }
                return r
            }
            print("t: \(t)")
        }
    }
    
    @objc func testAsyncSequence() {
        struct Counter: AsyncSequence {
            typealias Element = Int
            let limit: Int
            struct AsyncIterator: AsyncIteratorProtocol {
                let limit: Int
                var current = 1
                mutating func next() async -> Int? {
                    guard !Task.isCancelled else { return nil }
                    guard current <= limit else { return nil }
                    let result = current
                    current += 1
                    return result
                }
            }
            func makeAsyncIterator() -> AsyncIterator {
                return AsyncIterator(limit: limit)
            }
        }
        
        struct CounterAsyncSequence: AsyncSequence, AsyncIteratorProtocol {
            typealias Element = Int
            let limit: Int
            var current = 1
            
            mutating func next() async -> Int? {
                guard !Task.isCancelled else { return nil }
                guard current <= limit else { return nil }
                let result = current
                current += 1
                return result
            }
            
            func makeAsyncIterator() -> CounterAsyncSequence {
                self
            }
        }
        
        Task {
            for await count in Counter(limit: 10) {
                print("count: \(count)")
            }
            for await count in Counter(limit: 10).filter({ n in
                n % 2 == 0
            }) {
                print("even number: \(count)")
            }
            let counterStream = Counter(limit: 10).map { n in
                n % 2 == 0
            }
            for await count in counterStream {
                print(count)
            }
        }
    }
    
    @objc func testAsyncStream() {
        func getPrimes(from: Int, to: Int) -> AsyncStream<Int> {
            return AsyncStream { continuation in
                Task {
                    await withTaskGroup(of: Void.self) { group in
                        for n in (from...to) {
                            group.addTask {
                                if await isPrime(n: n) { continuation.yield(n) }
                            }
                        }
                    }
                    continuation.finish()
                }
            }
        }
        
        Task {
            var primes = [Int]()
            for await i in getPrimes(from: 0, to: 100) {
                primes.append(i)
            }
            print("[Task] primes: \(primes.sorted())")
//            await MainActor.run {
//                for cell in self.tableView.visibleCells {
//                    if let lbl = cell.textLabel?.text, lbl == "AsyncStream" {
//                        cell.textLabel?.text = "\(lbl) - primes: \(primes.count)"
//                    }
//                }
//            }
            
            updateUI(text: "\(primes.count)") { text in
                print("[\(Thread.current)]updating UI...")
                for cell in self.tableView.visibleCells {
                    if let lbl = cell.textLabel?.text, lbl == "AsyncStream" {
                        cell.textLabel?.text = "\(lbl) - primes: \(primes.count)"
                    }
                }
            }
        }
        
        func updateUI(text: String, complete: @MainActor @escaping (String) -> Void) {
            Task {
                complete(text)
            }
        }
    }
    
    @objc func testGlobalActor() {
        @globalActor
        actor MyGlobalActor {
            static let shared = MyGlobalActor()
        }
        
        @MyGlobalActor
        final class MyPrimes {
            private var value = [Int]()
            func addPrimes(_ num: [Int]) {
                value += num
            }
            func getValue() -> [Int] {
                return value
            }
        }
        
        Task {
            print("using actor...")
            await ActorAcount.shared.reset()
            var primes = await MyPrimes()
            await withTaskGroup(of: [Int].self) { group in
                group.addTask {
                    await findPrimes(from: 0, to: 100)
                }
                group.addTask {
                    await findPrimes(from: 101, to: 1000)
                }
                group.addTask {
                    await findPrimes(from: 1001, to: 10000)
                }
                group.addTask {
                    await findPrimes(from: 10001, to: 20000)
                }
                for await w in group {
                    await primes.addPrimes(w)
                }
            }
            print("values.count: \((await primes.getValue()).count)")
            
            print("using lock...")
            Count.reset()
            primes = await MyPrimes()
            await withTaskGroup(of: [Int].self) { group in
                group.addTask {
                    await findPrimes(from: 0, to: 100, usingLock: true)
                }
                group.addTask {
                    await findPrimes(from: 101, to: 1000, usingLock: true)
                }
                group.addTask {
                    await findPrimes(from: 1001, to: 10000, usingLock: true)
                }
                group.addTask {
                    await findPrimes(from: 10001, to: 20000, usingLock: true)
                }
                for await w in group {
                    await primes.addPrimes(w)
                }
            }
            print("values.count: \((await primes.getValue()).count)")
        }
    }
    
    @objc func testStrongReference() {
        self.task = Task {
            await withTaskGroup(of: [Int].self) { group in
                group.addTask {
                    await findPrimes(from: 0, to: 100, usingLock: true)
                }
                group.addTask {
                    await findPrimes(from: 101, to: 1000, usingLock: true)
                }
                group.addTask {
                    await findPrimes(from: 1001, to: 10000, usingLock: true)
                }
                group.addTask {
                    await findPrimes(from: 10001, to: 20000, usingLock: true)
                }
                for await w in group {
                    self.primes += w
                }
            }
            print("values.count: \(self.primes.count)")
            //notice this task won't cause reference cycle issue.
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.task?.cancel()
        })
    }
    
    @objc func testDispatchGroup() {
        /*
        func functionC(completion: @escaping (String) -> Void) {
            // Simulate an async task
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                completion("Result from C")
            }
        }

        func functionA(dependency: String, completion: @escaping () -> Void) {
            // Simulate an async task that depends on the result of C
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                print("Function A received: \(dependency)")
                completion()
            }
        }

        func functionB(dependency: String, completion: @escaping () -> Void) {
            // Simulate an async task that depends on the result of C
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                print("Function B received: \(dependency)")
                completion()
            }
        }

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        var resultFromC: String?

        functionC { result in
            resultFromC = result
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            guard let result = resultFromC else { return }
            
            let group = DispatchGroup()

            group.enter()
            functionA(dependency: result) {
                group.leave()
            }

            group.enter()
            functionB(dependency: result) {
                group.leave()
            }

            group.notify(queue: .main) {
                print("Both A and B have finished")
            }
        }

        print("Waiting for tasks to complete...")
*/
        
        class TaskManager {
            static let shared = TaskManager()
            private var resultFromC: String?
            private var isCRunning = false
            private let lock = NSLock()
            private let dispatchGroup = DispatchGroup()
            
            private init() {}
            
            func functionC(completion: @escaping (String) -> Void) {
                lock.lock()
                if let result = resultFromC {
                    lock.unlock()
                    completion(result)
                    return
                }
                
                if isCRunning {
                    dispatchGroup.notify(queue: .main) {
                        if let result = self.resultFromC {
                            completion(result)
                        }
                    }
                    lock.unlock()
                    return
                }
                
                isCRunning = true
                lock.unlock()
                dispatchGroup.enter()
                
                // Simulate an async task
                DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                    print("func c set result...")
                    let result = "Result from C"
                    self.lock.lock()
                    self.resultFromC = result
                    self.isCRunning = false
                    self.lock.unlock()
                    self.dispatchGroup.leave()
                    completion(result)
                }
            }
            
            func functionA(completion: @escaping () -> Void) {
                print("func A start...")
                functionC { result in
                    // Simulate an async task that depends on the result of C
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        print("Function A received: \(result)")
                        completion()
                    }
                }
                print("func A end.")
            }
            
            func functionB(completion: @escaping () -> Void) {
                print("func B start...")
                functionC { result in
                    // Simulate an async task that depends on the result of C
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        print("Function B received: \(result)")
                        completion()
                    }
                }
                print("func B end.")
            }
        }

        // Example usage
        TaskManager.shared.functionA {
            print("Function A completed")
        }

        TaskManager.shared.functionB {
            print("Function B completed")
        }

        print("Waiting for tasks to complete...")

    }
}

struct Count {
    private static var value = 0
    private static let theLock = NSLock()
    static func increase() -> Int {
        Count.theLock.withLock {
            Count.value += 1
            return Count.value
        }
    }
    
    static func decrease() -> Int {
        Count.theLock.withLock {
            Count.value -= 1
            return Count.value
        }
    }
    
    static func reset() {
        Count.theLock.withLock {
            Count.value = 0
        }
    }
}

actor ActorAcount {
    static let shared = ActorAcount()
    private var value: Int = 0
    func reset() {
        value = 0
    }
    func increase() -> Int {
        value += 1
        return value
    }
    func decrease() -> Int {
        value -= 1
        return value
    }
}

func findPrimes(from: Int, to: Int, usingLock: Bool = false, log: Bool = true, checkCancellation: Bool = true) async -> [Int] {
    if log { print("findPrimes...from: \(from) to \(to)...[\(usingLock ? Count.increase() : await ActorAcount.shared.increase())]") }
    func isPrime(num: Int) throws -> Bool {
        if num < 2 { return false }
        if num / 2 >= 2 {
            for n in (2...(num / 2)) {
                if checkCancellation { try Task.checkCancellation() }
                if num % n == 0 { return false }
            }
        }
        return true
    }
    var result = [Int]()
    do {
        try (from...to).forEach { num in
            if checkCancellation { try Task.checkCancellation() }
            if try isPrime(num: num) { result.append(num) }
        }
        
        if log { print("findPrimes...from: \(from) to \(to)...finished.\(result.count) [\(usingLock ? Count.decrease() : await ActorAcount.shared.decrease())]") }
    }catch {
        if log { print("exception: \(error)") }
    }
    return result
}

func isPrime(n: Int) async -> Bool {
    print("checking prime...\(n) [\(Count.increase())]")
    var result = true
    if n < 2 { result = false; }
    else {
        if n / 2 >= 2 {
            for i in (2...(n / 2)) {
                if n % i == 0 { result = false; break; }
            }
        }
    }
    sleep(1)
    print("checking prime...\(n) end. [\(Count.decrease())]")
    return result
}
