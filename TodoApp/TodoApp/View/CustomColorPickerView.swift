//
//  ColorPickerView.swift
//  TodoApp
//
//  Created by Виктория Серикова on 28.06.2024.
//

import SwiftUI

struct CustomColorPickerView: View {
    @State private var brightness: Double = 1.0
    @Binding var selectedColor: Color
    @Binding var showColorPicker: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Цвет")
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        withAnimation {
                            showColorPicker.toggle()
                        }
                    }, label: {
                        HStack {
                            Text("\(selectedColor.hexString())")
                                .foregroundColor(.blue)
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(selectedColor)
                                .brightness(1 - brightness)
                                .frame(width: 20, height: 20)
                        }
                    })
                }
                
                Spacer()
            }

            if showColorPicker {
                gradientView
                    .frame(height: 70)
                    .mask(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    .gesture(DragGesture(minimumDistance: 0).onChanged { value in
                        self.selectedColor = getColor(at: value.location.x)
                    })

                Slider(value: $brightness, in: 0.0...1.0, step: 0.1)
                    .padding()
            }
        }
        .padding()
    }

    private var gradientView: some View {
        LinearGradient(gradient: Gradient(colors: generateGradientColors()), startPoint: .leading, endPoint: .trailing)
    }

    private func generateGradientColors() -> [Color] {
        let baseColors = [
            UIColor.white,
            UIColor.red,
            UIColor.orange,
            UIColor.yellow,
            UIColor.green,
            UIColor.cyan,
            UIColor.blue,
            UIColor.purple,
            UIColor.brown,
            UIColor.gray,
            UIColor.black
        ]
        
        var colors: [Color] = []
        for i in 0..<baseColors.count - 1 {
            colors.append(Color(baseColors[i]))
            let middleColor = UIColor.blend(color1: baseColors[i], color2: baseColors[i + 1], location: 0.5)
            colors.append(Color(middleColor))
        }
        
        if let lastBaseColor = baseColors.last {
            colors.append(Color(lastBaseColor))
        }

        return colors
    }

    @MainActor
    private func getColor(at position: CGFloat) -> Color {
        let colors = generateGradientColors()
        let width = UIScreen.main.bounds.width - 32
        let index = max(0, min(colors.count - 1, Int(position / width * CGFloat(colors.count))))
        return colors[index]
    }
}
