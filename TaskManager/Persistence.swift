//
//  Persistence.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController() // Singleton instance

    let container: NSPersistentContainer // Persistent container

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TaskManager") // Initialize with the model name
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null") // Use in-memory store for testing
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)") // Handle errors during store loading
            }
        })
    }

// Preview instance for SwiftUI previews
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true) // Use in-memory store for previews
        let viewContext = result.container.viewContext

        // Add sample data for previews
        for i in 0..<10 {
            let newTask = Task(context: viewContext)
            newTask.title = "Task \(i)"
            newTask.taskDescription = "This is a sample task."
            newTask.priority = i % 2 == 0 ? "Low" : "High"
            newTask.dueDate = Date()
            newTask.isCompleted = false
        }

        do {
            try viewContext.save() // Save the sample data
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)") // Handle errors during save
        }

        return result
    }()
}
