//
//  FileCache.swift
//  TodoApp
//
//  Created by Виктория Серикова on 16.06.2024.
//

import Foundation
import CocoaLumberjackSwift


protocol StorageStrategy {
    func save(items: [TodoItem], to filename: String)
    func load(from filename: String) -> [TodoItem]
}

class FileCache: ObservableObject {
    private(set) var items: [TodoItem] = []
    private var strategy: StorageStrategy
    
    init(strategy: StorageStrategy = JSONStrategy()) {
        self.strategy = strategy
        DDLogInfo("FileCache initialized with strategy: \(strategy)")
    }
    
    func add(_ item: TodoItem) {
        if !items.contains(where: { $0.id == item.id }) {
            items.append(item)
            DDLogInfo("Item added: \(item.id)")
        } else {
            DDLogWarn("Item with id \(item.id) already exists, skipping add")
        }
    }
    
    func remove(by id: String) {
        items.removeAll { $0.id == id }
        DDLogInfo("Item removed: \(id)")
    }
    
    func save(to filename: String) {
        strategy.save(items: items, to: filename)
        DDLogInfo("Items saved to file: \(filename)")
    }
    
    func load(from filename: String) {
        items = strategy.load(from: filename)
        DDLogInfo("Items loaded from file: \(filename)")
    }
}
