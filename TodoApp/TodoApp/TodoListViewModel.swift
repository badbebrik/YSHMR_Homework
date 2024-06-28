//
//  TodoListViewModel.swift
//  TodoApp
//
//  Created by Виктория Серикова on 28.06.2024.
//

import Foundation

class TodoListViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    var fileCache: FileCache

    init(fileCache: FileCache = FileCache()) {
        self.fileCache = fileCache
        loadItems()
    }

    func loadItems() {
        fileCache.load(from: "todoitems.json")
        items = fileCache.items
    }

    func addItem(_ item: TodoItem) {
        fileCache.add(item)
        fileCache.save(to: "todoitems.json")
        loadItems()
    }

    func updateItem(_ item: TodoItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            fileCache.remove(by: item.id)
            fileCache.add(item)
        } else {
            items.append(item)
            fileCache.add(item)
        }
        fileCache.save(to: "todoitems.json")
        loadItems()
    }

    func removeItem(by id: String) {
        fileCache.remove(by: id)
        fileCache.save(to: "todoitems.json")
        loadItems()
    }

    func removeItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = items[index]
            fileCache.remove(by: item.id)
        }
        fileCache.save(to: "todoitems.json")
        loadItems()
    }
    
    var completedTodoItemsCount: Int {
            items.filter { $0.isCompleted }.count
        }
}
