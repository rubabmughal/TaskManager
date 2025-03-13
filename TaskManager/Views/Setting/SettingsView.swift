//
//  SettingsView.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//


import SwiftUI

// ✅ Allows users to customize accent color and supports dark/light mode
struct SettingsView: View {
    @AppStorage("accentColor") private var accentColor: String = "Blue"
    
    let availableColors: [String: Color] = [
        "Blue": .blue,
        "Red": .red,
        "Green": .green,
        "Purple": .purple,
        "Orange": .orange
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Theme Settings")) {
                Picker("Accent Color", selection: $accentColor) {
                    ForEach(availableColors.keys.sorted(), id: \.self) { colorName in
                        HStack {
                            Circle()
                                .fill(availableColors[colorName]!)
                                .frame(width: 20, height: 20)
                            Text(colorName)
                        }
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        .navigationTitle("Settings")
    }
}

