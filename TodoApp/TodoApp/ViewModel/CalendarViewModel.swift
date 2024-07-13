//
//  CalendarViewModel.swift
//  TodoApp
//
//  Created by Виктория Серикова on 05.07.2024.
//

import Foundation
import CocoaLumberjackSwift

protocol CalendarViewModelDelegate: AnyObject {
    func dataDidUpdate()
}

final class CalendarViewModel {
    // MARK: - Fields
    var todoItems: [(String, [TodoItem])] = []
    var dates: [String] = []
    private var items: [TodoItem] = []
    private var fileCache: FileCache
    weak var delegate: CalendarViewModelDelegate?

    // MARK: - Lifecycle
    init(fileCache: FileCache = FileCache(strategy: JSONStrategy())) {
        self.fileCache = fileCache
        loadItems()
        DDLogInfo("CalendarViewModel initialized")
    }

    // MARK: - Methods
    func loadItems() {
        DDLogInfo("Loading items")
        todoItems.removeAll()
        dates.removeAll()

        fileCache.load(from: "todoitems.json")
        items = fileCache.items
        items.forEach { item in
            guard let deadline = item.deadline else {
                if !todoItems.contains(where: { $0.0 == "Другое" }) {
                    todoItems.append(("Другое", [item]))
                    dates.append("Другое")
                } else {
                    if let index = todoItems.firstIndex(where: { $0.0 == "Другое" }) {
                        todoItems[index].1.append(item)
                    }
                }
                return
            }
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "dd MMMM yyyy"
            let date = formatter.string(from: deadline)
            if !todoItems.contains(where: { $0.0 == date }) {
                todoItems.append((date, [item]))
                dates.append(date)
            } else {
                if let index = todoItems.firstIndex(where: { $0.0 == date }) {
                    todoItems[index].1.append(item)
                }
            }
        }
        todoItems = todoItems.sorted { $0.0 < $1.0 }
        dates = dates.sorted { $0 < $1 }
        delegate?.dataDidUpdate()
    }

    func addItem(_ item: TodoItem) {
        fileCache.add(item)
        fileCache.save(to: "todoitems.json")
        loadItems()
        DDLogInfo("Item added: \(item.id)")
    }

    func updateItem(_ item: TodoItem) {
        if items.firstIndex(where: { $0.id == item.id }) != nil {
            fileCache.remove(by: item.id)
            fileCache.add(item)
        } else {
            fileCache.add(item)
        }
        fileCache.save(to: "todoitems.json")
        loadItems()
        DDLogInfo("Item updated: \(item.id)")
    }

    func removeItem(by id: String) {
        fileCache.remove(by: id)
        fileCache.save(to: "todoitems.json")
        loadItems()
        DDLogInfo("Item removed: \(id)")
    }
    
    func changeDone(_ todo: TodoItem, value: Bool) {
        let updatedTodo = TodoItem(
            id: todo.id,
            text: todo.text,
            priority: todo.priority,
            deadline: todo.deadline,
            isCompleted: value,
            creationDate: todo.creationDate,
            modificationDate: todo.modificationDate,
            hexColor: todo.hexColor,
            category: todo.category
        )
        updateItem(updatedTodo)
        DDLogInfo("Item marked as \(value ? "completed" : "not completed"): \(todo.id)")
    }
}
