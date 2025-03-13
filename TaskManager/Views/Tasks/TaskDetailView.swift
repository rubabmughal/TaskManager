//
//  TaskDetailView.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//
import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var viewModel: TaskViewModel
    @State private var isShowingEditView = false
    @State private var animateView = false
    @AppStorage("accentColor") private var accentColor: String = "Blue"
    var body: some View {
        Form {  // ✅ Ensure Form uses { } correctly
            // ✅ Task Details Section
            Section(header: Text("Task Details")) {
                Text(task.title ?? "Untitled")
                    .font(.title2)
                    .bold()
                    .accessibilityLabel("Task title: \(task.title ?? "Untitled")")
                    .dynamicTypeSize(.xSmall ... .xxxLarge)  // ✅ Supports Dynamic Type Scaling
                    .scaleEffect(animateView ? 1.0 : 0.9)  // ✅ Subtle animation, no extreme shrink
                    .opacity(animateView ? 1.0 : 0.5)  // ✅ Starts slightly visible
                    .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.4), value: animateView)
                
                if let description = task.taskDescription, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Task description: \(description)")
                        .dynamicTypeSize(.xSmall ... .xxxLarge)  // ✅ Supports Dynamic Type Scaling
                }
                
                Text("Priority: \(task.priority ?? "Low")")
                    .font(.subheadline)
                    .foregroundColor(colorMap[accentColor])
                    .accessibilityLabel("Priority level is \(task.priority ?? "Low")")
                    .dynamicTypeSize(.xSmall ... .xxxLarge)
                    .accessibilityIdentifier("PriorityPicker") // 
                
                Text("Due Date: \(task.dueDate ?? Date(), formatter: itemFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityLabel("Due date is \(itemFormatter.string(from: task.dueDate ?? Date()))")
                    .dynamicTypeSize(.xSmall ... .xxxLarge)
            }
            
            // ✅ Actions Section
            Section {
                Button {
                    withAnimation {
                        toggleTaskCompletion()
                    }
                } label: {
                    Text(task.isCompleted ? "Mark as Pending" : "Mark as Completed")
                        .fontWeight(.bold)
                        .foregroundColor(task.isCompleted ? .orange : .green)
                }
                
                Button {
                    isShowingEditView.toggle()
                } label: {
                    Text("Edit Task")
                        .fontWeight(.bold)
                        .foregroundColor(colorMap[accentColor])
                }
                
                Button {
                    withAnimation {
                        deleteTask()
                    }
                } label: {
                    Text("Delete Task")
                        .foregroundColor(.red)
                        .bold()
                }
            }
        }
        .navigationTitle("Task Details")
        .onAppear {
            print("TaskDetailView appeared!")  // ✅ Debugging print
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    animateView = true  // ✅ Ensures smooth appearance
                }
            }
        }
        .sheet(isPresented: $isShowingEditView) {
            TaskCreationView(viewModel: viewModel, taskToEdit: task)  // ✅ No unnecessary `viewModel`
        }
    }
    
    /// ✅ Toggle Task Completion
    private func toggleTaskCompletion() {
        task.isCompleted.toggle()
        saveChanges()
    }
    
    /// ✅ Delete Task
    private func deleteTask() {
        context.delete(task)
        saveChanges()
    }
    
    /// ✅ Save Changes to Core Data
    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Error saving task: \(error)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()
