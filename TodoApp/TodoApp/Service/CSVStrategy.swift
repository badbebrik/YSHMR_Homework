//
//  CSVStrategy.swift
//  TodoApp
//
//  Created by Виктория Серикова on 16.06.2024.
//

import Foundation

class CSVStrategy: StorageStrategy {
    func save(items: [String: TodoItem], to filename: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        var csvArray: [String] = ["id,text,priority,deadline,isCompleted,creationDate,modificationDate"]
        csvArray.append(contentsOf: items.values.map { $0.csv })
        let csvString = csvArray.joined(separator: "\n")
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("CSV file saved to: \(fileURL.path)")
        } catch {
            print("Failed to save CSV file: \(error)")
        }
    }

    func load(from filename: String) -> [String: TodoItem] {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        var items: [String: TodoItem] = [:]
        
        do {
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            let csvLines = csvString.components(separatedBy: "\n")
            guard csvLines.count > 1 else {
                return items
            }
            for csvLine in csvLines.dropFirst() {
                if let item = TodoItem.fromCSV(csvLine) {
                    items[item.id] = item
                }
            }
            print("CSV file loaded from: \(fileURL.path)")
        } catch {
            print("Failed to load CSV file: \(error)")
        }
        return items
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

