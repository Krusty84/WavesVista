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
    
    @State private var isEditingEnabled: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                TextField("API URL", text: $solarWeatherApiUrl)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isEditingEnabled)
                
                Toggle("Editable?", isOn: $isEditingEnabled)
                    .toggleStyle(.checkbox)
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
                    .padding(.vertical, 4)
                    .disabled(!isEditingEnabled)
            }
            
            HStack {
                Spacer()
                Button("Save") {
                    // Sync changes back to SettingsManager
                    SettingsManager.shared.solarWeatherApiUrl = solarWeatherApiUrl
                    SettingsManager.shared.dxCluster8040url = dxCluster8040url
                    SettingsManager.shared.dxCluster3020url = dxCluster3020url
                    SettingsManager.shared.dxCluster1715url = dxCluster1715url
                    SettingsManager.shared.dxCluster1210url = dxCluster1210url
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .frame(width: 400, height: 400)
        .onAppear {
            // Sync SettingsManager to ensure consistency
            solarWeatherApiUrl = SettingsManager.shared.solarWeatherApiUrl
            dxCluster8040url = SettingsManager.shared.dxCluster8040url
            dxCluster3020url = SettingsManager.shared.dxCluster3020url
            dxCluster1715url = SettingsManager.shared.dxCluster1715url
            dxCluster1210url = SettingsManager.shared.dxCluster1210url
        }
    }
}
