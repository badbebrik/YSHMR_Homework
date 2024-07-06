//
//  TodoDetailViewModel.swift
//  TodoApp
//
//  Created by Виктория Серикова on 27.06.2024.
//

import SwiftUI

final class TodoDetailViewModel: ObservableObject {
    @Published var text: String
    @Published var priority: Priority
    @Published var deadline: Date?
    @Published var isPickerShowed: Bool
    @Published var isDeadlineEnabled: Bool
    @Published var selectedColor: Color
    @Published var isColorPickerShowed: Bool
    @Published var category: Category
    @Published var todoItem: TodoItem?

    var listViewModel: TodoListViewModel

    init(todoItem: TodoItem?, listViewModel: TodoListViewModel) {
        self.todoItem = todoItem
        self.listViewModel = listViewModel
        self.text = todoItem?.text ?? ""
        self.priority = todoItem?.priority ?? .regular
        self.deadline = todoItem?.deadline ?? nil
        self.isPickerShowed = false
        self.isDeadlineEnabled = todoItem?.deadline != nil
        self.selectedColor = Color(hex: todoItem?.hexColor ?? "F0171")
        self.isColorPickerShowed = false
        self.category = todoItem?.category ?? .other
    }

    func save() {
        let updatedItem = TodoItem(
            id: todoItem?.id ?? UUID().uuidString,
            text: text,
            priority: priority,
            deadline: isDeadlineEnabled ? deadline : nil,
            isCompleted: todoItem?.isCompleted ?? false,
            creationDate: todoItem?.creationDate ?? Date(),
            modificationDate: Date(),
            hexColor: selectedColor.hexString(),
            category: category
        )
        print(updatedItem.hexColor)
        listViewModel.updateItem(updatedItem)
    }

    func delete() {
        guard let id = todoItem?.id else { return }
        listViewModel.removeItem(by: id)
    }
}



