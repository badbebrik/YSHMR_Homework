//
//  TodoItem.swift
//  TodoApp
//
//  Created by Виктория Серикова on 16.06.2024.
//

import SwiftUI

enum Category: String, CaseIterable {
    case work = "Work"
    case study = "Study"
    case hobby = "Hobby"
    case other = "Other"

    var color: Color {
        switch self {
        case .work:
            return .red
        case .study:
            return .blue
        case .hobby:
            return .green
        case .other:
            return .clear
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .work:
            return .red
        case .study:
            return .blue
        case .hobby:
            return .green
        case .other:
            return .clear
        }
    }
}

enum Priority: String, Comparable {
    case unimportant = "unimportant"
    case regular = "regular"
    case important = "important"
    
    static func < (lhs: Priority, rhs: Priority) -> Bool {
        switch (lhs, rhs) {
        case (.important, .regular), (.important, .unimportant), (.regular, .unimportant):
            return false
        case (.regular, .important), (.unimportant, .important), (.unimportant, .regular):
            return true
        default:
            return false
        }
    }
}

struct TodoItem: Identifiable {
    let id: String
    let text: String
    let priority: Priority
    let deadline: Date?
    let isCompleted: Bool
    let creationDate: Date
    let modificationDate: Date?
    let hexColor: String
    let category: Category
    
    init(id: String = UUID().uuidString, text: String, priority: Priority, deadline: Date? = nil, isCompleted: Bool = false, creationDate: Date = Date(), modificationDate: Date? = nil, hexColor: String = "FFFFF", category: Category = .other) {
        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isCompleted = isCompleted
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.hexColor = hexColor
        self.category = category
    }
}

