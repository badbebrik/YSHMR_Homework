//
//  TodoItemTests.swift
//  TodoAppTests
//
//  Created by Виктория Серикова on 16.06.2024.
//

import XCTest
@testable import TodoApp

final class TodoItemTests: XCTestCase {
    
    func testTodoItemInitialization() {
            let item = TodoItem(text: "Test Task", priority: .regular)
            XCTAssertEqual(item.text, "Test Task")
            XCTAssertEqual(item.priority, .regular)
            XCTAssertNil(item.deadline)
            XCTAssertFalse(item.isCompleted)
            XCTAssertNotNil(item.creationDate)
            XCTAssertNil(item.modificationDate)
        }

        func testTodoItemInitializationWithAllParameters() {
            let deadline = Date().addingTimeInterval(86400)
            let creationDate = Date().addingTimeInterval(-86400)
            let modificationDate = Date()
            let item = TodoItem(id: "12345", text: "Test Task", priority: .regular, deadline: deadline, isCompleted: true, creationDate: creationDate, modificationDate: modificationDate)
            
            XCTAssertEqual(item.id, "12345")
            XCTAssertEqual(item.text, "Test Task")
            XCTAssertEqual(item.priority, .regular)
            XCTAssertEqual(item.deadline, deadline)
            XCTAssertTrue(item.isCompleted)
            XCTAssertEqual(item.creationDate, creationDate)
            XCTAssertEqual(item.modificationDate, modificationDate)
        }

        func testTodoItemToJSON() {
            let item = TodoItem(text: "Test Task", priority: .regular)
            let json = item.json as? [String: Any]
            
            XCTAssertNotNil(json)
            XCTAssertEqual(json?["id"] as? String, item.id)
            XCTAssertEqual(json?["text"] as? String, "Test Task")
            XCTAssertEqual(json?["isCompleted"] as? Bool, false)
            XCTAssertEqual(json?["creationDate"] as? String, TodoItem.localDateFormatter.string(from: item.creationDate))
            XCTAssertNil(json?["deadline"])
            XCTAssertNil(json?["modificationDate"])
            XCTAssertNil(json?["priority"])
        }

        func testTodoItemToJSONWithAllParameters() {
            let deadline = Date().addingTimeInterval(86400)
            let creationDate = Date().addingTimeInterval(-86400)
            let modificationDate = Date()
            let item = TodoItem(id: "12345", text: "Test Task", priority: .important, deadline: deadline, isCompleted: true, creationDate: creationDate, modificationDate: modificationDate)
            let json = item.json as? [String: Any]
            
            XCTAssertNotNil(json)
            XCTAssertEqual(json?["id"] as? String, "12345")
            XCTAssertEqual(json?["text"] as? String, "Test Task")
            XCTAssertEqual(json?["isCompleted"] as? Bool, true)
            XCTAssertEqual(json?["creationDate"] as? String, TodoItem.localDateFormatter.string(from: creationDate))
            XCTAssertEqual(json?["deadline"] as? String, TodoItem.localDateFormatter.string(from: deadline))
            XCTAssertEqual(json?["modificationDate"] as? String, TodoItem.localDateFormatter.string(from: modificationDate))
            XCTAssertEqual(json?["priority"] as? String, "important")
        }

        func testTodoItemFromJSON() {
            let creationDateString = TodoItem.localDateFormatter.string(from: Date())
            let json: [String: Any] = [
                "id": "12345",
                "text": "Test Task",
                "creationDate": creationDateString,
                "isCompleted": false
            ]
            if let item = TodoItem.parse(json: json) {
                XCTAssertEqual(item.id, "12345")
                XCTAssertEqual(item.text, "Test Task")
                XCTAssertEqual(item.priority, .regular)
                XCTAssertNil(item.deadline)
                XCTAssertFalse(item.isCompleted)
                XCTAssertEqual(item.creationDate, TodoItem.localDateFormatter.date(from: creationDateString))
                XCTAssertNil(item.modificationDate)
            } else {
                XCTFail("Failed to parse TodoItem from JSON")
            }
        }

        func testTodoItemFromJSONWithAllParameters() {
            let creationDateString = TodoItem.localDateFormatter.string(from: Date().addingTimeInterval(-86400))
            let deadlineString = TodoItem.localDateFormatter.string(from: Date().addingTimeInterval(86400))
            let modificationDateString = TodoItem.localDateFormatter.string(from: Date())
            let json: [String: Any] = [
                "id": "12345",
                "text": "Test Task",
                "priority": "important",
                "deadline": deadlineString,
                "isCompleted": true,
                "creationDate": creationDateString,
                "modificationDate": modificationDateString
            ]
            if let item = TodoItem.parse(json: json) {
                XCTAssertEqual(item.id, "12345")
                XCTAssertEqual(item.text, "Test Task")
                XCTAssertEqual(item.priority, .important)
                XCTAssertEqual(item.deadline, TodoItem.localDateFormatter.date(from: deadlineString))
                XCTAssertTrue(item.isCompleted)
                XCTAssertEqual(item.creationDate, TodoItem.localDateFormatter.date(from: creationDateString))
                XCTAssertEqual(item.modificationDate, TodoItem.localDateFormatter.date(from: modificationDateString))
            } else {
                XCTFail("Failed to parse TodoItem from JSON")
            }
        }

