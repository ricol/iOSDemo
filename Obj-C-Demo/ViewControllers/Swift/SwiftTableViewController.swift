//
//  SwiftTableViewController.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/3/26.
//

import UIKit
import CoreTelephony
import Combine

class SwiftTableViewController: ListTableViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    @objc func testClosure() {
        let c = { (a: Int, b: Int) -> Int in
            return a + b
        }
        print(c(1, 2))
    }
    
    @objc func testAutoclosure() {
        func getFirstPositive(v1: Int, v2: @autoclosure () -> Int) -> Int {
            return v1 > 0 ? v1 : v2()
        }
        print(getFirstPositive(v1: 10, v2: 20))
    }
    
    @objc func testSecurityArchive() {
        let rabbit = Animal()
        rabbit.name = "xiaotuzi"
        let person = MyPerson()
        person.name = "ricol"
        person.pets = [rabbit]
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: person, requiringSecureCoding: true) {
            UserDefaults.standard.setValue(data, forKey: "person")
            UserDefaults.standard.synchronize()
            print("person saved.")
        }else {
            print("person archive failed.")
        }
        
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: rabbit, requiringSecureCoding: true) {
            UserDefaults.standard.setValue(data, forKey: "rabbit")
            UserDefaults.standard.synchronize()
            print("rabbit saved.")
        }else {
            print("rabbit archive failed.")
        }
        
        let ricol = MyFullPerson()
        ricol.name = "ricol"
        let xiaotuzi = MyFullPerson()
        xiaotuzi.name = "xiaotuzi"
        ricol.pets = [xiaotuzi]
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: ricol, requiringSecureCoding: true) {
            UserDefaults.standard.setValue(data, forKey: "myfullperson")
            UserDefaults.standard.synchronize()
            print("myfullperson saved.")
        }else {
            print("myfullperson archive failed.")
        }
    }
    
    @objc func testSecurityUnarchive() {
        if let data = UserDefaults.standard.value(forKey: "person") as? Data {
            print("get person succeed.")
            if let person = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MyPerson.self, from: data) {
                print("decoding person succeed.")
                person.action()
            }else {
                print("decoding person failed.")
            }
        }else {
            print("get person failed.")
        }
        
        if let data = UserDefaults.standard.value(forKey: "rabbit") as? Data {
            print("get rabbit succeed.")
            if let animal = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [Animal.self, NSString.self], from: data) as? Animal {
                print("decoding rabbit succeed.")
                animal.action()
            }else {
                print("decoding rabbit failed.")
            }
        }else {
            print("get rabbit failed.")
        }
        
        if let data = UserDefaults.standard.value(forKey: "myfullperson") as? Data {
            print("get myfullperson succeed.")
            if let myfullperson = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [MyFullPerson.self, NSString.self], from: data) as? MyFullPerson {
                print("decoding myfullperson succeed.")
                myfullperson.action()
            }else {
                print("decoding myfullperson failed.")
            }
        }else {
            print("get myfullperson failed.")
        }
    }
    
    @objc func testArchive() {
        let ricol = Employee()
        ricol.name = "ricol"
        ricol.age = 40
        ricol.gender = true
        ricol.title = "ios programmer"
        let wang = Employee()
        wang.name = "wang"
        wang.age = 40
        wang.gender = true
        wang.title = "android dev"
        let nodus = Company()
        nodus.name = "nodus"
        nodus.address = "suzhou city"
        nodus.workers = [ricol, wang]
        
        if let data = try? NSKeyedArchiver.archivedData(withRootObject: nodus) {
            print("nodus archived succeed.")
            UserDefaults.standard.setValue(data, forKey: "nodus")
            UserDefaults.standard.synchronize()
            print("nodus saved.")
        }else {
            print("nodus archive failed!")
        }
    }
    
    @objc func testUnarchive() {
        if let data = UserDefaults.standard.value(forKey: "nodus") as? Data {
            print("nodus data loaded.")
            if let nodus = NSKeyedUnarchiver.unarchiveObject(with: data) as? Company {
                print("nodus unarchive succeed")
                nodus.action()
            }else {
                print("nodus unarchive failed!")
            }
        }else {
            print("nodus data not found!")
        }
    }
    
    @objc func testTimer() {
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        timer.fireDate = Date().addingTimeInterval(10)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            timer.invalidate()
        }
    }
    
    @objc func testArchiveToFile() {
        let ricol = Employee()
        ricol.name = "ricol"
        ricol.age = 40
        ricol.gender = true
        ricol.title = "ios programmer"
        let wang = Employee()
        wang.name = "wang"
        wang.age = 40
        wang.gender = true
        wang.title = "android dev"
        let nodus = Company()
        nodus.name = "nodus"
        nodus.address = "suzhou city"
        nodus.workers = [ricol, wang]
        if let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filepath = doc.appendingPathComponent("data.dat")
            print("filepath: \(filepath.path)")
            if NSKeyedArchiver.archiveRootObject(nodus, toFile: filepath.path) {
                print("archive succeed.")
            }else {
                print("archive failed!")
            }
        }
    }
    
    @objc func testUnArchiveFromFile() {
        if let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filepath = doc.appendingPathComponent("data.dat")
            print("filepath: \(filepath.path)")
            if FileManager.default.fileExists(atPath: filepath.path) {
                do {
//                    let data = try Data(contentsOf: filepath)
                    let data = try? NSKeyedUnarchiver.unarchiveObject(withFile: filepath.path)
                    print("unarchive succeed.")
                    if let nodus = data as? Company {
                        nodus.action()
                    }else {
                        print("failed to convert to Company!")
                    }
                }
                catch (let e) {
                    print("exception: \(e)")
                }
            }else {
                print("file doesn't exist.")
            }
        }
    }
    
    @objc private func timer() {
        print("[\(Date())]timer...")
    }
    
    @objc private func testMacros() {
        print("#file: \(#file)")
        print("#line: \(#line)")
        print("#column: \(#column)")
        print("#function: \(#function)")
        print("#dsohandle: \(#dsohandle)")
        
        func testFunc() {
            print("#file: \(#file)")
            print("#line: \(#line)")
            print("#column: \(#column)")
            print("#function: \(#function)")
            print("#dsohandle: \(#dsohandle)")
        }
        
        testFunc()
    }
    
    @objc private func testSwiftUI() {
        
    }
    
    @objc func testNavigation() {
        
    }
    
    @objc func testModelConvert() {
        let p = Person(name: "ricolwang", age: 42, gender: .male)
        do {
            let data = try JSONEncoder().encode(p)
            print("JSONEncoder to encode a object -> data: \(data)")
            let json = try JSONSerialization.jsonObject(with: data)
            print("JSONSerialization.jsonObject to parse data to json: \(json)")
            let object = try JSONDecoder().decode(Person.self, from: data)
            print("JSONDecoder to decode data -> object: \(object)")
            if let jsondata = p.toJSONData {
                print("object to jsonData -> \(jsondata)")
            }
            let dict = p.toStringDictionary
            print("object to dictionary -> \(dict)")
            let map = p.dictionaryRepresentation
            print("object dictionaryRepresentation: \(map)")
        } catch {
            print("error: \(error)")
        }
    }
}

