//
//  HFPropagation.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 22/12/2024.
//

import SwiftUI

struct HFPropagationTabContent: View {
    @EnvironmentObject var viewModel: PropagationModel
    //
    let minValue = 60.0
    let maxValue = 250.0
    let gradient = Gradient(colors: [.red, .yellow, .orange, .green])
    //
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
            
            let solarFluxValue = Double(viewModel.solarData?.solarflux ?? "") ?? 0.0
            Text("Solar Flux") // Add a title for the gauge
                .font(.footnote) // Customize the font
                .foregroundColor(.primary)
            Gauge(value: solarFluxValue, in: minValue...maxValue) {
            } currentValueLabel: {
                Text("\(Int(solarFluxValue))")
                    .font(.footnote)
                    .foregroundColor(Color.red)
            } minimumValueLabel: {
                Text("\(Int(minValue))")
                    .font(.footnote)
                    .foregroundColor(Color.red)
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
                    .font(.footnote)
                    .foregroundColor(Color.green)
            }
            .gaugeStyle(AccessoryLinearGaugeStyle())
            .tint(gradient)
            .padding(.horizontal, 20)
            //
            Gauge(value: solarFluxValue, in: minValue...maxValue) {
            } currentValueLabel: {
                Text("\(Int(solarFluxValue))")
                    .foregroundColor(Color.red)
                    .font(.footnote)
            } minimumValueLabel: {
                Text("\(Int(minValue))")
                    .foregroundColor(Color.red)
                    .font(.footnote)
            } maximumValueLabel: {
                Text("\(Int(maxValue))")
                    .foregroundColor(Color.green)
                    .font(.footnote)
            }
            .gaugeStyle(AccessoryLinearGaugeStyle())
            .tint(gradient)
            .padding(.horizontal, 20)
            
            if let lastUpdateTime = viewModel.lastRefreshDate {
                LastUpdateView(lastUpdateTime: lastUpdateTime)
            }            
        }
    }
        //        .onAppear {
        //            viewModel.fetchSolarData()
        //        }
}

struct HFBandConditionsView: View {
    @EnvironmentObject var viewModel: PropagationModel
    let solarData: SolarData
    
    private let columns = [
        GridItem(.flexible(minimum: 80)), // Band Name
        GridItem(.flexible(minimum: 80)), // Day
        GridItem(.flexible(minimum: 80))  // Night
    ]
    
    var body: some View {
        VStack {
            headerClockView(solarData: viewModel.solarData!)
            hfBandsGrid
                .padding(20)
        }
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(maxWidth: 600)
    }
    
    private var hfBandsGrid: some View {
        let groupedByBand = Dictionary(grouping: solarData.calculatedConditions) { $0.bandName }
        let sortedBandNames = groupedByBand.keys.sorted()
        
        return LazyVGrid(columns: columns, spacing: 16) {
            // Header row
            Text("Band").fontWeight(.bold)
            Text("Day").fontWeight(.bold)
            Text("Night").fontWeight(.bold)
            
            // Rows for each band
            ForEach(sortedBandNames, id: \.self) { band in
                let conditions = groupedByBand[band] ?? []
                let dayCondition = conditions.first { $0.time.lowercased() == "day" }
                let nightCondition = conditions.first { $0.time.lowercased() == "night" }
                
                // 1) Band name column
                Button(action: {
                    handleBandSelection(band: band)
                }) {
                    Text(band)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .underline()
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { isHovering in
                    if isHovering { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                }
                .help("Go to DX Cluster")
                
                // 2) Day column
                if let dc = dayCondition {
                    let bandTime = BandTime(bandName: band, time: "day")
                    conditionTile(dc, highlight: isDayTime, isSelected: viewModel.trackedBandTimes.contains(bandTime)) {
                        // Toggling user selection
                        toggleSelection(bandTime)
                    }
                } else {
                    missingConditionTile("N/A")
                }
                
                // 3) Night column
                if let nc = nightCondition {
                    let bandTime = BandTime(bandName: band, time: "night")
                    conditionTile(nc, highlight: !isDayTime, isSelected: viewModel.trackedBandTimes.contains(bandTime)) {
                        // Toggling user selection
                        toggleSelection(bandTime)
                    }
                } else {
                    missingConditionTile("N/A")
                }
            }
        }
    }
    
    /// Toggles a specific (bandName, time) in the model's trackedBandTimes set
    private func toggleSelection(_ bandTime: BandTime) {
        if viewModel.trackedBandTimes.contains(bandTime) {
            viewModel.trackedBandTimes.remove(bandTime)
        } else {
            viewModel.trackedBandTimes.insert(bandTime)
        }
    }
    
    private func handleBandSelection(band: String) {
        // Show a DX cluster link or whatever
        switch band {
            case "12m-10m":
                openWebBrowser(browserUrl: URL(string: SettingsManager.shared.dxCluster1210url)!)
            case "17m-15m":
                openWebBrowser(browserUrl: URL(string: SettingsManager.shared.dxCluster1715url)!)
            case "30m-20m":
                openWebBrowser(browserUrl: URL(string: SettingsManager.shared.dxCluster3020url)!)
            case "80m-40m":
                openWebBrowser(browserUrl: URL(string: SettingsManager.shared.dxCluster8040url)!)
            default:
                break
        }
    }
    
    private func conditionTile(
        _ condition: CalculatedCondition,
        highlight: Bool,
        isSelected: Bool,
        toggleHFTracking: @escaping () -> Void
    ) -> some View {
        let conditionValue = condition.condition.lowercased()
        let shouldHighlight = highlight && (conditionValue == "good" || conditionValue == "fair")
        
        return HStack(spacing: 4) {
            Text(condition.condition)
                .fontWeight(.semibold)
            
            // If user selected this band/time, show a small magnifying glass icon
            if isSelected {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(colorForCondition(condition.condition))
        .cornerRadius(8)
        .overlay(
            // Keep the black border highlight for "good"/"fair" if you want
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: shouldHighlight ? 2 : 0)
                .padding(-2)
        )
        // Tapping toggles the user’s tracking selection
        .onTapGesture {
            toggleHFTracking()
        }
        .help("Click to track/untrack this forecast slot.")
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
    
    private func colorForCondition(_ condition: String) -> Color {
        switch condition.lowercased() {
            case "excellent": return .green
            case "good":      return .mint
            case "fair":      return .yellow
            case "poor":      return .red
            default:          return .gray
        }
    }
    
    private var isDayTime: Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return (hour >= 6 && hour < 18)
    }
}
