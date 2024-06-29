//
//  UIColor+Blend.swift
//  TodoApp
//
//  Created by Виктория Серикова on 29.06.2024.
//

import SwiftUI

extension UIColor {
    static func blend(color1: UIColor, color2: UIColor, location: CGFloat) -> UIColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(
            red: r1 + (r2 - r1) * location,
            green: g1 + (g2 - g1) * location,
            blue: b1 + (b2 - b1) * location,
            alpha: a1 + (a2 - a1) * location
        )
    }
}
