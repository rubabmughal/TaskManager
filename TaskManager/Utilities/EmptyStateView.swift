//
//  EmptyStateView.swift
//  TaskManager
//
//  Created by Macbook Pro on 12/03/2025.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "checklist")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .opacity(0.5)

            Text("No tasks yet!")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.top, 10)

            Text("Start by adding a new task to stay organized!")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding()
    }
}