struct Person: Codable {
    enum Gender: Codable {
        case male, female
    }
    
    let name: String
    let age: Int
    let gender: Gender
}

class Entity: NSObject, NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String
    }
    
    override init() {
        
    }
    
    var name: String?
    func action() {
        print("Entity: \(name)")
    }
}

class Employee: Entity {
    var age: Int?
    var gender: Bool = false
    var title: String?
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(age, forKey: "age")
        coder.encode(gender, forKey: "gender")
        coder.encode(title, forKey: "title")
    }
    
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        age = coder.decodeObject(forKey: "age") as? Int
        gender = coder.decodeBool(forKey: "gender")
        title = coder.decodeObject(forKey: "title") as? String
    }
    
    override func action() {
        print("Employee: \(name), \(age), \(title)...")
    }
}

class Company: Entity {
    var address: String?
    var workers = [Employee]()
    
    override init() {
        super.init()
    }
    
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(address, forKey: "address")
        coder.encode(workers, forKey: "workers")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        address = coder.decodeObject(forKey: "address") as? String
        workers = coder.decodeObject(forKey: "workers") as? [Employee] ?? [Employee]()
    }
    
    override func action() {
        print("Company: \(name), \(address), \(workers)...")
        for w in workers {
            w.action()
        }
    }
}

class Animal: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    override init() {
        
    }
    func encode(with coder: NSCoder) {
        coder.encode(gender, forKey: "gender")
        coder.encode(name, forKey: "name")
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as? String
        self.gender = coder.decodeBool(forKey: "gender")
    }
    
    var name: String?
    var gender: Bool = false
    func action() {
        print("\(name)...")
    }
}

class MyPerson: Animal {
    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        coder.encode(pets, forKey: "pets")
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.pets = coder.decodeArrayOfObjects(ofClasses: [Animal.self, NSString.self], forKey: "pets") as? [Animal] ?? [Animal]()
    }
    
    var pets = [Animal]()
    override func action() {
        print("\(name)...with pets: \(pets)")
    }
}

class MyFullPerson: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    override init() {
        
    }
    func encode(with coder: NSCoder) {
        coder.encode(gender, forKey: "gender")
        coder.encode(name, forKey: "name")
        coder.encode(pets, forKey: "pets")
    }
    
    required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: "name") as? String
        self.gender = coder.decodeBool(forKey: "gender")
        self.pets = coder.decodeArrayOfObjects(ofClasses: [MyFullPerson.self, NSString.self], forKey: "pets") as? [MyFullPerson] ?? [MyFullPerson]()
    }
    
    var name: String?
    var gender: Bool = false
    var pets = [MyFullPerson]()
    func action() {
        print("\(name)...with pets: \(pets)")
    }
}

public extension Optional {
    var toJSONData: Data? {
        if let val = self as? Encodable {
            return val.toJSONData
        }
        return nil
    }

    var dictionaryRepresentation: [String: Any]? {
        if let val = self as? Encodable {
            return val.dictionaryRepresentation
        }
        return nil
    }

    var toStringDictionary: [String: String]? {
        if let val = self as? Encodable {
            return val.toStringDictionary
        }
        return nil
    }
}

public extension Encodable {
    var toJSONData: Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            assertionFailure("HTTP request parameter encode error: \(error)")
        }
        return nil
    }

    var toStringDictionary: [String: String] {
        dictionaryRepresentation.mapValues { value -> String in
            if type(of: value) == type(of: NSNumber(value: true)) {
                return String(value as! Bool)
            } else {
                return "\(value)"
            }
        }
    }

    var dictionaryRepresentation: [String: Any] {
        guard let jsonData = toJSONData else { return [:] }

        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                return [:]
            }
            return dictionary
        } catch {
            assertionFailure("Invalid JSON data with error:\(error)")
        }

        return [:]
    }
}
