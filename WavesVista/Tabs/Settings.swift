//
//  Settings.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 22/12/2024.
//

import SwiftUI

struct SettingsView: View {
    // Store URL in UserDefaults with key "solarWeatherApiUrl"
    @AppStorage("solarWeatherApiUrl") private var solarWeatherApiUrl: String = "https://www.hamqsl.com/solarxml.php"
    
    @AppStorage("dxCluster8040url") private var dxCluster8040url: String = "http://www.dxsummit.fi/#/?include=3.5MHz,7MHz"
    @AppStorage("dxCluster3020url") private var dxCluster3020url: String = "http://www.dxsummit.fi/#/?include=10MHz,14MHz"
    @AppStorage("dxCluster1715url") private var dxCluster1715url: String = "http://www.dxsummit.fi/#/?include=18MHz,21MHz"
    @AppStorage("dxCluster1210url") private var dxCluster1210url: String = "hhttp://www.dxsummit.fi/#/?include=24MHz,28MHz"
    
    
    // A temporary state property to hold text field changes:
    @State private var localSolarWeatherApiUrl: String = ""
    @State private var localDxCluster8040url: String = ""
    @State private var localDxCluster3020url: String = ""
    @State private var localDxCluster1715url: String = ""
    @State private var localDxCluster1210url: String = ""
    // A state property to control whether editing is enabled:
    @State private var isEditingEnabled: Bool = false
    

var body: some View {
     VStack(alignment: .leading, spacing: 16) {
         
         // 1) TextField and Toggle on the same line
         HStack {
             TextField("API URL", text: $localSolarWeatherApiUrl)
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .disabled(!isEditingEnabled) // Disable if toggle is off
             // Checkbox (toggle) on the right
             Toggle("Editable?", isOn: $isEditingEnabled)
                 .toggleStyle(.checkbox)
             //
         }
        
         TextField("DxCluster 80-40", text: $localDxCluster8040url)
         TextField("DxCluster 30-20", text: $localDxCluster3020url)
         TextField("DxCluster 17-15", text: $localDxCluster1715url)
         TextField("DxCluster 12-10", text: $localDxCluster1210url)
         //
         // 2) Save button on the bottom-right
         HStack {
             Spacer() // Pushes the button to the right
             Button("Save") {
                 // Assign the local text field value to the persisted value
                 solarWeatherApiUrl = localSolarWeatherApiUrl
                 dxCluster8040url = localDxCluster8040url
                 dxCluster3020url  = localDxCluster3020url
                 dxCluster1715url = localDxCluster1715url
                 dxCluster1210url = localDxCluster1210url
             }
             .keyboardShortcut(.defaultAction)
         }
         
     }
     .padding()
     .frame(width: 400, height: 120)
     .onAppear {
         // Load the initial value from UserDefaults
         localSolarWeatherApiUrl = solarWeatherApiUrl
         localDxCluster8040url = dxCluster8040url
         localDxCluster3020url = dxCluster3020url
         localDxCluster1715url = dxCluster1715url
         localDxCluster1210url = dxCluster1210url
     }
 }
}
