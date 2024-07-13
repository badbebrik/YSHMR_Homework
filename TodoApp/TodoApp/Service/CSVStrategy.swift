//
//  CSVStrategy.swift
//  TodoApp
//
//  Created by Виктория Серикова on 16.06.2024.
//

import Foundation
import CocoaLumberjackSwift

class CSVStrategy: StorageStrategy {
    func save(items: [TodoItem], to filename: String) {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            DDLogError("Failed to get documents directory")
            return
        }
        var csvArray: [String] = ["id,text,priority,deadline,isCompleted,creationDate,modificationDate"]
        csvArray.append(contentsOf: items.map { $0.csv })
        let csvString = csvArray.joined(separator: "\n")
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            DDLogInfo("CSV file saved to: \(fileURL.path)")
        } catch {
            DDLogError("Failed to save CSV file: \(error)")
        }
    }
    
    func load(from filename: String) -> [TodoItem] {
        guard let fileURL = getDocumentsDirectory()?.appendingPathComponent(filename) else {
            DDLogError("Failed to get documents directory")
            return []
        }
        var items: [TodoItem] = []
        
        do {
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            let csvLines = csvString.components(separatedBy: "\n")
            guard csvLines.count > 1 else {
                return items
            }
            for csvLine in csvLines.dropFirst() {
                if let item = TodoItem.fromCSV(csvLine) {
                    items.append(item)
                }
            }
            DDLogInfo("CSV file loaded from: \(fileURL.path)")
        } catch {
            DDLogError("Failed to load CSV file: \(error)")
        }
        return items
    }
    
    private func getDocumentsDirectory() -> URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
