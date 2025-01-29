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

func handleChangedData(oldData: SolarData, newData: SolarData) {
    // MARK: 1. Compare HF conditions
    // Create a dictionary from the old HF data, keyed by (bandName + time), with value = old condition
    let oldHFDict = Dictionary(uniqueKeysWithValues: oldData.calculatedConditions.map {
        let key = "\($0.bandName.lowercased())-\($0.time.lowercased())"
        return (key, $0.condition)
    })
    
    // Create a dictionary from the new HF data, keyed by the same
    let newHFDict = Dictionary(uniqueKeysWithValues: newData.calculatedConditions.map {
        let key = "\($0.bandName.lowercased())-\($0.time.lowercased())"
        return (key, $0.condition)
    })
    
    // Check for changed HF conditions
    var changedHF: [String] = []
    for (key, newCond) in newHFDict {
        let oldCond = oldHFDict[key]
        // If oldCond exists but differs from newCond, record it
        if let oldCond = oldCond, oldCond != newCond {
            // e.g. "20m-30m (day) changed from Poor to Good"
            changedHF.append("\(key) changed from \(oldCond) to \(newCond)")
        }
        // If oldCond == nil, that means it's new or didn't exist in old data
        // you can decide how to handle "new" band/time
    }
    
    // (Optional) Check for any HF keys that *disappeared* in the new data
    // for example, if a band/time was removed from the feed
    for (key, oldCond) in oldHFDict {
        if newHFDict[key] == nil {
            // That band/time no longer appears
            changedHF.append("\(key) was removed (old condition \(oldCond))")
        }
    }
    
    
    // MARK: 2. Compare VHF conditions
    // Similar approach:
    let oldVHFDict = Dictionary(uniqueKeysWithValues: oldData.calculatedVhfConditions.map {
        let key = "\($0.phenomenonName.lowercased())-\($0.location.lowercased())"
        return (key, $0.condition)
    })
    
    let newVHFDict = Dictionary(uniqueKeysWithValues: newData.calculatedVhfConditions.map {
        let key = "\($0.phenomenonName.lowercased())-\($0.location.lowercased())"
        return (key, $0.condition)
    })
    
    var changedVHF: [String] = []
    for (key, newCond) in newVHFDict {
        let oldCond = oldVHFDict[key]
        if let oldCond = oldCond, oldCond != newCond {
            changedVHF.append("\(key) changed from \(oldCond) to \(newCond)")
        }
        // If oldCond == nil, we could treat as "new phenomenon"
    }
    
    // Check for removed phenomenon
    for (key, oldCond) in oldVHFDict {
        if newVHFDict[key] == nil {
            changedVHF.append("\(key) was removed (old condition \(oldCond))")
        }
    }
    
    
    // MARK: 3. Log or notify the changes
    if !changedHF.isEmpty {
        print("HF changes found:")
        changedHF.forEach { print(" - \($0)") }
    }
    if !changedVHF.isEmpty {
        print("VHF changes found:")
        changedVHF.forEach { print(" - \($0)") }
    }
    
    // If you want a single notification summarizing changes:
    let changesCount = changedHF.count + changedVHF.count
    if changesCount > 0 {
        let summary = (changedHF + changedVHF).joined(separator: "\n")
        // e.g. Post macOS system notification
        NotificationManager.shared.postNotification(
            title: "Propagation Data Changed (\(changesCount) updates)",
            body: summary
        )
    }
}

