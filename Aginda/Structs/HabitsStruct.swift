//
//  HabitsStruct.swift
//  Aginda
//
//  Created by Jose Blanco on 3/27/23.
//

import Foundation
import SwiftUI

struct Habits: Codable {
    
    var title: String
    var description: String
    var dateCreated: Date = Date()
    var selectedEmoji: String
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    var lastCompletionDate: Date?
    var numberOfCompletions: Int = 0
    
    var completedToday: Bool {
        return lastCompletionDate?.isToday ?? false
    }
    
    init(title: String, description: String, selectedEmoji: String) {
        self.title = title
        self.description = description
        self.selectedEmoji = selectedEmoji
    }
    
}

extension Date {
    var stringValue: String {
        return DateFormatter.localizedString(from: self, dateStyle: .medium, timeStyle: .none)
    }
    
    var isToday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(self)
    }
    
    var isYesterday: Bool {
        let calendar = Calendar.current
        return calendar.isDateInYesterday(self)
    }
}
