//
//  TaskListView.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//
import SwiftUI
import CoreData
/// Displays a list of tasks with filtering and sorting options.
struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext // Access the managed object context
    @StateObject private var viewModel: TaskViewModel // StateObject to hold the ViewModel
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: TaskViewModel(context: context)) // Initialize the ViewModel with the context
    }
    @State private var showAddTask = false  // Controls the Add Task modal.
    @State private var showSettings = false
    @State private var filter: String = "All"  // Selected filter option.
    @State private var showUndoSnackbar = false
    @State private var recentlyDeletedTask: Task?
    @State private var sortOption: SortOption = .priority  // ✅ Default sorting by priority
    @AppStorage("accentColor") private var accentColor: String = "Blue"
    // ✅ Fetch updated tasks directly from Core Data (this makes UI update instantly)
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(key: "position", ascending: true)]
    ) private var tasks: FetchedResults<Task>
    
    // Shimmer effect state
        @State private var isLoading = true
   
    
    // Filters tasks based on selection.
    var filteredTasks: [Task] {
        switch filter {
        case "Completed":
            return viewModel.tasks.filter { $0.isCompleted }
        case "Pending":
            return viewModel.tasks.filter { !$0.isCompleted }
        default:
            return viewModel.tasks
        }
    }
    /// ✅ Filtered & Sorted Tasks
    private var sortedFilteredTasks: [Task] {
        let filtered = filterTasks()
        return sortTasks(filtered)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // ✅ Task Progress Indicator (Now updates instantly)
                TaskProgressView()
                // ✅ Sorting Picker
                Picker("Sort by", selection: $sortOption) {
                    Text("Priority").tag(SortOption.priority)
                    Text("Due Date").tag(SortOption.dueDate)
                    Text("Alphabetically").tag(SortOption.alphabetical)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .accessibilityIdentifier("SortSegmentControl")
               
                Picker("Filter", selection: $filter) {
                    Text("All").tag("All")
                    Text("Completed").tag("Completed")
                    Text("Pending").tag("Pending")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .accessibilityIdentifier("FilterSegmentControl")
                // ✅ Task List or Empty State UI
                // Task List or Shimmer Effect
                                   if isLoading {
                                       ForEach(0..<10) { _ in
                                           ShimmerTaskRow()
//                                               .frame(height: 60)
//                                               .padding(.horizontal)
                                       }
                                   } else if filteredTasks.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(sortedFilteredTasks, id: \.wrappedId) { task in
                            NavigationLink(destination: TaskDetailView(task: task, viewModel: viewModel)) {
                                HStack {
                                    VStack {
                                        Text(task.title ?? "Untitled")
                                            .font(.headline)
                                            .foregroundColor(task.isCompleted ? .gray : .primary)
                                            .accessibilityLabel("Task title: \(task.title ?? "Untitled")")
                                            .accessibilityHint("Double-tap to open task details.")
                                        Text(task.taskDescription ?? "Untitled")
                                            .font(.subheadline)
                                            .foregroundColor(task.isCompleted ? .gray : .primary)
                                            .lineLimit(2)
                                            .accessibilityLabel("Task description:")
                                    }
                                    Spacer()
                                    Text(task.priority ?? "Low")
                                        .padding(10)
                                        .background(task.priority == "High" ? Color.red : colorMap[accentColor])
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .accessibilityLabel("low")
                                        .accessibilityIdentifier("PriorityPicker") // Add this
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    recentlyDeletedTask = task
                                    //                                                          viewModel.deleteTask(task)
                                    showUndoSnackbar = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)

                                Button {
                                    //                                                          viewModel.toggleTaskCompletion(task: task)
                                    toggleTaskCompletion(task: task)
                                } label: {
                                    Label(task.isCompleted ? "Mark Pending" : "Complete", systemImage: "checkmark.circle.fill")
                                }
                                .tint(task.isCompleted ? .gray : .green)
                            }
                        }
//                         Drag-and-drop reordering
                        .onMove(perform: viewModel.moveTask)  // ✅ Enables Drag-and-Drop
                        .transition(.scale(scale: 0.3).combined(with: .opacity)) // ✅ Add animation Fade & Scale effect
                    }
                    .accessibilityIdentifier("TaskList")
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                
                HStack {
                    EditButton()  // ✅ REQUIRED to enable drag-and-drop sorting
                    // ✅ Settings Button
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(colorMap[accentColor] ?? .blue)
                    }
                    
                    // ✅ Add Task button with pulse animation
                    Button {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            showAddTask.toggle()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(colorMap[accentColor] ?? .blue)
                            .font(.largeTitle)
                            .scaleEffect(showAddTask ? 1.1 : 1.0) // ✅ Subtle pulse effect
                            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: showAddTask)
                            .keyboardShortcut("n", modifiers: .command)  // ✅ Cmd + N to add a new task
                               .accessibilityLabel("Add new task")
                    }
                }
            }
            .sheet(isPresented: $showAddTask) {
                TaskCreationView(viewModel: viewModel)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .alert("Task Deleted", isPresented: $showUndoSnackbar) {
                Button("Undo", role: .cancel) {
                    if let task = recentlyDeletedTask {
                        //                                                viewModel.restoreDeletedTask(task)
                        restoreDeletedTask(task)
                    }
                }
                Button("OK", role: .destructive) {
                    if let task = recentlyDeletedTask {
                        deleteTask(task)  // ✅ Permanently delete task
                        viewModel.deleteTask(task)
                    }
                }
            } message: {
                Text("Your task was deleted. Undo?")
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isLoading = false  // ✅ Stop shimmer effect after 1.5s
                        }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)  // ✅ Ensures the view is focused
                }
            
            }
    }
    /// ✅ Filters tasks based on the selected filter
    private func filterTasks() -> [Task] {
        switch filter {
        case "Completed":
            return viewModel.tasks.filter { $0.isCompleted }
        case "Pending":
            return viewModel.tasks.filter { !$0.isCompleted }
        default:
            return viewModel.tasks
        }
    }
    private func sortTasks(_ tasks: [Task]) -> [Task] {
        switch sortOption {
        case .priority:
            return tasks.sorted { priorityValue($0.priority) > priorityValue($1.priority) }
        case .dueDate:
            return tasks.sorted { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) }
        case .alphabetical:
            return tasks.sorted { ($0.title ?? "").localizedCompare($1.title ?? "") == .orderedAscending }
        }
    }
    
    /// ✅ Converts priority string into a numerical value for proper sorting
    private func priorityValue(_ priority: String?) -> Int {
        switch priority {
        case "High": return 3
        case "Medium": return 2
        case "Low": return 1
        default: return 0  // ✅ If priority is nil or unknown, treat as lowest priority
        }
    }
    // ✅ Handles drag-and-drop sorting
    private func moveTask(from source: IndexSet, to destination: Int) {
        var updatedTasks = Array(tasks)
        updatedTasks.move(fromOffsets: source, toOffset: destination)
        
        for (index, task) in updatedTasks.enumerated() {
            task.position = Int16(index)
        }
        
        save()
    }
    
    /// ✅ Toggle Task Completion (Updates Instantly)
    private func toggleTaskCompletion(task: Task) {
        task.isCompleted.toggle()
        save()
    }
    
    /// ✅ Save to Core Data and force UI update
    private func save() {
        do {
            try viewContext.save()
            
        } catch {
            print("Error saving: \(error)")
        }
    }
    /// ✅ Restore Deleted Task
    private func restoreDeletedTask(_ task: Task) {
        viewContext.insert(task)
        save()
    }
    /// ✅ Delete Task
    private func deleteTask(_ task: Task) {
        viewContext.delete(task)
        save()
    }
    // ✅ Delete function with fade-out animation
    private func deleteTask1(at offsets: IndexSet) {
        withAnimation(.easeInOut(duration: 0.4)) { // ✅ Adds fade & scale animation to deletion
            offsets.forEach { index in
                let taskToDelete = filteredTasks[index]
                if let coreDataTask = viewModel.tasks.first(where: { $0.id == taskToDelete.id }) {
                    viewModel.deleteTask(coreDataTask)
                }
            }
        }
    }
}

