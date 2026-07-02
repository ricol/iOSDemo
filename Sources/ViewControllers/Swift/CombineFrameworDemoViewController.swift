//
//  CombineFrameworDemoViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/3/13.
//

import UIKit
import Combine

class CombineFrameworDemoViewController: ListTableViewController {
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

        let menu = CustomListView(rows: [
            ListRow(title: "Action 1", block: {
                func show() {
                    @MainActor
                    func show() async {
                        print("[after 1 second] expecting \(self.vm.flag)......")
                        print("btn.isEnabled: \(self.vm.btn.isEnabled) -> \(self.vm.btn.isEnabled == self.vm.flag ? "pass": "fail")")
                        print("lbl.text: \(String(describing: self.vm.lbl.text)) -> \(self.vm.lbl.text == "\(self.vm.flag)" ? "pass" : "fail")")
                        print("object.text: \(self.vm.object.text) -> \(self.vm.object.text == "\(self.vm.flag)" ? "pass" : "fail")")
                        print("object.flag: \(self.vm.object.flag) -> \(self.vm.object.flag == self.vm.flag ? "pass" : "fail")")
                    }
                    Task {
                        await show()
                    }
                }

                self.vm.$flag.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: self.vm.btn).store(in: &self.cancellables)
                self.vm.$flag.receive(on: DispatchQueue.main).map({ output in
                    "\(output)"
                }).assign(to: \.text, on: self.vm.lbl).store(in: &self.cancellables)
                self.vm.$flag.receive(on: DispatchQueue.main).assign(to: \.flag, on: self.vm.object).store(in: &self.cancellables)
                self.vm.$flag.receive(on: DispatchQueue.main).map { output in
                    "\(output)"
                }.assign(to: \.text, on: self.vm.object).store(in: &self.cancellables)

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
            }),
            ListRow(title: "Action 2", block: {

            })
        ], title: "Menu", navigationView: true)
        menu.present()
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

    @objc func testJust() {
        let justPublisher = Just("Hello, Combine!")

        let _ = justPublisher.sink { value in
            print(value)  // Output: Hello, Combine!
        }
    }

    @objc func testEmpty() {
        let emptyPublisher = Empty<String, Never>()

        let _ = emptyPublisher.sink(
            receiveCompletion: { completion in
                print("Completed")
            },
            receiveValue: { value in
                print(value)
            }
        )  // Output: Completed
    }

    @objc func testFail() {
        enum SampleError: Error {
            case exampleError
        }

        let failPublisher = Fail<String, SampleError>(error: .exampleError)
        let _ = failPublisher.sink(
            receiveCompletion: { completion in
                print(completion)  // Output: failure(exampleError)
            },
            receiveValue: { value in
                print(value)
            }
        )
    }

    @objc func testDeferred() {
        let deferredPublisher = Deferred {
            Just("Deferred start")
        }
        let _ = deferredPublisher.sink { value in
            print(value)  // Output: Deferred start
        }
    }

    @objc func testFuture() {
        let futurePublisher = Future<String, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                promise(.success("Future value"))
            }
        }
        let _ = futurePublisher.sink { value in
            print(value)  // Output (after 1 second): Future value
        }
    }

    @objc func testPassthroughSubject() {
        let passthroughSubject = PassthroughSubject<String, Never>()
        let task = passthroughSubject.sink { value in
            print(value)
        }
        cancellables.append(task)
        passthroughSubject.send("First message")  // Output: First message
        passthroughSubject.send("Second message") // Output: Second message
        cancellables.forEach { $0.cancel() }
    }

    @objc func testCurrentValueSubject() {
        let currentValueSubject = CurrentValueSubject<Int, Never>(10)
        let _ = currentValueSubject.sink { value in
            print("Subscriber 1: \(value)")
        }
        currentValueSubject.send(20)  // Output: Subscriber 1: 20

        let _ = currentValueSubject.sink { value in
            print("Subscriber 2: \(value)")
        }  // Output: Subscriber 2: 20
    }

    @objc func testSequence() {
        let numbers = [1, 2, 3, 4, 5]  // A simple array
        let sequencePublisher = Publishers.Sequence<[Int], Never>(sequence: numbers)

        let _ = sequencePublisher.sink(
            receiveCompletion: { completion in
                print("Completed: \(completion)")
            },
            receiveValue: { value in
                print("Value: \(value)")
            }
        )
    }

    @objc func testMerge() {
        let publisher1 = Just("Hello")
        let publisher2 = Just("World")

        let mergedPublisher = publisher1.merge(with: publisher2)

        let _ = mergedPublisher.sink(
            receiveCompletion: { completion in
                print("Completed: \(completion)")
            },
            receiveValue: { value in
                print("Value: \(value)")
            }
        )
    }

    @objc func testCombineLatest() {
        let publisher1 = PassthroughSubject<String, Never>()
        let publisher2 = PassthroughSubject<Int, Never>()

        let combinedPublisher = publisher1.combineLatest(publisher2)

        let _ = combinedPublisher.sink { value in
            print("Combined Value: \(value)")
        }

        publisher1.send("Hello")
        publisher2.send(1)         // Emits ("Hello", 1)
        publisher1.send("World")   // Emits ("World", 1)
        publisher2.send(2)
    }

    @objc func testZip() {
        let publisher1 = PassthroughSubject<String, Never>()
        let publisher2 = PassthroughSubject<Int, Never>()

        let zippedPublisher = publisher1.zip(publisher2)

        let _ = zippedPublisher.sink { value in
            print("Zipped Value: \(value)")
        }

        publisher1.send("A")
        publisher2.send(1)        // Emits ("A", 1)
        publisher1.send("B")
        publisher1.send("C")
        publisher2.send(2)        // Emits ("B", 2)
    }

    @objc func testOthers() {
//        map
//        Transforms each emitted value using a closure.
//        You can transform the emitted data type into another data type.
        let numbers = [1, 2, 3, 4, 5].publisher

        let _ = numbers
            .map { $0 * $0 } // Square each number
            .map { "The square is \($0)" } // Format as a string
            .sink { result in
                print(result)
            }

//        flat map
//        transforms each emitted value into a new publisher and flattens the resulting stream of publishers into a single, continuous stream of values. It is used to handle nested publishers and process their emitted values directly.
        struct User {
            let name: String
        }

        let userIDs = [1, 2, 3].publisher

        let _ = userIDs
            .flatMap { id in
                fetchUser(for: id) // Returns a publisher emitting User
            }
            .sink { user in
                print("Received user: \(user.name)")
            }

        func fetchUser(for id: Int) -> AnyPublisher<User, Never> {
            Just(User(name: "User \(id)"))
                .eraseToAnyPublisher()
        }

//        tryMap
//
//        Similar to map, but allows throwing errors.

        enum ConversionError: Error {
            case invalidNumber(String)
        }

        let strings = ["123", "456", "abc", "789"].publisher //Sequnce publisher

        let _ = strings
            .tryMap { str in
                guard let number = Int(str) else {
                    throw ConversionError.invalidNumber(str)
                }
                return number * 2 // Double the valid number
            }
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("All values processed successfully.")
                    case .failure(let error):
                        print("Error occurred: \(error)")
                    }
                },
                receiveValue: { value in
                    print("Processed value: \(value)")
                }
            )

//        Filter
//
//        Emits only the values that meet a specified condition.

        let numbers1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].publisher

        let _ = numbers1
            .filter { $0 % 3 == 0 } // Only keep numbers divisible by 3
            .sink { value in
                print("Filtered value: \(value)")
            }

//        CompactMap
//
//        Emits only non-nil values after transforming the input.

        let inputs = ["42", "hello", "100", "world", "300"].publisher

        let _ = inputs
            .compactMap { Int($0) } // Attempt to convert each string to an Int, ignore nil values
            .sink { value in
                print("Valid number: \(value)")
            }
    }
}

extension Notification.Name {
    static let myNotif = Notification.Name("notification")
}
