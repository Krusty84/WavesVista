//
//  PropagationModel.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 22/12/2024.
//

import Combine
import SwiftUI

class PropagationModel: ObservableObject {
    @AppStorage("solarWeatherApiUrl") private var solarWeatherApiUrl: String = "https://www.hamqsl.com/solarxml.php"
    
    @Published var solarData: SolarData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // NEW: Store the last time we auto-refreshed
    @Published var lastRefreshDate: Date? = nil
    
    private var autoRefreshCancellable: AnyCancellable?

    // Call this once to start auto-refreshing
    func startAutoRefresh(every seconds: TimeInterval = 20) {
        // If there's already a timer, cancel it first
        autoRefreshCancellable?.cancel()
        
        // Publish a timer event every `seconds`, on the main run loop, in the common modes
        let timer = Timer.publish(every: seconds, on: .main, in: .common).autoconnect()
        
        // Each time the timer emits, we call `fetchSolarData()`
        autoRefreshCancellable = timer.sink { [weak self] _ in
            self?.fetchSolarData()
        }
    }

    // Stop auto-refresh if needed
    func stopAutoRefresh() {
        autoRefreshCancellable?.cancel()
        autoRefreshCancellable = nil
    }
    
    func fetchSolarData() {
        guard let url = URL(string: solarWeatherApiUrl) else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    // You could record the time even on error if you wish:
                    // self.lastRefreshDate = Date()
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received"
                    // self.lastRefreshDate = Date()
                }
                return
            }
            
            let parser = SolarDataParser(data: data)
            if let solarData = parser.parse() {
                DispatchQueue.main.async {
                    if let oldData = self.solarData, oldData != solarData {
                        handleChangedData(oldData: oldData, newData: solarData)
                    } else if self.solarData == nil {
                        // 2) This is the first time data is being set
                        //    Possibly treat it as "all new" if desired
                    } else{
                        NotificationManager.shared.postNotification(
                            title: "WavesVista",
                            body: "Propagation data refreshed at \(self.formatDate(self.lastRefreshDate))"
                        )
                    }
                    
                    self.solarData = solarData
                    // Record successful fetch time
                    self.lastRefreshDate = Date()
                    
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse XML data"
                    // self.lastRefreshDate = Date()
                }
            }
        }.resume()
    }
    
    private func formatDate(_ date: Date?) -> String {
         guard let date = date else { return "Unknown" }
         let formatter = DateFormatter()
         formatter.dateStyle = .short
         formatter.timeStyle = .medium
         return formatter.string(from: date)
     }
    
    init() {
        let interval = SettingsManager.shared.autoRefreshInterval
        //first data load
        fetchSolarData()
        //based on timer
        startAutoRefresh(every: interval)
    }
}



struct SolarData {
    // Single-value fields
    var source: String = ""             // e.g., "N0NBH"
    var sourceURL: String = ""          // e.g., "http://www.hamqsl.com/solar.html"
    var updated: String = ""            // e.g., "22 Dec 2024 1906 GMT"
    
    var solarflux: String = ""
    var aindex: String = ""
    var kindex: String = ""
    var kindexnt: String = ""
    var xray: String = ""
    var sunspots: String = ""
    var heliumline: String = ""
    var protonflux: String = ""
    var electonflux: String = ""
    var aurora: String = ""
    var normalization: String = ""
    var latdegree: String = ""
    var solarwind: String = ""
    var magneticfield: String = ""
    var geomagfield: String = ""
    var signalnoise: String = ""
    var fof2: String = ""
    var muffactor: String = ""
    var muf: String = ""
    
    // Arrays for nested data
    var calculatedConditions: [CalculatedCondition] = []
    var calculatedVhfConditions: [CalculatedVhfCondition] = []
}

// Stores each <band> element inside <calculatedconditions>
struct CalculatedCondition {
    var bandName: String  // from attribute: name="80m-40m" etc.
    var time: String      // from attribute: time="day" etc.
    var condition: String // text inside the <band> element, e.g. "Poor", "Good"
}

// Stores each <phenomenon> element inside <calculatedvhfconditions>
struct CalculatedVhfCondition:Hashable {
    var phenomenonName: String  // from attribute: name="vhf-aurora" etc.
    var location: String        // from attribute: location="northern_hemi" etc.
    var condition: String       // text inside the <phenomenon> element
}

class SolarDataParser: NSObject, XMLParserDelegate {
    private let data: Data
    
    // Main data object we build up
    private var solarData = SolarData()
    
    // Temporary variables to keep track of text and context
    private var currentElement = ""
    private var foundCharacters = ""
    
