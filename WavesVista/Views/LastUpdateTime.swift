//
//  LastUpdateTime.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 02/02/2025.
//

import SwiftUI
import Foundation

struct LastUpdateView: View {
    var lastUpdateTime: Date

    var body: some View {
        Text("Last update: \(lastUpdateTime, formatter: DateFormatterUtility.shared)")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct DateFormatterUtility {
    static let shared: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .medium
        return df
    }()
}
