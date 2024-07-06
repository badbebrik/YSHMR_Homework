//
//  CategoryPickerView.swift
//  TodoApp
//
//  Created by Виктория Серикова on 06.07.2024.
//

import SwiftUI

struct CategoryPickerView: View {
    @Binding var category: Category
    
    var body: some View {
        HStack {
            Text("Категория: ")
            Spacer()
            Picker("Category", selection: $category) {
                ForEach(Category.allCases, id: \.self) { category in
                    HStack {
                        Circle()
                            .fill(category.color)
                            .frame(width: 10, height: 10)
                        Text(category.rawValue)
                    }
                    .tag(category)
                }
            }
            .pickerStyle(.menu)
            .padding()
        }
        .padding()
    }
}




#Preview {
    CategoryPickerView(category: .constant(.hobby))
}
