//
//  Helpers.swift
//  WavesVista
//
//  Created by Sedoykin Alexey on 22/12/2024.
//

import SwiftUI

func colorForCondition(_ condition: String) -> Color {
    switch condition.lowercased() {
    case "good":
        return .green
    case "fair":
        return .yellow
    case "poor":
        return .red
    default:
        return .gray
    }
}

func convertToLocalTime(dateString: String) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy HHmm zzz" // Format of the input date string
    formatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent parsing
    formatter.timeZone = TimeZone(abbreviation: "GMT") // Input is in GMT

    if let date = formatter.date(from: dateString) {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Desired output format
        formatter.timeZone = TimeZone.current // Local time zone
        return formatter.string(from: date)
    }
    
    return nil // Return nil if the string couldn't be parsed
}
