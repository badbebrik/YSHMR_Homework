//
//  TodoItem+JSON.swift
//  TodoApp
//
//  Created by Виктория Серикова on 22.06.2024.
//

import Foundation

extension TodoItem {
    
    static func parse(json: Any) -> TodoItem? {
        
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
              let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
              let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String,
              let creationDateString = dictionary["creationDate"] as? String,
              let creationDate = formatter.date(from: creationDateString) else {
            return nil
        }
        
        let priorityString = dictionary["priority"] as? String ?? Priority.regular.rawValue
        
        guard let priority = Priority(rawValue: priorityString) else {
            return nil
        }
        
        let deadline: Date?
        if let deadlineString = dictionary["deadline"] as? String {
            deadline = formatter.date(from: deadlineString)
        } else {
            deadline = nil
        }
        
        let isCompleted = dictionary["isCompleted"] as? Bool ?? false
        
        let modificationDate: Date?
        if let modificationDateString = dictionary["modificationDate"] as? String {
            modificationDate = formatter.date(from: modificationDateString)
        } else {
            modificationDate = nil
        }
        
        let hexColor = dictionary["hexColor"] as? String ?? "FFFFF"
        
        let categoryString = dictionary["category"] as? String ?? Category.other.rawValue
        guard let category = Category(rawValue: categoryString) else {
            return nil
        }
        
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modificationDate, hexColor: hexColor, category: category)
    }
    
    var json: Any {
        
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        var dictionary: [String: Any] = [
            "id": id,
            "text": text,
            "creationDate": formatter.string(from: creationDate),
            "isCompleted": isCompleted,
            "hexColor": hexColor,
            "category": category.rawValue
        ]
        
        if priority != .regular {
            dictionary["priority"] = priority.rawValue
        }
        
        if let deadline = deadline {
            dictionary["deadline"] = formatter.string(from: deadline)
        }
        
        if let modificationDate = modificationDate {
            dictionary["modificationDate"] = formatter.string(from: modificationDate)
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: []),
              let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: []) else {
            return [:]
        }
        
        return jsonResult
    }
}
