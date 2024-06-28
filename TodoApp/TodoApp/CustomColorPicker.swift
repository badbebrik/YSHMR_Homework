//
//  CustomColorPicker.swift
//  TodoApp
//
//  Created by Виктория Серикова on 28.06.2024.
//

import SwiftUI

struct CustomColorPicker: View {
    @State var selectedColor: Color
    @State private var colorCode: String = "#FFFFFF"
    @State private var brightness: Double = 1.0

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Rectangle()
                        .fill(selectedColor)
                        .frame(width: 50, height: 50)
                        .cornerRadius(6)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.black, lineWidth: 1))
                    Text(colorCode)
                        .font(.footnote)
                        .foregroundColor(.black)
                }
                .padding()

                Slider(value: $brightness, in: 0...1, step: 0.01)
                    .padding()
                    .onChange(of: brightness) { newValue in
                        updateColorCode()
                    }
            }
            .padding()

            ColorPaletteView(selectedColor: $selectedColor, colorCode: $colorCode, brightness: $brightness)
                .frame(width: 300, height: 300)
                .cornerRadius(16)
                .padding()
        }
    }

    private func updateColorCode() {
        colorCode = selectedColor.adjustedBrightness(brightness).toHex()
    }
}

struct ColorPaletteView: View {
    @Binding var selectedColor: Color
    @Binding var colorCode: String
    @Binding var brightness: Double

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let image = generateColorPalette(size: size)

            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()

                Rectangle()
                    .fill(Color.black.opacity(1.0 - brightness))
                    .allowsHitTesting(false)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let point = value.location
                        if point.x >= 0 && point.x < size.width && point.y >= 0 && point.y < size.height {
                            let color = getColorAtPoint(point: point, in: size)
                            selectedColor = color.adjustedBrightness(brightness)
                            colorCode = selectedColor.toHex()
                        }
                    }
            )
        }
    }

    func generateColorPalette(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            for y in stride(from: 0.0, to: size.height, by: 1.0) {
                for x in stride(from: 0.0, to: size.width, by: 1.0) {
                    let hue = x / size.width
                    let saturation = y / size.height
                    let color = UIColor(hue: hue, saturation: saturation, brightness: 1.0, alpha: 1.0)
                    context.cgContext.setFillColor(color.cgColor)
                    context.cgContext.fill(CGRect(x: x, y: y, width: 1, height: 1))
                }
            }
        }
    }

    func getColorAtPoint(point: CGPoint, in size: CGSize) -> Color {
        let hue = point.x / size.width
        let saturation = point.y / size.height
        return Color(hue: Double(hue), saturation: Double(saturation), brightness: 1.0)
    }
}

extension Color {
    func toHex() -> String {
        let components = UIColor(self).cgColor.components
        let r = Float(components?[0] ?? 0)
        let g = Float(components?[1] ?? 0)
        let b = Float(components?[2] ?? 0)
        return String(format: "#%02lX%02lX%02lX",
                      lroundf(r * 255),
                      lroundf(g * 255),
                      lroundf(b * 255))
    }

    func adjustedBrightness(_ brightness: Double) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightnessComponent: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightnessComponent, alpha: &alpha)

        return Color(hue: Double(hue), saturation: Double(saturation), brightness: brightness, opacity: Double(alpha))
    }
}

#Preview() {
    CustomColorPicker(selectedColor: .white)
}
