//
//  TaskCreationView.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//

import SwiftUI

struct TaskCreationView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var priority: String = "Low"
    @State private var dueDate: Date = Date()
    
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("accentColor") private var accentColor: String = "Blue"
    var taskToEdit: Task? // Optional task to edit
    
    init(viewModel: TaskViewModel, taskToEdit: Task? = nil) {
        self.viewModel = viewModel
        self.taskToEdit = taskToEdit
        
        // Pre-fill fields if editing an existing task
        if let task = taskToEdit {
            _title = State(initialValue: task.title ?? "")
            _description = State(initialValue: task.taskDescription ?? "")
            _priority = State(initialValue: task.priority ?? "Low")
            _dueDate = State(initialValue: task.dueDate ?? Date())
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
                Picker("Priority", selection: $priority) {
                    Text("Low").tag("Low")
                    Text("Medium").tag("Medium")
                    Text("High").tag("High")
                }
                .accessibilityIdentifier("PriorityPicker")
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    .accessibilityIdentifier("DueDatePicker")

            }
            .navigationTitle(taskToEdit == nil ? "New Task" : "Edit Task") // Set title based on mode
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                       
                        presentationMode.wrappedValue.dismiss()
                    }
                    .tint(colorMap[accentColor])
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(taskToEdit == nil ? "Save" : "Update") {
                      
                        if let task = taskToEdit {
                            // Update existing task
                            viewModel.updateTask(task: task, title: title, description: description, priority: priority, dueDate: dueDate)
                        } else {
                            // Add new task
                            viewModel.addTask(title: title, description: description, priority: priority, dueDate: dueDate)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .accessibilityIdentifier("SaveButton")
                    .tint(colorMap[accentColor])
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
