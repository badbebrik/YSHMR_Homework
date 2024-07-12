//
//  UIColor+Blend.swift
//  TodoApp
//
//  Created by Виктория Серикова on 29.06.2024.
//

import SwiftUI

extension UIColor {
    static func blend(color1: UIColor, color2: UIColor, location: CGFloat) -> UIColor {
        var (red1, green1, blue1, alpha1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (red2, green2, blue2, alpha2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1)
        color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return UIColor(
            red: red1 + (red2 - red1) * location,
            green: green1 + (green2 - green1) * location,
            blue: blue1 + (blue2 - blue1) * location,
            alpha: alpha1 + (alpha2 - alpha1) * location
        )
    }
}