    // For <calculatedconditions> and <calculatedvhfconditions>
    // We'll parse them as arrays of items
    private var inCalculatedConditions = false
    private var inCalculatedVhfConditions = false
    
    // Temporary storage while building a single band or phenomenon
    private var currentBand: CalculatedCondition?
    private var currentPhenomenon: CalculatedVhfCondition?

    init(data: Data) {
        self.data = data
    }
    
    func parse() -> SolarData? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        
        // If parsing succeeds, return the full object; otherwise nil
        return parser.parse() ? solarData : nil
    }
    
    // MARK: - XMLParserDelegate
    
    /// Called when we start an element, e.g. <solarflux>, <band name="..." time="...">
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        foundCharacters = ""
        
        switch elementName {
        case "solardata":
            // We are in the root data area (no special action needed, just a note)
            break
            
        case "calculatedconditions":
            // We have entered the <calculatedconditions> section
            inCalculatedConditions = true
            
        case "band":
            // We are inside a <band> element
            if inCalculatedConditions {
                // Initialize a new CalculatedCondition
                currentBand = CalculatedCondition(
                    bandName: attributeDict["name"] ?? "",
                    time: attributeDict["time"] ?? "",
                    condition: ""
                )
            }
            
        case "calculatedvhfconditions":
            // We have entered the <calculatedvhfconditions> section
            inCalculatedVhfConditions = true
            
        case "phenomenon":
            // We are inside a <phenomenon> element
            if inCalculatedVhfConditions {
                currentPhenomenon = CalculatedVhfCondition(
                    phenomenonName: attributeDict["name"] ?? "",
                    location: attributeDict["location"] ?? "",
                    condition: ""
                )
            }
            
        case "source":
            // <source url="...">Some text</source>
            // We can capture the attribute here
            if let urlValue = attributeDict["url"] {
                solarData.sourceURL = urlValue
            }
            
        default:
            break
        }
    }
    
    /// Called when we find text in an element, e.g. <solarflux>195</solarflux>
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // Accumulate text inside `foundCharacters`
        foundCharacters += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Called when an element ends, e.g. </solarflux> or </band>
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {

        switch elementName {
        // Single-value fields
        case "source":
            solarData.source = foundCharacters
            
        case "updated":
            solarData.updated = foundCharacters
            
        case "solarflux":
            solarData.solarflux = foundCharacters
            
        case "aindex":
            solarData.aindex = foundCharacters
            
        case "kindex":
            solarData.kindex = foundCharacters
            
        case "kindexnt":
            solarData.kindexnt = foundCharacters
            
        case "xray":
            solarData.xray = foundCharacters
            
        case "sunspots":
            solarData.sunspots = foundCharacters
            
        case "heliumline":
            solarData.heliumline = foundCharacters
            
        case "protonflux":
            solarData.protonflux = foundCharacters
            
        case "electonflux":
            solarData.electonflux = foundCharacters
            
        case "aurora":
            solarData.aurora = foundCharacters
            
        case "normalization":
            solarData.normalization = foundCharacters
            
        case "latdegree":
            solarData.latdegree = foundCharacters
            
        case "solarwind":
            solarData.solarwind = foundCharacters
            
        case "magneticfield":
            solarData.magneticfield = foundCharacters
            
        case "geomagfield":
            solarData.geomagfield = foundCharacters
            
        case "signalnoise":
            solarData.signalnoise = foundCharacters
            
        case "fof2":
            solarData.fof2 = foundCharacters
            
        case "muffactor":
            solarData.muffactor = foundCharacters
            
        case "muf":
            solarData.muf = foundCharacters
            
        // Nested sections
        case "calculatedconditions":
            inCalculatedConditions = false
            
        case "band":
            if let band = currentBand {
                // The text we found is the actual condition, e.g. "Poor", "Good"
                var updatedBand = band
                updatedBand.condition = foundCharacters
                
                // Append to the array
                solarData.calculatedConditions.append(updatedBand)
            }
            currentBand = nil
            
        case "calculatedvhfconditions":
            inCalculatedVhfConditions = false
            
        case "phenomenon":
            if let phenomenon = currentPhenomenon {
                var updatedPhenomenon = phenomenon
                updatedPhenomenon.condition = foundCharacters
                
                // Append to the array
                solarData.calculatedVhfConditions.append(updatedPhenomenon)
            }
            currentPhenomenon = nil
            
        default:
            break
        }
        
        // Reset after finishing the element
        currentElement = ""
        foundCharacters = ""
    }
    
    // Handle parser error if needed
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML Parser error: \(parseError)")
    }
}
