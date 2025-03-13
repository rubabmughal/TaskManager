//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//

import CoreData
import SwiftUI
import CoreHaptics  // ✅ Import for haptic feedback

//✅ Dynamic system colors for Light & Dark Mode
var colorMap: [String: Color] = [
    "Blue": .blue,
    "Red": .red,
    "Green": .green,
    "Purple": .purple,
    "Orange": .orange
]

// ✅ Sorting Options Enum
enum SortOption {
    case priority, dueDate, alphabetical
}

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    private var viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchTasks()
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.dueDate, ascending: true)]
        
        do {
            tasks = try viewContext.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
    
    func addTask(title: String, description: String, priority: String, dueDate: Date) {
        let newTask = Task(context: viewContext)
        newTask.id = UUID()
        newTask.title = title
        newTask.taskDescription = description
        newTask.priority = priority
        newTask.dueDate = dueDate
        newTask.isCompleted = false
        newTask.order = Int16(tasks.count)
        
        saveContext()
    }
    
    func updateTask(task: Task, title: String, description: String, priority: String, dueDate: Date) {
        task.title = title
        task.taskDescription = description
        task.priority = priority
        task.dueDate = dueDate
        
        saveContext()
    }

    // Deletes a task from Core Data.
        func deleteTask(_ task: Task) {
            viewContext.delete(task)
            saveContext()
        }

    func restoreDeletedTask(_ task: Task) {
        viewContext.insert(task)
        saveContext()
        }
    
    func toggleTaskCompletion(task: Task) {
        task.isCompleted.toggle()
        saveContext()
      
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            fetchTasks()
           
        } catch {
            print("Error saving context: \(error)")
        }
    }
    // ✅ Forces SwiftUI to refresh the UI after task deletion
        private func refreshUI() {
            DispatchQueue.main.async {
                self.objectWillChange.send()  // ✅ Triggers UI update
            }
        }
   
    // ✅ Triggers Haptic Feedback when tasks are moved
    private func triggerHapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
    /// ✅ Fetches all tasks from Core Data to reorder correctly
    private func fetchAllTasks() -> [Task] {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching all tasks: \(error)")
            return []
        }
    }
    func moveTask(from source: IndexSet, to destination: Int) {
        // ✅ Ensure we reorder tasks in the FULL list, not just filtered results
        var allTasks = fetchAllTasks()  // ✅ Get all tasks from Core Data
        allTasks.move(fromOffsets: source, toOffset: destination)

        // ✅ Assign new positions based on the new list order
        for (index, task) in allTasks.enumerated() {
            task.position = Int16(index)
        }

        saveContext()  // ✅ Save the new order in Core Data
        triggerHapticFeedback()  // ✅ Add haptic feedback on move
    }

}
