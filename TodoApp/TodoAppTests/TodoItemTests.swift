//
//  TodoItemTests.swift
//  TodoAppTests
//
//  Created by Виктория Серикова on 16.06.2024.
//

import XCTest
@testable import TodoApp

class TodoItemTestsInitialization: XCTestCase {
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        return formatter
    }()
    
    func testTodoItemInitialization() {
        let item = TodoItem(text: "Test Task", priority: .regular)
        XCTAssertEqual(item.text, "Test Task")
        XCTAssertEqual(item.priority, .regular)
        XCTAssertNil(item.deadline)
        XCTAssertFalse(item.isCompleted)
        XCTAssertNotNil(item.creationDate)
        XCTAssertNil(item.modificationDate)
        XCTAssertEqual(item.hexColor, "FFFFF")
        XCTAssertEqual(item.category, .other)
    }
    
    func testTodoItemInitializationWithAllParameters() {
        let deadline = Date().addingTimeInterval(86400)
        let creationDate = Date().addingTimeInterval(-86400)
        let modificationDate = Date()
        let item = TodoItem(
            id: "12345",
            text: "Test Task",
            priority: .regular,
            deadline: deadline,
            isCompleted: true,
            creationDate: creationDate,
            modificationDate: modificationDate,
            hexColor: "FF5733",
            category: .hobby
        )
        
        XCTAssertEqual(item.id, "12345")
        XCTAssertEqual(item.text, "Test Task")
        XCTAssertEqual(item.priority, .regular)
        XCTAssertEqual(item.deadline, deadline)
        XCTAssertTrue(item.isCompleted)
        XCTAssertEqual(item.creationDate, creationDate)
        XCTAssertEqual(item.modificationDate, modificationDate)
        XCTAssertEqual(item.hexColor, "FF5733")
        XCTAssertEqual(item.category, .hobby)
    }
}

