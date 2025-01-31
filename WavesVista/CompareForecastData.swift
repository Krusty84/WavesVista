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

