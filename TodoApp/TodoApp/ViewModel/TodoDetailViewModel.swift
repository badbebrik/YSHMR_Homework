//
//  TodoDetailViewModel.swift
//  TodoApp
//
//  Created by Виктория Серикова on 27.06.2024.
//

import SwiftUI
import CocoaLumberjackSwift

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
        self.deadline = todoItem?.deadline
        self.isPickerShowed = false
        self.isDeadlineEnabled = todoItem?.deadline != nil
        self.selectedColor = Color(hex: todoItem?.hexColor ?? "F0171")
        self.isColorPickerShowed = false
        self.category = todoItem?.category ?? .other
        DDLogInfo("TodoDetailViewModel initialized with item: \(todoItem?.id ?? "new item")")
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
        
        listViewModel.updateItem(updatedItem)
        DDLogInfo("Item saved: \(todoItem?.id ?? "new item")")
    }

    func delete() {
        guard let id = todoItem?.id else { return }
        listViewModel.removeItem(by: id)
        DDLogInfo("Item deleted: \(id)")
    }
}
