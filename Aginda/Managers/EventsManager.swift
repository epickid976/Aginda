//
//  HabitsManager.swift
//  Aginda
//
//  Created by Elier Viera on 04/01/23.
//

import Foundation

class EventsManager {

    @StateObject var eventKitWrapper = Shift.shared
    @StateObject var remindersWrapper = RemindersManager.shared

    
    func loadAllEventsAndReminders(date: Date, onEvents: @escaping ([MyEvent]) -> Void) {
        var allEvents = [MyEvent]()
        var isReminders = false
        var isEvents = false

        remindersWrapper.fetchReminders(date: date, onReminders: { reminders in
           var eventsReminders = remindersToEvents(remindersList: reminders)
           allEvents.append(contentsOf: eventsReminders)
           isReminders = true
           if isEvents {
                onEvents(allEvents)
           } 
        })

        Task {
                try! await eventKitWrapper.fetchEvents(startDate: Calendar.current.startOfDay(for: selectedDate), endDate: Date().endOfDay(for: selectedDate))
                var eventsEKEvents = eventsToEvents(eventsList: Shift.shared.events)
                allEvents.append(contentsOf: eventsEKEvents)
                isEvents = true
                 DispatchQueue.main.async {
                         if isReminders {
                onEvents(allEvents)
           } 
                    }
               
        }
    
    }
    
    


    func remindersToEvents(remindersList: [EKReminder]) -> [MyEvent] {
        var events = [MyEvent]()
        
        remindersList.forEach { reminder in
            events.append(MyEvent(event: reminder as EKObject, date: reminder.dueDateComponents?.date, type: .reminder))
        }
        
        return events
    }
    
    func eventsToEvents(eventsList: [EKEvent]) -> [MyEvent] {
        var events = [MyEvent]()
        
        eventsList.forEach { event in
            events.append(MyEvent(event: event as EKObject, date: event.startDate, type: .event))
        }
        
        return events
    }
    
}
