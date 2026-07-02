//
//  SwiftObjectCRunTimeViewController.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2025/4/24.
//

class ObjectCRunTimeViewController: ListTableViewController {
    @objc func testInstanceMethod() {
        if let method = NSObject.instanceMethod(for: #selector(testMethodExchange1)) {
            print(method)
        }
        if let method = method(for: #selector(testMethodExchange1)) {
            print(method)
        }
    }
    
    @objc static func staticMethod() {
    }
    
    @objc func testClassMethod() {
        if let method = class_getClassMethod(ObjectCRunTimeViewController.self, #selector(ObjectCRunTimeViewController.staticMethod)) {
            print(method)
        }
    }
    
    @objc func testMethodExchange1() {
        class A {
            @objc dynamic func fun1() {
                print("fun1...\(#function)")
            }
            
            @objc dynamic func fun2() {
                print("fun2...\(#function)")
            }
        }
        
        print("before method swizzling...")
        let a = A()
        a.fun1()
        a.fun2()
        
        let selector1 = #selector(A.fun1)
        let selector2 = #selector(A.fun2)
        let sel1 = class_getInstanceMethod(A.self, selector1)!
        let sel2 = class_getInstanceMethod(A.self, selector2)!
        method_exchangeImplementations(sel1, sel2)
        
        print("after method swizzling...")
        a.fun1()
        a.fun2()
        
        print("restore...")
        method_exchangeImplementations(sel1, sel2)
        a.fun1()
        a.fun2()
    }
    
    @objc func testMethodExchange2() {
        class A {
            @objc dynamic func fun1() {
                print("fun1...\(#function)")
            }
            
            @objc dynamic func fun2() {
                print("fun2...\(#function)")
                print("call fun2...")
                fun2()
            }
        }
        
        let a = A()
        
        let selector1 = #selector(A.fun1)
        let selector2 = #selector(A.fun2)
        let sel1 = class_getInstanceMethod(A.self, selector1)!
        let sel2 = class_getInstanceMethod(A.self, selector2)!
        method_exchangeImplementations(sel1, sel2)
        
        print("after method swizzling...")
        a.fun1()
        a.fun2()
    }
}
