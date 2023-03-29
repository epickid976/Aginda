//
//  EKCalendarItem.swift
//  Aginda
//
//  Created by Jose Blanco on 3/29/23.
//

import Foundation
import EventKit


struct MyEvent: Hashable {
    
    var event: EKObject
    var date: Date?
    var type: EventType
    
    
    
//    //Calendar
//    var eventIdentifier: String!
//    var startDate: Date!
//    var endDate: Date!
//    var isAllDay: Bool
//    var occurrenceDate: Date!
//    var isDetached: Bool
//    var organizer: EKParticipant?
//    var status: EKEventStatus
//    var birthdayContactIdentifier: String?
//    var structuredLocation: EKStructuredLocation?
//
//    //Reminders
//    //enum EKReminderPriority
//
//    var priority: Int
//    var startDateComponents: DateComponents?
//    var dueDateComponents: DateComponents?
//    var isCompleted: Bool
//    var completionDate: Date?
//
//    //Habits
//    var title: String
//    var description: String
//    var dateCreated: Date = Date()
//    var selectedEmoji: String
//    var currentStreak: Int = 0
//    var bestStreak: Int = 0
//    var lastCompletionDate: Date?
//    var numberOfCompletions: Int = 0
}
