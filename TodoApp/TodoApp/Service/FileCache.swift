//
//  FileCache.swift
//  TodoApp
//
//  Created by Виктория Серикова on 16.06.2024.
//

import Foundation


protocol StorageStrategy {
    func save(items: [String: TodoItem], to filename: String)
    func load(from filename: String) -> [String: TodoItem]
}

class FileCache {
    private(set) var items: [String: TodoItem] = [:]
    private var strategy: StorageStrategy

    init(strategy: StorageStrategy) {
        self.strategy = strategy
    }

    func add(_ item: TodoItem) {
        items[item.id] = item
    }

    func remove(by id: String) {
        items.removeValue(forKey: id)
    }

    func save(to filename: String) {
        strategy.save(items: items, to: filename)
    }

    func load(from filename: String) {
        items = strategy.load(from: filename)
    }
}
