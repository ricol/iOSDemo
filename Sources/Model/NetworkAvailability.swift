//
//  NetworkAvailability.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/8/22.
//

import Foundation
import CoreTelephony

class NetworkAvailability {
    static let cellularData = CTCellularData()
    static func startMonitor() {
        cellularData.cellularDataRestrictionDidUpdateNotifier = { newState in
            print("new state: \(newState.getDisplay())")
        }
    }
    static func stopMonitor() {
        cellularData.cellularDataRestrictionDidUpdateNotifier = nil
    }
}

extension CTCellularDataRestrictedState {
    func getDisplay() -> String {
        switch self {
        case .restrictedStateUnknown:
            "restrictedStateUnknown"
        case .restricted:
            "restricted"
        case .notRestricted:
            "notRestricted"
        default:
            "unknow"
        }
    }
}
