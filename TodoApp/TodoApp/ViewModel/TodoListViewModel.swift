//
//  TodoListViewModel.swift
//  TodoApp
//
//  Created by Виктория Серикова on 28.06.2024.
//

import Foundation
import CocoaLumberjackSwift

class TodoListViewModel: ObservableObject {
    @Published var items: [TodoItem] = []
    var fileCache: FileCache

    init(fileCache: FileCache = FileCache()) {
        self.fileCache = fileCache
        loadItems()
        DDLogInfo("TodoListViewModel initialized")
    }

    func loadItems() {
        fileCache.load(from: "todoitems.json")
        items = fileCache.items
        DDLogInfo("Items loaded")
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
            print(item.hexColor)
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
}
