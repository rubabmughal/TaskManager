//
//  Task+Extensions.swift
//  TaskManager
//
//  Created by Macbook Pro on 12/03/2025.
//

import Foundation
import CoreData

extension Task: Identifiable {
    public var wrappedId: UUID {
        get { id ?? UUID() }  // ✅ Use existing UUID or generate a new one
        set { id = newValue }
    }
    
    public var wrappedTitle: String {
        title ?? "Untitled"
    }
    // ✅ Provides a default position if nil
        public var wrappedPosition: Int16 {
            get { position }
            set { position = newValue }
        }
}
