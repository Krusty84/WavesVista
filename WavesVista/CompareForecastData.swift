//
//  CompareForecastData.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 29/01/2025.
//

extension CalculatedCondition: Equatable {
    static func == (lhs: CalculatedCondition, rhs: CalculatedCondition) -> Bool {
        lhs.bandName == rhs.bandName &&
        lhs.time == rhs.time &&
        lhs.condition == rhs.condition
    }
}

extension CalculatedVhfCondition: Equatable {
    static func == (lhs: CalculatedVhfCondition, rhs: CalculatedVhfCondition) -> Bool {
        lhs.phenomenonName == rhs.phenomenonName &&
        lhs.location == rhs.location &&
        lhs.condition == rhs.condition
    }
}

extension SolarData: Equatable {
    static func == (lhs: SolarData, rhs: SolarData) -> Bool {
        // Compare relevant fields:
        return lhs.solarflux == rhs.solarflux &&
               lhs.aindex == rhs.aindex &&
               lhs.kindex == rhs.kindex &&
               lhs.sunspots == rhs.sunspots &&
               lhs.calculatedConditions == rhs.calculatedConditions &&
               lhs.calculatedVhfConditions == rhs.calculatedVhfConditions
    }
}

//func handleChangedData(oldData: SolarData, newData: SolarData) {
//    // MARK: 1. Compare HF conditions
//    let oldHFDict = Dictionary(
//        uniqueKeysWithValues: oldData.calculatedConditions.map {
//            // Key: "80m-40m (day)", Value: e.g. "Poor"
//            (bandTimeKey($0), $0.condition)
//        }
//    )
//    
//    let newHFDict = Dictionary(
//        uniqueKeysWithValues: newData.calculatedConditions.map {
//            (bandTimeKey($0), $0.condition)
//        }
//    )
//    
//    var changedHF: [String] = []
//    
//    // Only mention if oldCond != newCond for the same key
//    for (key, newCond) in newHFDict {
//        if let oldCond = oldHFDict[key], oldCond != newCond {
//            // e.g.: "Forecast for 80m-40m (day) changed"
//            changedHF.append("Forecast for \(key) changed")
//        }
//    }
//    
//    // MARK: 2. Compare VHF conditions if you want the same style
//    // (Remove if you only care about HF)
//    let oldVHFDict = Dictionary(
//        uniqueKeysWithValues: oldData.calculatedVhfConditions.map {
//            (vhfKey($0), $0.condition)
//        }
//    )
//    let newVHFDict = Dictionary(
//        uniqueKeysWithValues: newData.calculatedVhfConditions.map {
//            (vhfKey($0), $0.condition)
//        }
//    )
//    
//    var changedVHF: [String] = []
//    for (key, newCond) in newVHFDict {
//        if let oldCond = oldVHFDict[key], oldCond != newCond {
//            changedVHF.append("Forecast for \(key) changed")
//        }
//    }
//    
//    // MARK: 3. Notify if changes exist
//    let allChanges = changedHF + changedVHF
//    guard !allChanges.isEmpty else { return }
//    
//    let message = allChanges.joined(separator: "\n")
//    
//    // Post a single macOS notification with the summarized changes
//    NotificationManager.shared.postNotification(
//        title: "Propagation Data Changed",
//        body: message
//    )
//}
//
///// Helper to create a short key like "80m-40m (day)"
//private func bandTimeKey(_ condition: CalculatedCondition) -> String {
//    "\(condition.bandName) (\(condition.time.lowercased()))"
//}
//
///// Helper to create a short key like "E-Skip (northern_hemi)"
//private func vhfKey(_ condition: CalculatedVhfCondition) -> String {
//    "\(condition.phenomenonName) (\(condition.location))"
//}


