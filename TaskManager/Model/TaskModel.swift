//
//  TaskModel.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//

import CoreData

@objc(Task)
public class Task: NSManagedObject {
    @NSManaged public var title: String? // Title of the task
    @NSManaged public var taskDescription: String? // Description of the task
    @NSManaged public var priority: String? // Priority of the task (Low, Medium, High)
    @NSManaged public var dueDate: Date? // Due date of the task
    @NSManaged public var isCompleted: Bool // Completion status of the task
    @NSManaged public var order: Int16 // Order of the task in the list
    @NSManaged public var id: UUID?
    @NSManaged public var position: Int16 // position of the task
}

extension Task {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task") // Fetch request for Task entity
    }
}
