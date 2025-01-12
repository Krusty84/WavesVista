//
//  About.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 12/01/2025.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack() {
            // App Icon
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .frame(width: 32, height: 32)
                .cornerRadius(20)
                .shadow(radius: 5)

            // Description
            Text("WavesVista")
                .font(.title)
                .fontWeight(.bold)

            Text("This simple application will help you quickly learn about the state of the ionosphere and its suitability for long-distance QSOs. 73! de UB3ARM")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Divider()

            // License
            VStack(alignment: .leading, spacing: 8) {
                Text("License")
                    .font(.headline)
                Text("MIT")
                    .font(.body).padding(5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            Divider()
            // Author
            VStack(alignment: .leading, spacing: 8) {
                Text("Author")
                    .font(.headline)
                Text("Alexey Sedoykin")
                    .font(.body).padding(5)
                Text("Contact")
                    .font(.headline)
                Text("www.linkedin.com/in/sedoykin")
                    .font(.body).padding(5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            // Any additional setup when the view appears
        }
    }
}
