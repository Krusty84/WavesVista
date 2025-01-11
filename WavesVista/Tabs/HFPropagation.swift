//
//  Propagation.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 22/12/2024.
//

import SwiftUI

struct HFPropagationTabContent: View {
    @StateObject private var viewModel = PropagationModel()

    var body: some View {
        VStack() {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let solarData = viewModel.solarData {
                HFBandConditionsView(solarData: solarData)
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
        }
        .onAppear {
            viewModel.fetchSolarData()
        }
    }
}

struct HFBandConditionsView: View {
    let solarData: SolarData
    
    // Define three columns: Band Name, Day Propagation, Night Propagation
    private let columns = [
        GridItem(.flexible(minimum: 80)), // Band Name
        GridItem(.flexible(minimum: 80)), // Day
        GridItem(.flexible(minimum: 80))  // Night
    ]
    
    // Determine whether it's currently day at the user's location
    private var isDayTime: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return (hour >= 6 && hour < 18)
    }
    
    var body: some View {
        VStack () {
            headerView
            bandsGrid.padding(10)
            Spacer()
        }
        .padding()
        //.background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(maxWidth: 600)
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 10) {
//            Text("Solar-Terrestrial Data")
//                .font(.title2)
//                .fontWeight(.bold)
            HStack(spacing: 10) {
                statView(title: "Updated (GMT)", value: solarData.updated)
                statView(title: "Updated (Local)", value: convertToLocalTime(dateString: solarData.updated) ?? "Invalid date")
            }
//            HStack(spacing: 0) {
//                statView(title: "Updated", value: solarData.updated)
//                statView(title: "Flux", value: solarData.solarflux)
//                statView(title: "A-Index", value: solarData.aindex)
//                statView(title: "K-Index", value: solarData.kindex)
//                statView(title: "X-Ray", value: solarData.xray)
//                statView(title: "Sunspots", value: solarData.sunspots)
//            }
        }
    }
    
    private func statView(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.headline)
                //.foregroundColor(.secondary)
            Text(value)
                .font(.caption)
        }
        .frame(minWidth: 60)
    }
    
    // MARK: - Bands Grid
    private var bandsGrid: some View {
        // Group conditions by band
        let groupedByBand = Dictionary(grouping: solarData.calculatedConditions) { $0.bandName }
        let sortedBandNames = groupedByBand.keys.sorted()
        
        return LazyVGrid(columns: columns, spacing: 16) {
            // Header row
            Text("Band")
                .fontWeight(.bold)
            Text("Day")
                .fontWeight(.bold)
            Text("Night")
                .fontWeight(.bold)
            
            // Rows for each band
            ForEach(sortedBandNames, id: \.self) { band in
                let conditions = groupedByBand[band] ?? []
                let dayCondition = conditions.first(where: { $0.time.lowercased() == "day" })
                let nightCondition = conditions.first(where: { $0.time.lowercased() == "night" })
                
                // Band name column
                Text(band)
                    .font(.headline)
                
                // Day propagation column
                if let dc = dayCondition {
                    // Highlight if it's day time
                    conditionTile(dc, highlight: isDayTime)
                } else {
                    missingConditionTile("N/A")
                }
                
                // Night propagation column
                if let nc = nightCondition {
                    // Highlight if it's night time
                    conditionTile(nc, highlight: !isDayTime)
                } else {
                    missingConditionTile("N/A")
                }
            }
        }
    }
    
    // MARK: - Condition and Missing Tiles
    private func conditionTile(_ condition: CalculatedCondition, highlight: Bool) -> some View {
        let conditionValue = condition.condition.lowercased()
        let shouldHighlight = highlight && (conditionValue == "good" || conditionValue == "fair")
        
        return Text(condition.condition)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(colorForCondition(condition.condition))
            .cornerRadius(8)
            .overlay(
                // Apply border only if shouldHighlight is true
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black, lineWidth: shouldHighlight ? 2 : 0)
                                .padding(-2)
            )
    }
    
    private func missingConditionTile(_ label: String) -> some View {
        Text(label)
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
    
    // MARK: - Helper for Colors
    private func colorForCondition(_ condition: String) -> Color {
        switch condition.lowercased() {
        case "excellent": return .green
        case "good":      return .mint
        case "fair":      return .yellow
        case "poor":      return .red
        default:          return .gray
        }
    }
}


//#Preview () {
//    HFPropagationTabContent().frame(width: 500, height: 300)
//}
