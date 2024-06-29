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
        if items.firstIndex(where: { $0.id == item.id }) != nil {
            fileCache.remove(by: item.id)
            fileCache.add(item)
            print(item.hexColor)
        } else {
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

}
