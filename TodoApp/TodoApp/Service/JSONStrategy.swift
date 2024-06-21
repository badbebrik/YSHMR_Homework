//
//  JSONStrategy.swift
//  TodoApp
//
//  Created by Виктория Серикова on 16.06.2024.
//

import Foundation

class JSONStrategy: StorageStrategy {
    func save(items: [String: TodoItem], to filename: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        let jsonArray: [Any] = items.values.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
            print("JSON file saved to: \(fileURL.path)")
        } catch {
            print("Failed to save JSON file: \(error)")
        }
    }

    func load(from filename: String) -> [String: TodoItem] {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        var items: [String: TodoItem] = [:]
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] {
                for jsonItem in jsonArray {
                    if let item = TodoItem.parse(json: jsonItem) {
                        items[item.id] = item
                    }
                }
            }
            print("JSON file loaded from: \(fileURL.path)")
        } catch {
            print("Failed to load JSON file: \(error)")
        }
        return items
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}


