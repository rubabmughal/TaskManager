//
//  ProgressRing.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//

import SwiftUI


struct TaskProgressView: View {
    @AppStorage("accentColor") private var accentColor: String = "Blue"
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(key: "position", ascending: true)]
    ) private var tasks: FetchedResults<Task>  // ✅ Auto-updates UI when tasks change

    /// ✅ Computes the completion rate dynamically
    private var completionRate: Double {
        let completedTasks = tasks.filter { $0.isCompleted }.count
        let totalTasks = tasks.count
        return totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0.0
    }

    var body: some View {
        VStack {
            Text("Task Progress")
                .font(.headline)

            ZStack {
                // ✅ Background Circle
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                // ✅ Animated Progress Circle
                Circle()
                    .trim(from: 0.0, to: completionRate)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
//                    .foregroundColor(.blue)
                    .foregroundColor(colorMap[accentColor] ?? .blue)
                    .rotationEffect(Angle(degrees: -90))  // Starts from the top
                    .animation(.easeInOut(duration: 0.6), value: completionRate)  // ✅ Smooth animation

                // ✅ Display completion percentage
                Text("\(Int(completionRate * 100))%")
                    .font(.headline)
                    .bold()
            }
            .frame(width: 100, height: 100)
        }
        .padding()
    }
}

//struct TaskProgressView: View {
//    let tasks: [Task]  // ✅ Receives the list of tasks directly
//
//    /// ✅ Computes the completion rate dynamically
//    private var completionRate: Double {
//        let completedTasks = tasks.filter { $0.isCompleted }.count
//        let totalTasks = tasks.count
//        return totalTasks == 0 ? 0.0 : Double(completedTasks) / Double(totalTasks)
//    }
//
//    var body: some View {
//        VStack {
//            Text("Task Progress")
//                .font(.headline)
//
//            ZStack {
//                // ✅ Background Circle
//                Circle()
//                    .stroke(lineWidth: 10)
//                    .opacity(0.3)
//                    .foregroundColor(.gray)
//
//                // ✅ Animated Progress Circle
//                Circle()
//                    .trim(from: 0.0, to: completionRate)  // ✅ Updates as tasks change
//                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
//                    .foregroundColor(.blue)
//                    .rotationEffect(Angle(degrees: -90))  // Starts from the top
//                    .animation(.easeInOut(duration: 0.6), value: completionRate)  // ✅ Smooth animation
//
//                // ✅ Display completion percentage
//                Text("\(Int(completionRate * 100))%")
//                    .font(.headline)
//                    .bold()
//            }
//            .frame(width: 100, height: 100)  // ✅ Fixed size for visibility
//        }
//        .padding()
//    }
//}
