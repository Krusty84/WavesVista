//
//  WavesVistaApp.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 22/12/2024.
//

import SwiftUI

@main
struct WavesVistaApp: App {
     @Environment(\.openWindow) var openWindow
     @StateObject private var propagationModel = PropagationModel()
    
    init() {
           // Ask for notification permission when the app starts
           NotificationManager.shared.requestAuthorization()
       }
    
     var body: some Scene {
         MenuBarExtra {
             MainWindow().environmentObject(propagationModel)
         } label: {
             let image: NSImage = {
                 let ratio = $0.size.height / $0.size.width
                 $0.size.height = 18
                 $0.size.width = 18 / ratio
                 return $0
             }(NSImage(named: "AppIcon")!)
             Image(nsImage: image)
         }
         .menuBarExtraStyle(.window)
     }
 }

 #Preview (traits: .fixedLayout(width: 500, height:100)) {
     MainWindow()
 }

 
//             Button("Do Something") {
//                 openWindow(id: "mainWindow")
//                 NSLog("Clicked")
//             }
//             Divider()
//             Button("BlahBlah") {
//                 NSLog("BlahBlahBlah")
//             }
//             Divider()
//             Button("Quit") {
//                 NSApplication.shared.terminate(nil)
//             }
