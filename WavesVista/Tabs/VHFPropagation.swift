//
//  VHFPropagation.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 10/01/2025.
//

import SwiftUI

struct VHFPropagationTabContent: View {
    @EnvironmentObject var viewModel: PropagationModel
    var body: some View {
        VStack() {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let solarData = viewModel.solarData {
                VHFBandConditionsView(solarData: solarData)
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
            if let lastUpdateTime = viewModel.lastRefreshDate {
                LastUpdateView(lastUpdateTime: lastUpdateTime)
            }
        }
    }
}

struct VHFBandConditionsView: View {
    @EnvironmentObject var viewModel: PropagationModel
    let solarData: SolarData
    
    // Define three columns: Phenomenon Name, Location, Condition
    private let columns = [
        GridItem(.flexible(minimum: 120)), // Phenomenon Name
        GridItem(.flexible(minimum: 120)), // Location
        GridItem(.flexible(minimum: 120))  // Condition
    ]
    
    var body: some View {
        VStack{
            headerClockView(solarData: viewModel.solarData!)
            phenomenonGrid
                .padding(20)
        }
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(maxWidth: 600)
    }

    private var phenomenonGrid:some View {
        LazyVGrid(columns: columns, spacing: 16) {
            // Header row
            Text("Phenomenon").fontWeight(.bold)
            Text("Location").fontWeight(.bold)
            Text("Condition").fontWeight(.bold)
            
            // Rows for each phenomenon
            ForEach(solarData.calculatedVhfConditions, id: \.self) { condition in
                let key = VhfKey(phenomenonName: condition.phenomenonName, location: condition.location)
                
                Text(transformPhenomenonName(condition.phenomenonName))
                    .font(.headline)
                    .onTapGesture {
                        toggleVhfTracking(key)
                    }
                
                Text(condition.location.replacingOccurrences(of: "_", with: " "))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        toggleVhfTracking(key)
                    }
                
                HStack(spacing: 4) {
                    Text(condition.condition)
                        .fontWeight(.semibold)
                    
                    // Show magnifying glass if user is tracking this phenomenon
                    if viewModel.trackedVhfKeys.contains(key) {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    colorForCondition(condition.condition).opacity(0.2)
                )
                .cornerRadius(8)
                .onTapGesture {
                    toggleVhfTracking(key)
                }
                .help("Click to track/untrack this forecast slot.")
            }
        }
    }
    
    /// Add/remove the VHF key from the user's tracked set
    private func toggleVhfTracking(_ key: VhfKey) {
        if viewModel.trackedVhfKeys.contains(key) {
            viewModel.trackedVhfKeys.remove(key)
        } else {
            viewModel.trackedVhfKeys.insert(key)
        }
    }
    
    private func transformPhenomenonName(_ name: String) -> String {
        name == "E-Skip" ? "Es(SpE)" : name
    }
    
    private func colorForCondition(_ condition: String) -> Color {
        switch condition.lowercased() {
            case "band closed": return .red
            case "50mhz es":    return .green
            case "no report":   return .gray
            default:            return .blue
        }
    }
}
