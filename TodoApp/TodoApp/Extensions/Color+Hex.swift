//
//  Color+Hex.swift
//  TodoApp
//
//  Created by Виктория Серикова on 29.06.2024.
//

import SwiftUI

extension Color {
    
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    func hexString() -> String {
        guard let components = UIColor(self).cgColor.components else {
            return "FFFFFF"
        }
        
        let componentsCount = components.count
        
        switch componentsCount {
        case 4:
            let red = components[0]
            let green = components[1]
            let blue = components[2]
            return String(format: "%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
        case 2:
            let white = components[0]
            return String(format: "%02X%02X%02X", Int(white * 255), Int(white * 255), Int(white * 255))
        default:
            return "FFFFFF"
        }
    }
}
