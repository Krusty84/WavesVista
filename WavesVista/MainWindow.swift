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
                //OOTB icon from SF, system:sf_icon_name
                (title: "HF Propogation", icon: "PropogationIcon", view: AnyView(HFPropagationTabContent())),
                (title: "VHF Propogation", icon: "PropogationIcon", view: AnyView(VHFPropagationTabContent())),
                (title: "Solar Weather", icon: "SunIcon", view: AnyView(SolarWeatherTabContent())),
                //CUSTOM icon from Assets.xcassets
                //(title: "Tab 2", icon: "iconFromAssets.xcassets", view: AnyView(Text("Tab #01"))),
                //OOTB icon from SF, system:sf_icon_name
                (title: "Settings", icon: "system:gear", view: AnyView(SettingsView())),
                (title: "About", icon: "system:info", view: AnyView(SettingsView()))
                ])
    }
}
