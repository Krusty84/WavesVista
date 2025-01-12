//
//  MainWindow.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 22/12/2024.
//

import SwiftUI
import GoodProperTabs

struct MainWindow: View {
    var body: some View {
        GoodProperTabsView(content: [
                (title: "HF Propagation", icon: "PropagationIcon", view: AnyView(HFPropagationTabContent())),
                (title: "VHF Propagation", icon: "PropagationIcon", view: AnyView(VHFPropagationTabContent())),
                (title: "Solar Weather", icon: "SunIcon", view: AnyView(SolarWeatherTabContent())),
                (title: "Settings", icon: "system:gear", view: AnyView(SettingsView())),
                (title: "About", icon: "system:info", view: AnyView(AboutView()))
                ])
    }
}
