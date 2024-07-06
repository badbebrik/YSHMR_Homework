//
//  TodoItem+CSV.swift
//  TodoApp
//
//  Created by Виктория Серикова on 22.06.2024.
//

import Foundation

extension TodoItem {
    var csv: String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        func escape(_ text: String) -> String {
            if text.contains(",") || text.contains("\"") || text.contains("\n") {
                return "\"\(text.replacingOccurrences(of: "\"", with: "\"\""))\""
            } else {
                return text
            }
        }
        
        var components: [String] = [
            id,
            escape(text),
            isCompleted.description,
            formatter.string(from: creationDate),
            hexColor,
            category.rawValue
        ]
        
        if priority != .regular {
            components.insert(priority.rawValue, at: 2)
        } else {
            components.insert("", at: 2)
        }
        
        if let deadline = deadline {
            components.insert(formatter.string(from: deadline), at: 3)
        } else {
            components.insert("", at: 3)
        }
        
        if let modificationDate = modificationDate {
            components.append(formatter.string(from: modificationDate))
        } else {
            components.append("")
        }
        
        return components.joined(separator: ",")
    }
    
    static func fromCSV(_ csv: String) -> TodoItem? {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        
        func unescape(_ text: String) -> String {
            if text.hasPrefix("\"") && text.hasSuffix("\"") {
                let startIndex = text.index(after: text.startIndex)
                let endIndex = text.index(before: text.endIndex)
                return String(text[startIndex..<endIndex]).replacingOccurrences(of: "\"\"", with: "\"")
            } else {
                return text
            }
        }
        
        let pattern = "(?<=^|,)(\"(?:[^\"]|\"\")*\"|[^,]*)"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: csv, options: [], range: NSRange(csv.startIndex..., in: csv))
        
        let components = matches.map { match -> String in
            let range = Range(match.range, in: csv)!
            return String(csv[range])
        }.map(unescape)
        
        guard components.count >= 8 else { return nil }
        
        let id = components[0]
        let text = components[1]
        let priorityString = components[2]
        let priority = priorityString.isEmpty ? .regular : Priority(rawValue: priorityString) ?? .regular
        
        let deadlineString = components[3]
        let deadline = deadlineString.isEmpty ? nil : formatter.date(from: deadlineString)
        
        let isCompleted = (components[4] as NSString).boolValue
        
        let creationDateString = components[5]
        guard let creationDate = formatter.date(from: creationDateString) else {
            return nil
        }
        
        let hexColor = components[6]
        let categoryString = components[7]
        let category = Category(rawValue: categoryString) ?? .other
        
        let modificationDateString = components.count > 8 ? components[8] : ""
        let modificationDate = modificationDateString.isEmpty ? nil : formatter.date(from: modificationDateString)
        
        return TodoItem(id: id, text: text, priority: priority, deadline: deadline, isCompleted: isCompleted, creationDate: creationDate, modificationDate: modificationDate, hexColor: hexColor, category: category)
    }
}
