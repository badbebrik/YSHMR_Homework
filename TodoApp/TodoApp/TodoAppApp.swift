//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by Виктория Серикова on 21.06.2024.
//

import SwiftUI
import CocoaLumberjackSwift

@main
struct TodoAppApp: App {
    init() {
        setupLogging()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    private func setupLogging() {
        DDLog.add(DDOSLogger.sharedInstance)
        DDLogInfo("Logging initialized")
    }
}
