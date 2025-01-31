//
//  Settings.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 22/12/2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("solarWeatherApiUrl") private var solarWeatherApiUrl: String = SettingsManager.shared.solarWeatherApiUrl
    @AppStorage("dxCluster8040url") private var dxCluster8040url: String = SettingsManager.shared.dxCluster8040url
    @AppStorage("dxCluster3020url") private var dxCluster3020url: String = SettingsManager.shared.dxCluster3020url
    @AppStorage("dxCluster1715url") private var dxCluster1715url: String = SettingsManager.shared.dxCluster1715url
    @AppStorage("dxCluster1210url") private var dxCluster1210url: String = SettingsManager.shared.dxCluster1210url
    @AppStorage("autoRefreshInterval") private var autoRefreshInterval: Double = SettingsManager.shared.autoRefreshInterval
    @State private var isEditingEnabled: Bool = false
    @State private var selectedTab: Int = 0
    var body: some View {
        VStack {
            // Tabs at the top
            Picker("", selection: $selectedTab) {
                Text("General").tag(0)
                Text("End-points").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            // Content under the tabs
            switch selectedTab {
            case 0:
                Stepper(value: $autoRefreshInterval, in: 10...1440, step: 1) {
                        Text("Auto Refresh Interval (minutes): \(Int(autoRefreshInterval))")
                            .disabled(!isEditingEnabled)
                    }
                .disabled(!isEditingEnabled)
                .padding(.top, 8)
                
            case 1:
                HStack {
                    TextField("Solar Weather/Propagatin Provider", text: $solarWeatherApiUrl)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(!isEditingEnabled)
                }
                
                let clusters = [
                    ("DxCluster 80-40", $dxCluster8040url),
                    ("DxCluster 30-20", $dxCluster3020url),
                    ("DxCluster 17-15", $dxCluster1715url),
                    ("DxCluster 12-10", $dxCluster1210url)
                ]
                ForEach(clusters, id: \.0) { label, binding in
                    TextField(label, text: binding)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(!isEditingEnabled)
                }
                
            default:
                EmptyView()
            }
            
            Spacer() // Push the content below the tabs
            
            // Toggle and Save button in the same line
            HStack {
                Toggle("Editable?", isOn: $isEditingEnabled)
                    .toggleStyle(.checkbox)
                
                Spacer() // Push the Save button to the right
                
                Button("Save") {
                    // Sync changes back to SettingsManager
                    SettingsManager.shared.solarWeatherApiUrl = solarWeatherApiUrl
                    SettingsManager.shared.dxCluster8040url = dxCluster8040url
                    SettingsManager.shared.dxCluster3020url = dxCluster3020url
                    SettingsManager.shared.dxCluster1715url = dxCluster1715url
                    SettingsManager.shared.dxCluster1210url = dxCluster1210url
                    SettingsManager.shared.autoRefreshInterval = autoRefreshInterval
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal) // Add some horizontal padding
        }
        .padding(.vertical, 16) // Add padding to the top and bottom
        .frame(width: 400)
        .onAppear {
            // Sync SettingsManager to ensure consistency
            solarWeatherApiUrl = SettingsManager.shared.solarWeatherApiUrl
            dxCluster8040url = SettingsManager.shared.dxCluster8040url
            dxCluster3020url = SettingsManager.shared.dxCluster3020url
            dxCluster1715url = SettingsManager.shared.dxCluster1715url
            dxCluster1210url = SettingsManager.shared.dxCluster1210url
            autoRefreshInterval = SettingsManager.shared.autoRefreshInterval
        }
    }
}
