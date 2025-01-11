//
//  SolarData.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 10/01/2025.
//

import SwiftUI
import Foundation

struct SolarWeatherTabContent: View {
    @StateObject private var viewModel = PropagationModel()
    
    var body: some View {
        VStack() {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let solarData = viewModel.solarData {
                GeneralSolarData(solarData: solarData)
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

struct GeneralSolarData: View {
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
            HStack(spacing: 10) {
                statView(title: "Updated (GMT)", value: solarData.updated)
                statView(title: "Updated (Local)", value: convertToLocalTime(dateString: solarData.updated) ?? "Invalid date")
            }
            Grid(horizontalSpacing: 16, verticalSpacing: 16) {
                GridRow {
                    statView(title: "Flux", value: solarData.solarflux)
                    statView(title: "A-Index", value: solarData.aindex)
                    statView(title: "K-Index", value: solarData.kindex)
                    statView(title: "X-Ray", value: solarData.xray)
                    statView(title: "Sunspots", value: solarData.sunspots)
                    statView(title: "Helium Line", value: solarData.heliumline)
                }.padding(5)
                GridRow {
                    statView(title: "Solar Wind", value: solarData.solarwind)
                    statView(title: "Proton Flux", value: solarData.protonflux)
                    statView(title: "Electron Flux", value: solarData.electonflux)
                    statView(title: "Aurora", value: solarData.aurora)
                    statView(title: "Normaliztion", value: solarData.normalization)
                    statView(title: "Aurora Latitude", value: solarData.latdegree)
                }.padding(5)
                GridRow{
                    statView(title: "Mag (Bz)", value: solarData.magneticfield)
                    statView(title: "Signal/Noise Level", value: solarData.signalnoise)
                    statView(title: "foF2", value: solarData.fof2)
                    statView(title: "MUF", value: solarData.muf)
                    statView(title: "MUF Factor", value: solarData.muffactor)
                    Spacer()
                    Spacer()
                }
            }
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

}
