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

// MARK: - TodoItem Parsing Json
extension TodoItem {
    
    internal static var localDateFormatter: ISO8601DateFormatter {
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = .current
            return formatter
    }
    
    
    static func parse(json: Any) -> TodoItem? {
        guard let dictionary = json as? [String: Any],
              let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String,
              let creationDateString = dictionary["creationDate"] as? String,
              let creationDate = ISO8601DateFormatter().date(from: creationDateString) else {
            return nil
        }
        
        let priorityString = dictionary["priority"] as? String ?? Priority.regular.rawValue
        
        guard let priority = Priority(rawValue: priorityString) else {
            return nil
        }
        
        let deadline: Date?
        
        if let deadlineString = dictionary["deadline"] as? String {
            deadline = localDateFormatter.date(from: deadlineString)
        } else {
            deadline = nil
        }
        
        let isCompleted = dictionary["isCompleted"] as? Bool ?? false
        
        let modificationDate: Date?
        
        if let modificationDateString = dictionary["modificationDate"] as? String {
            modificationDate = localDateFormatter.date(from: modificationDateString)
        } else {
            modificationDate = nil
        }
        
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modificationDate)
        
     }
    
    var json: Any {
        var dictionary: [String: Any] = [
            "id": id,
            "text": text,
            "creationDate": Self.localDateFormatter.string(from: creationDate),
            "isCompleted": isCompleted
        ]
        
        if priority != .regular {
            dictionary["priority"] = priority.rawValue
        }
        
        if let deadline = deadline {
            dictionary["deadline"] = Self.localDateFormatter.string(from: deadline)
        }
        
        if let modificationDate = modificationDate {
            dictionary["modificationDate"] = Self.localDateFormatter.string(from: modificationDate)
        }
        
        return dictionary
    }
}



//MARK: - TodoItem Parsing CSV
extension TodoItem {
    var csv: String {
        let deadlineString = deadline != nil ? Self.localDateFormatter.string(from: deadline!) : ""
        let modificationDateString = modificationDate != nil ? Self.localDateFormatter.string(
            from: modificationDate!) : ""
        return "\(id),\(text),\(priority.rawValue),\(deadlineString),\(isCompleted),\(Self.localDateFormatter.string(from: creationDate)),\(modificationDateString)"
    }
    
    static func fromCSV(_ csv: String) -> TodoItem? {
        let components = csv.components(separatedBy: ",")
        guard components.count >= 6 else { return nil }
        
        let id = components[0]
        let text = components[1]
        let priorityString = components[2]
        
        guard let priority = Priority(rawValue: priorityString) else {
            return nil
        }
        
        let deadlineString = components[3]
        let deadline = deadlineString.isEmpty ? nil : Self.localDateFormatter.date(from: deadlineString)
        
        let isCompleted = (components[4] as NSString).boolValue
        
        let creationDateString = components[5]
        guard let creationDate = Self.localDateFormatter.date(from: creationDateString) else {
            return nil
        }
        
        let modificationDateString = components.count > 6 ? components[6] : ""
        let modificationDate = modificationDateString.isEmpty ? nil : Self.localDateFormatter.date(from: modificationDateString)
        
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modificationDate)
    }
}
