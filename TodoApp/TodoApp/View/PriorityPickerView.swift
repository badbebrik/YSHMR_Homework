//
//  PriorityPickerView.swift
//  TodoApp
//
//  Created by Виктория Серикова on 28.06.2024.
//

import SwiftUI

struct PriorityPickerView: View {
    @Binding var priority: Priority
    
    var body: some View {
            HStack {
                Text("Важность")
                    .foregroundColor(.primary)
                Spacer()
                Picker("", selection: $priority) {
                    Image("low_priority")
                        .tag(Priority.unimportant)
                        
                    Text("нет").tag(Priority.regular)
                    Image("high_priority")
                        .tag(Priority.important)
                }
                .pickerStyle(.segmented)
                .frame(width: 150)
            }
            .padding()
    }
}


#Preview {
    PriorityPickerView(priority: .constant(.unimportant))
}
