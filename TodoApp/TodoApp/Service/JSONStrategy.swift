//
//  JSONStrategy.swift
//  TodoApp
//
//  Created by Виктория Серикова on 16.06.2024.
//

import Foundation
import CocoaLumberjackSwift

class JSONStrategy: StorageStrategy {
    func save(items: [TodoItem], to filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            DDLogError("Failed to get documents directory")
            return
        }
        let jsonArray: [Any] = items.map { $0.json }
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try jsonData.write(to: fileURL)
            DDLogInfo("JSON file saved to: \(fileURL.path)")
        } catch {
            DDLogInfo("JSON file saved to: \(fileURL.path)")
        }
    }
    
    func load(from filename: String) -> [TodoItem] {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            DDLogError("Failed to get documents directory")
            return []
        }
        var items: [TodoItem] = []
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [Any] {
                for jsonItem in jsonArray {
                    if let item = TodoItem.parse(json: jsonItem) {
                        items.append(item)
                    }
                }
            }
            DDLogInfo("JSON file loaded from: \(fileURL.path)")
        } catch {
            DDLogError("Failed to load JSON file: \(error)")
        }
        return items
    }
    
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
