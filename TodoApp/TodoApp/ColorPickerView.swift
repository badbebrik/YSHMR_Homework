//
//  ColorPickerView.swift
//  TodoApp
//
//  Created by Виктория Серикова on 28.06.2024.
//

import SwiftUI

import SwiftUI

struct ColorPickerView: View {
    @State
    var selectedColor: Color
    
    var body: some View {
        VStack {
            CustomColorPicker(selectedColor: selectedColor)
                .frame(maxWidth: 300)
        }
    }
}

#Preview {
    ColorPickerView(selectedColor: .white)
}