class TodoItemTestsSerialization: XCTestCase {
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        return formatter
    }()
    
    func testTodoItemToJSON() {
        let item = TodoItem(text: "Test Task", priority: .regular, hexColor: "FF5733")
        let json = item.json as? [String: Any]
        
        XCTAssertNotNil(json)
        XCTAssertEqual(json?["id"] as? String, item.id)
        XCTAssertEqual(json?["text"] as? String, "Test Task")
        XCTAssertEqual(json?["isCompleted"] as? Bool, false)
        XCTAssertEqual(json?["creationDate"] as? String, dateFormatter.string(from: item.creationDate))
        XCTAssertNil(json?["deadline"])
        XCTAssertNil(json?["modificationDate"])
        XCTAssertNil(json?["priority"])
        XCTAssertEqual(json?["hexColor"] as? String, "FF5733")
        XCTAssertEqual(json?["category"] as? String, "Other")
    }
    
    func testTodoItemToJSONWithAllParameters() {
        let deadline = Date().addingTimeInterval(86400)
        let creationDate = Date().addingTimeInterval(-86400)
        let modificationDate = Date()
        let item = TodoItem(
            id: "12345",
            text: "Test Task",
            priority: .important,
            deadline: deadline,
            isCompleted: true,
            creationDate: creationDate,
            modificationDate: modificationDate,
            hexColor: "FF5733",
            category: .work
        )
        let json = item.json as? [String: Any]
        
        XCTAssertNotNil(json)
        XCTAssertEqual(json?["id"] as? String, "12345")
        XCTAssertEqual(json?["text"] as? String, "Test Task")
        XCTAssertEqual(json?["isCompleted"] as? Bool, true)
        XCTAssertEqual(json?["creationDate"] as? String, dateFormatter.string(from: creationDate))
        XCTAssertEqual(json?["deadline"] as? String, dateFormatter.string(from: deadline))
        XCTAssertEqual(json?["modificationDate"] as? String, dateFormatter.string(from: modificationDate))
        XCTAssertEqual(json?["priority"] as? String, "important")
        XCTAssertEqual(json?["hexColor"] as? String, "FF5733")
        XCTAssertEqual(json?["category"] as? String, "Work")
    }
    
    func testTodoItemFromJSON() {
        let creationDateString = dateFormatter.string(from: Date())
        let json: [String: Any] = [
            "id": "12345",
            "text": "Test Task",
            "creationDate": creationDateString,
            "isCompleted": false,
            "hexColor": "FF5733"
        ]
        if let item = TodoItem.parse(json: json) {
            XCTAssertEqual(item.id, "12345")
            XCTAssertEqual(item.text, "Test Task")
            XCTAssertEqual(item.priority, .regular)
            XCTAssertNil(item.deadline)
            XCTAssertFalse(item.isCompleted)
            XCTAssertEqual(item.creationDate, dateFormatter.date(from: creationDateString))
            XCTAssertNil(item.modificationDate)
            XCTAssertEqual(item.hexColor, "FF5733")
            XCTAssertEqual(item.category, .other)
        } else {
            XCTFail("Failed to parse TodoItem from JSON")
        }
    }
    
    func testTodoItemFromJSONWithAllParameters() {
        let creationDateString = dateFormatter.string(from: Date().addingTimeInterval(-86400))
        let deadlineString = dateFormatter.string(from: Date().addingTimeInterval(86400))
        let modificationDateString = dateFormatter.string(from: Date())
        let json: [String: Any] = [
            "id": "12345",
            "text": "Test Task",
            "priority": "important",
            "deadline": deadlineString,
            "isCompleted": true,
            "creationDate": creationDateString,
            "modificationDate": modificationDateString,
            "hexColor": "FF5733",
            "category": "Work"
        ]
        if let item = TodoItem.parse(json: json) {
            XCTAssertEqual(item.id, "12345")
            XCTAssertEqual(item.text, "Test Task")
            XCTAssertEqual(item.priority, .important)
            XCTAssertEqual(item.deadline, dateFormatter.date(from: deadlineString))
            XCTAssertTrue(item.isCompleted)
            XCTAssertEqual(item.creationDate, dateFormatter.date(from: creationDateString))
            XCTAssertEqual(item.modificationDate, dateFormatter.date(from: modificationDateString))
            XCTAssertEqual(item.hexColor, "FF5733")
            XCTAssertEqual(item.category, .work)
        } else {
            XCTFail("Failed to parse TodoItem from JSON")
        }
    }
    
    func testTodoItemToCSV() {
        let item = TodoItem(text: "Test Task", priority: .regular, hexColor: "FF5733", category: .other)
        let csvString = item.csv
        let components = csvString.components(separatedBy: ",")
        
        XCTAssertEqual(components.count, 9)
        XCTAssertEqual(components[0], item.id)
        XCTAssertEqual(components[1], "Test Task")
        XCTAssertEqual(components[2], "")
        XCTAssertEqual(components[3], "")
        XCTAssertEqual(components[4], "false")
        XCTAssertEqual(components[5], dateFormatter.string(from: item.creationDate))
        XCTAssertEqual(components[6], "FF5733")
        XCTAssertEqual(components[7], "Other")
        XCTAssertEqual(components[8], "")
    }
    
    func testTodoItemToCSVWithAllParameters() {
        let deadline = Date().addingTimeInterval(86400)
        let creationDate = Date().addingTimeInterval(-86400)
        let modificationDate = Date()
        let item = TodoItem(
            id: "12345",
            text: "Test Task",
            priority: .important,
            deadline: deadline,
            isCompleted: true,
            creationDate: creationDate,
            modificationDate: modificationDate,
            hexColor: "FF5733",
            category: .work
        )
        let csvString = item.csv
        let components = csvString.components(separatedBy: ",")
        
        XCTAssertEqual(components.count, 9)
        XCTAssertEqual(components[0], "12345")
        XCTAssertEqual(components[1], "Test Task")
        XCTAssertEqual(components[2], "important")
        XCTAssertEqual(components[3], dateFormatter.string(from: deadline))
        XCTAssertEqual(components[4], "true")
        XCTAssertEqual(components[5], dateFormatter.string(from: creationDate))
        XCTAssertEqual(components[6], "FF5733")
        XCTAssertEqual(components[7], "Work")
        XCTAssertEqual(components[8], dateFormatter.string(from: modificationDate))
    }
    
    func testTodoItemFromCSV() {
        let creationDateString = dateFormatter.string(from: Date())
        let csvString = "\(UUID().uuidString),Test Task,regular,,false,\(creationDateString),FFFFF,Other,"
        
        if let item = TodoItem.fromCSV(csvString) {
            XCTAssertEqual(item.text, "Test Task")
            XCTAssertEqual(item.priority, .regular)
            XCTAssertNil(item.deadline)
            XCTAssertFalse(item.isCompleted)
            XCTAssertEqual(item.creationDate, dateFormatter.date(from: creationDateString))
            XCTAssertNil(item.modificationDate)
            XCTAssertEqual(item.hexColor, "FFFFF")
            XCTAssertEqual(item.category, .other)
        } else {
            XCTFail("Failed to parse TodoItem from CSV")
        }
    }
    
    func testTodoItemFromCSVWithAllParameters() {
        let creationDateString = dateFormatter.string(from: Date().addingTimeInterval(-86400))
        let deadlineString = dateFormatter.string(from: Date().addingTimeInterval(86400))
        let modificationDateString = dateFormatter.string(from: Date())
        let csvString = """
            12345,Test Task,important,\(deadlineString),true,\
            \(creationDateString),FF5733,Work,\(modificationDateString)
            """
        
        if let item = TodoItem.fromCSV(csvString) {
            XCTAssertEqual(item.id, "12345")
            XCTAssertEqual(item.text, "Test Task")
            XCTAssertEqual(item.priority, .important)
            XCTAssertEqual(item.deadline, dateFormatter.date(from: deadlineString))
            XCTAssertTrue(item.isCompleted)
            XCTAssertEqual(item.creationDate, dateFormatter.date(from: creationDateString))
            XCTAssertEqual(item.hexColor, "FF5733")
            XCTAssertEqual(item.modificationDate, dateFormatter.date(from: modificationDateString))
            XCTAssertEqual(item.category, .work)
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
        let invalidCSV = "12345,Test Task,important,invalid_date,true,invalid_date,invalid_date,FF5733,Work"
        let item = TodoItem.fromCSV(invalidCSV)
        XCTAssertNil(item, "Parsing should fail with invalid date format in CSV")
    }
}

