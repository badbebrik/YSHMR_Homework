//
//  TodoItem.swift
//  TodoApp
//
//  Created by Виктория Серикова on 16.06.2024.
//

import Foundation

enum Priority: String {
    case unimportant = "unimportant"
    case regular = "regular"
    case important = "important"
}

struct TodoItem {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isCompleted: Bool
    let creationDate: Date
    let modificationDate: Date?
    
    init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date? = nil, isCompleted: Bool = false, creationDate: Date = Date(), modificationDate: Date? = nil) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.modificationDate = modificationDate
    }
}

