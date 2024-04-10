//
//  extensions.swift
//  Obj-C-Demo
//
//  Created by Ricol Wang on 2024/2/22.
//

import Foundation
import UIKit

extension NSObject {
    
}

extension UIView {
    
    func findChildLabel() -> [UILabel] {
        var data = [UILabel]()
        for s in self.subviews {
            if let lbl = s as? UILabel, s is UILabel { data.append(lbl) }
            else {
                data += s.findChildLabel()
            }
        }
        return data
    }
}

func fetchTemperatures(completion: @escaping ([Float]) -> Void) throws {
    let session = URLSession.shared
    if let url = URL(string: "https://weather.io/api/forecast_16") {
        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion([])
                return
            }
            do {
                let result = try JSONDecoder().decode([Float].self, from: data)
                completion(result.map { $0 })
            }catch {
            }
        }
    }
}


