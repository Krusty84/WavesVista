//
//  SolarData.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 10/01/2025.
//

import SwiftUI
import Foundation

struct SolarWeatherTabContent: View {
    //@StateObject private var viewModel = PropagationModel()
    @EnvironmentObject var viewModel: PropagationModel
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
            if let lastUpdateTime = viewModel.lastRefreshDate {
                LastUpdateView(lastUpdateTime: lastUpdateTime)
            }
        }
    }
}
    
    struct GeneralSolarData: View {
        @EnvironmentObject var viewModel: PropagationModel
        let solarData: SolarData
        var body: some View {
            VStack () {
                headerClockView(solarData: viewModel.solarData!)
                solarWeatherGrid
                    .padding(20)
            }
            .cornerRadius(12)
            .shadow(radius: 5)
            .frame(maxWidth: 600)
        }
        
        private var solarWeatherGrid:some View {
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

