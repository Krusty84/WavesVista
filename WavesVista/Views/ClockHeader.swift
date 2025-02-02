//
//  ClockHeader.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 02/02/2025.
//

import SwiftUI

func headerClockView(solarData: SolarData) -> some View {
    return VStack(spacing: 10) {
        HStack(spacing: 10) {
            statView(title: "Forecast generated (GMT)", value: solarData.updated)
            statView(title: "Forecast generated (Local)", value: convertToLocalTime(dateString: solarData.updated) ?? "Invalid date")
        }
    }
}