class TodoItemTestsEdgeCases: XCTestCase {
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        return formatter
    }()
    
    func testTodoItemToCSVWithComma() {
        let deadline = Date().addingTimeInterval(86400)
        let creationDate = Date().addingTimeInterval(-86400)
        let modificationDate = Date()
        let item = TodoItem(
            id: "12345",
            text: "Test, with comma",
            priority: .important,
            deadline: deadline,
            isCompleted: true,
            creationDate: creationDate,
            modificationDate: modificationDate,
            hexColor: "FF5733",
            category: .hobby
        )
        let csvString = item.csv
        let expectedCSV = """
            12345,\"Test, with comma\",important,\
            \(dateFormatter.string(from: deadline)),true,\
            \(dateFormatter.string(from: creationDate)),FF5733,\
            Hobby,\(dateFormatter.string(from: modificationDate))
            """
        
        XCTAssertEqual(csvString, expectedCSV, "CSV field text with comma is not supported")
    }
    
    func testTodoItemFromCSVWithComma() {
        let creationDateString = dateFormatter.string(from: Date().addingTimeInterval(-86400))
        let deadlineString = dateFormatter.string(from: Date().addingTimeInterval(86400))
        let modificationDateString = dateFormatter.string(from: Date())
        let csvString = """
            12345,"Test, with comma",important,\
            \(deadlineString),true,\
            \(creationDateString),FF5733,\
            Hobby,\(modificationDateString)
            """
        
        if let item = TodoItem.fromCSV(csvString) {
            XCTAssertEqual(item.id, "12345")
            XCTAssertEqual(item.text, "Test, with comma")
            XCTAssertEqual(item.priority, .important)
            XCTAssertEqual(item.deadline, dateFormatter.date(from: deadlineString))
            XCTAssertTrue(item.isCompleted)
            XCTAssertEqual(item.creationDate, dateFormatter.date(from: creationDateString))
            XCTAssertEqual(item.modificationDate, dateFormatter.date(from: modificationDateString))
            XCTAssertEqual(item.hexColor, "FF5733")
            XCTAssertEqual(item.category, .hobby)
        } else {
            XCTFail("Failed to parse TodoItem from CSV when text contains comma")
        }
    }
}