        func testTodoItemToCSV() {
            let item = TodoItem(text: "Test Task", priority: .regular)
            let csvString = item.csv
            let components = csvString.components(separatedBy: ",")
            
            XCTAssertEqual(components.count, 7)
            XCTAssertEqual(components[1], "Test Task")
            XCTAssertEqual(components[2], "regular")
            XCTAssertEqual(components[3], "")
            XCTAssertEqual(components[4], "false")
            XCTAssertEqual(components[5], TodoItem.localDateFormatter.string(from: item.creationDate))
            XCTAssertEqual(components[6], "")
        }

        func testTodoItemToCSVWithAllParameters() {
            let deadline = Date().addingTimeInterval(86400)
            let creationDate = Date().addingTimeInterval(-86400)
            let modificationDate = Date()
            let item = TodoItem(id: "12345", text: "Test Task", priority: .important, deadline: deadline, isCompleted: true, creationDate: creationDate, modificationDate: modificationDate)
            let csvString = item.csv
            let components = csvString.components(separatedBy: ",")
            
            XCTAssertEqual(components.count, 7)
            XCTAssertEqual(components[0], "12345")
            XCTAssertEqual(components[1], "Test Task")
            XCTAssertEqual(components[2], "important")
            XCTAssertEqual(components[3], TodoItem.localDateFormatter.string(from: deadline))
            XCTAssertEqual(components[4], "true")
            XCTAssertEqual(components[5], TodoItem.localDateFormatter.string(from: creationDate))
            XCTAssertEqual(components[6], TodoItem.localDateFormatter.string(from: modificationDate))
        }

        func testTodoItemFromCSV() {
            let creationDateString = TodoItem.localDateFormatter.string(from: Date())
            let csvString = "\(UUID().uuidString),Test Task,regular,,false,\(creationDateString),"
            
            if let item = TodoItem.fromCSV(csvString) {
                XCTAssertEqual(item.text, "Test Task")
                XCTAssertEqual(item.priority, .regular)
                XCTAssertNil(item.deadline)
                XCTAssertFalse(item.isCompleted)
                XCTAssertEqual(item.creationDate, TodoItem.localDateFormatter.date(from: creationDateString))
                XCTAssertNil(item.modificationDate)
            } else {
                XCTFail("Failed to parse TodoItem from CSV")
            }
        }

        func testTodoItemFromCSVWithAllParameters() {
            let creationDateString = TodoItem.localDateFormatter.string(from: Date().addingTimeInterval(-86400))
            let deadlineString = TodoItem.localDateFormatter.string(from: Date().addingTimeInterval(86400))
            let modificationDateString = TodoItem.localDateFormatter.string(from: Date())
            let csvString = "12345,Test Task,important,\(deadlineString),true,\(creationDateString),\(modificationDateString)"
            
            if let item = TodoItem.fromCSV(csvString) {
                XCTAssertEqual(item.id, "12345")
                XCTAssertEqual(item.text, "Test Task")
                XCTAssertEqual(item.priority, .important)
                XCTAssertEqual(item.deadline, TodoItem.localDateFormatter.date(from: deadlineString))
                XCTAssertTrue(item.isCompleted)
                XCTAssertEqual(item.creationDate, TodoItem.localDateFormatter.date(from: creationDateString))
                XCTAssertEqual(item.modificationDate, TodoItem.localDateFormatter.date(from: modificationDateString))
            } else {
                XCTFail("Failed to parse TodoItem from CSV")
            }
        }


        func testInvalidJSONParsing() {
            let invalidJSON: [String: Any] = [
                "id": "12345",
                "creationDate": "invalid_date",
                "isCompleted": false
            ]
            let item = TodoItem.parse(json: invalidJSON)
            XCTAssertNil(item, "Parsing should fail with invalid date format")
        }

        func testInvalidCSVParsing() {
            let invalidCSV = "12345,Test Task,important,invalid_date,true,invalid_date,invalid_date"
            let item = TodoItem.fromCSV(invalidCSV)
            XCTAssertNil(item, "Parsing should fail with invalid date format in CSV")
        }

}
