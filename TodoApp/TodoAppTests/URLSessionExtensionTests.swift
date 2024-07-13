//
//  URLSessionExtensionTests.swift
//  TodoAppTests
//
//  Created by Виктория Серикова on 13.07.2024.
//

import XCTest

@testable import TodoApp

class URLSessionTests: XCTestCase {
    func testAsyncDataTask() async throws {
        guard let url = URL(string: "https://www.youtube.com/watch?v=T2Velgyvs6s") else { return }
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.dataTask(for: request)
        
        XCTAssertNotNil(data)
        XCTAssertNotNil(response)
    }
    
    func testAsyncDataTaskCancellation() async {
        guard let url = URL(string: "https://www.youtube.com/watch?v=tTviszOV6m8") else {
            return
        }
        let request = URLRequest(url: url)
        
        let task = Task {
            do {
                _ = try await URLSession.shared.dataTask(for: request)
                XCTFail("Not cancelled")
            } catch {
                if error is CancellationError {
                } else {
                    XCTFail("Task failed for an unexpected reason: \(error)")
                }
            }
        }
        
        task.cancel()
        
        do {
            try await Task.sleep(nanoseconds: 100_000_000)
        } catch {
            XCTFail("Cancellation failed")
        }
    }
}
