//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared // Shared instance of PersistenceController

    var body: some Scene {
        WindowGroup {
            TaskListView(context: persistenceController.container.viewContext) // Main view with context
                .environment(\.managedObjectContext, persistenceController.container.viewContext) // Provide context to the environment
        }
    }
}
