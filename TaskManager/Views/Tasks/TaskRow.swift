//
//  TaskRow.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//

import SwiftUI

struct TaskRow: View {
    @ObservedObject var task: Task // ObservedObject to hold the task

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title ?? "Untitled") // Display the task title
                    .font(.headline)
                Text(task.taskDescription ?? "") // Display the task description
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(task.priority ?? "Low") // Display the task priority
                .foregroundColor(task.priority == "High" ? .red : (task.priority == "Medium" ? .orange : .green))
        }
    }
}
