//
//  ShimmerView.swift
//  TaskManager
//
//  Created by Macbook Pro on 11/03/2025.
//
import SwiftUI

import SwiftUI

struct ShimmerTaskRow: View {
    @State private var isAnimating = false

    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 200, height: 20)

            Spacer()

            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 20)
        }
        .padding()
        .opacity(isAnimating ? 0.6 : 1.0)
        .animation(
            Animation.easeInOut(duration: 1.2)
                .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}
