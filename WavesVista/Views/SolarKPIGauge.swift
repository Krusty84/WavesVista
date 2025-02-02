//
//  SolarKPIGauge.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 02/02/2025.
//

import SwiftUI

struct SolarFluxAndKIndexView: View {
    @EnvironmentObject var viewModel: PropagationModel

    // Constants for Solar Flux
    let minValueSolarFlux = 60.0
    let maxValueSolarFlux = 250.0
    let gradientSolarFlux = Gradient(colors: [.red, .yellow, .orange, .green])
    
    // Constants for K Index
    let minValueKIndex = 0.0
    let maxValueKIndex = 9.0
    let gradientKIndex = Gradient(colors: [.black, .red, .yellow, .green])
    
    // Computed values from your view model data
    private var solarFluxValue: Double {
        Double(viewModel.solarData?.solarflux ?? "") ?? 0.0
    }
    
    private var kIndexValue: Double {
        Double(viewModel.solarData?.kindex ?? "") ?? 0.0
    }
    
    private var aIndexValue: Double {
        Double(viewModel.solarData?.aindex ?? "") ?? 0.0
    }
    
    var body: some View {
        VStack(spacing: 5) {
            // Solar Flux Gauge Block
            VStack(spacing: 2) {
                Text("Solar Flux: \(Int(solarFluxValue))")
                    .font(.footnote)
                    .foregroundColor(.primary)
                Gauge(value: solarFluxValue, in: minValueSolarFlux...maxValueSolarFlux) { }
                currentValueLabel: {
                    Text("\(Int(solarFluxValue))")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                minimumValueLabel: {
                    Text("\(Int(minValueSolarFlux))")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                maximumValueLabel: {
                    Text("\(Int(maxValueSolarFlux))")
                        .font(.footnote)
                        .foregroundColor(.green)
                }
                .gaugeStyle(AccessoryLinearGaugeStyle())
                .tint(gradientSolarFlux)
                .padding(.horizontal, 30)
            }
            
            // K Index Gauge Block
            VStack(spacing: 2) {
                Text("K-Index: \(Int(kIndexValue))  A-Index: \(Int(aIndexValue))")
                    .font(.footnote)
                    .foregroundColor(.primary)
                Gauge(value: kIndexValue, in: minValueKIndex...maxValueKIndex) { }
                currentValueLabel: {
                    Text("\(Int(kIndexValue))")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                minimumValueLabel: {
                    Text("\(Int(minValueKIndex))")
                        .font(.footnote)
                        .foregroundColor(.black)
                }
                maximumValueLabel: {
                    Text("\(Int(maxValueKIndex))")
                        .font(.footnote)
                        .foregroundColor(.green)
                }
                .gaugeStyle(AccessoryLinearGaugeStyle())
                .tint(gradientKIndex)
                .padding(.horizontal, 30)
            }
        }
    }
}
