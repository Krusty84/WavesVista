//
//  SettingsManager.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 11/01/2025.
//

import Foundation

class SettingsManager {
    static let shared = SettingsManager() // Singleton instance
    
    private let defaults = UserDefaults.standard
    
    private init() {} // Private initializer to prevent instantiation
    
    // Properties with default values
    var solarWeatherApiUrl: String {
        get { defaults.string(forKey: "solarWeatherApiUrl") ?? "https://www.hamqsl.com/solarxml.php" }
        set { defaults.set(newValue, forKey: "solarWeatherApiUrl") }
    }
    
    var dxCluster8040url: String {
        get { defaults.string(forKey: "dxCluster8040url") ?? "http://www.dxsummit.fi/#/?include=3.5MHz,7MHz" }
        set { defaults.set(newValue, forKey: "dxCluster8040url") }
    }
    
    var dxCluster3020url: String {
        get { defaults.string(forKey: "dxCluster3020url") ?? "http://www.dxsummit.fi/#/?include=10MHz,14MHz" }
        set { defaults.set(newValue, forKey: "dxCluster3020url") }
    }
    
    var dxCluster1715url: String {
        get { defaults.string(forKey: "dxCluster1715url") ?? "http://www.dxsummit.fi/#/?include=18MHz,21MHz" }
        set { defaults.set(newValue, forKey: "dxCluster1715url") }
    }
    
    var dxCluster1210url: String {
        get { defaults.string(forKey: "dxCluster1210url") ?? "http://www.dxsummit.fi/#/?include=24MHz,28MHz" }
        set { defaults.set(newValue, forKey: "dxCluster1210url") }
    }
}
