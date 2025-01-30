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
            // Choose the icon name
            let iconName = propagationModel.forecastChanged ? "AppIconAlert" : "AppIcon"
            if let icon = NSImage(named: iconName) {
                // Possibly resize it if desired
                let resizedIcon = resizedMenuBarIcon(icon)
                Image(nsImage: resizedIcon)
            } else {
                // Fallback icon if needed
                Image(systemName: "antenna.radiowaves.left.and.right")
            }
        }
        .menuBarExtraStyle(.window)
    }
    private func resizedMenuBarIcon(_ image: NSImage, targetSize: CGFloat = 18) -> NSImage {
           let ratio = image.size.height / image.size.width
           let newHeight = targetSize
           let newWidth = targetSize / ratio
           
           let resized = NSImage(size: NSSize(width: newWidth, height: newHeight))
           resized.lockFocus()
           image.draw(in: NSRect(x: 0, y: 0, width: newWidth, height: newHeight),
                      from: NSRect.zero,
                      operation: .sourceOver,
                      fraction: 1.0)
           resized.unlockFocus()
           return resized
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
