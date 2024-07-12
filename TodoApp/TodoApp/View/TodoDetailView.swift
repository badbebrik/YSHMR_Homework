//
//  TodoDetailView.swift
//  TodoApp
//
//  Created by Виктория Серикова on 27.06.2024.
//

import SwiftUI

struct TodoDetailView: View {
    @ObservedObject var viewModel: TodoDetailViewModel
    @Binding var isShowed: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ZStack(alignment: .trailing) {
                        TextEditor(text: $viewModel.text)
                            .cornerRadius(16)
                            .frame(minHeight: 120)
                            .backgroundStyle(.blue)
                            .contentMargins(.all, 16)
                            .padding(.horizontal)
                        
                        Rectangle()
                            .fill(viewModel.selectedColor)
                            .frame(width: 5)
                            .padding(.horizontal)
                    }

                    VStack(spacing: 0) {
                        PriorityPickerView(priority: $viewModel.priority)
                        Divider()
                        CustomColorPickerView(
                            selectedColor: $viewModel.selectedColor,
                            showColorPicker: $viewModel.isColorPickerShowed
                        )
                        Divider()
                        DeadlinePickerView(
                            isDeadlineEnabled: $viewModel.isDeadlineEnabled,
                            deadline: $viewModel.deadline
                        )
                        Divider()
                        CategoryPickerView(category: $viewModel.category)
                    }
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    Button(role: .destructive, action: {
                        viewModel.delete()
                        isShowed = false
                    }, label: {
                        Text("Удалить")
                            .frame(maxWidth: .infinity)
                    })
                    .frame(height: 56)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .disabled(viewModel.todoItem?.id == nil)
                }
            }
            .background(Color.brandBackground)
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отменить") {
                        isShowed = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        viewModel.save()
                        isShowed = false
                    }
                }
            }
        }
    }
}
