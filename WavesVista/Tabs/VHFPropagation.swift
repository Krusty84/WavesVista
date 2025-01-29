//
//  VHFPropagation.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 10/01/2025.
//

import SwiftUI

struct VHFPropagationTabContent: View {
    //@StateObject private var viewModel = PropagationModel()
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
                        Text("Last update: \(lastUpdateTime, formatter: dateFormatter)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
        }
//        .onAppear {
//            viewModel.fetchSolarData()
//        }
    }
    private  let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .medium
        return df
    }()
}


struct VHFBandConditionsView: View {
    let solarData: SolarData

        // Define three columns: Phenomenon Name, Location, Condition
        private let columns = [
            GridItem(.flexible(minimum: 120)), // Phenomenon Name
            GridItem(.flexible(minimum: 120)), // Location
            GridItem(.flexible(minimum: 120))  // Condition
        ]
        
        var body: some View {
            VStack {
                Text("VHF Propagation Conditions")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    // Header row
                    Text("Phenomenon")
                        .fontWeight(.bold)
                    Text("Location")
                        .fontWeight(.bold)
                    Text("Condition")
                        .fontWeight(.bold)
                    
                    // Rows for each phenomenon
                    ForEach(solarData.calculatedVhfConditions, id: \.self) { condition in
                        Text(transformPhenomenonName(condition.phenomenonName))
                            .font(.headline)
                        
                        Text(condition.location.replacingOccurrences(of: "_", with: " "))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(condition.condition)
                            .fontWeight(.semibold)
                            .foregroundColor(colorForCondition(condition.condition))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(colorForCondition(condition.condition).opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding(10)
            }
            .padding()
            .cornerRadius(12)
            .shadow(radius: 5)
            .frame(maxWidth: 600)
        }
        
        // MARK: - Helper for Colors
        private func colorForCondition(_ condition: String) -> Color {
            switch condition.lowercased() {
            case "band closed": return .red
            case "50mhz es":    return .green
            case "no report":   return .gray
            default:            return .blue
            }
        }
    
    private func transformPhenomenonName(_ name: String) -> String {
           return name == "E-Skip" ? "Es(SpE)" : name
       }
    }
