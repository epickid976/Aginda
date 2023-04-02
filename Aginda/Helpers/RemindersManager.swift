
import SwiftUI
import EventKit
import Shift

class RemindersManager: ObservableObject {

    private var allRemainders: [EKReminder] = []
    
    
    public static let shared = RemindersManager()
    //var ekCalendarItem = MyEKCalendarItem.shared
    
    //var shift = Shift.shared
    
    //Init The Event Store
    let eventStore = EKEventStore()
    
    //Init Reminders List
    var remindersCalendar: EKCalendar? = nil
    
    
    //Array Of Reminders In List
    @Published var reminders: [EKReminder] = []
    
    var events = Shift.shared.events
    
    
    
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

    //Request Access To Reminders
    func requestRemindersAccess(onGranted: @escaping (Bool) -> Void) {
        
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            if let error = error {
                print("EKEventStore request access completed with error: \(error.localizedDescription)")
                onGranted(granted)
                return
            }
            onGranted(granted)
        }
        
    }

    func fetchReminders(date: Date, onReminders: @escaping ([EKReminder]) -> [EKReminder]) {
        var list: [EKReminder] = []
        let incompletePredicate = self.eventStore.predicateForIncompleteReminders(withDueDateStarting: nil, ending: Date().endOfDay(for: date), calendars: [])
        let completePredicate = self.eventStore.predicateForCompletedReminders(withCompletionDateStarting: Calendar.current.startOfDay(for: date), ending: Date().endOfDay(for: date), calendars: [])

        self.eventStore.fetchReminders(matching: incompletePredicate) { results in
                if let results = results {
                    print(results)
                    if(list.size > 0){
                        list.append(contentsOf: results)
                        onReminders(list)
                        return
                    }
                    list.append(contentsOf: results)
                }
        }
            
        self.eventStore.fetchReminders(matching: completePredicate) { results in
                if let results = results {
                    print(results)
                     if(list.size > 0){
                        list.append(contentsOf: results)
                        onReminders(list)
                        return
                    }
                    list.append(contentsOf: results)
                }
        }
    }
    
    
    
    //Fetch Reminders Into Array
    func fetchReminders(date: Date) async throws {
        
        requestRemindersAccess(onGranted: { (success) in
            //let predicate = self.eventStore.predicateForReminders(in: nil)
            let incompletePredicate = self.eventStore.predicateForIncompleteReminders(withDueDateStarting: nil, ending: Date().endOfDay(for: date), calendars: [])
            let completePredicate = self.eventStore.predicateForCompletedReminders(withCompletionDateStarting: Calendar.current.startOfDay(for: date), ending: Date().endOfDay(for: date), calendars: [])
            
            //            self.eventStore.fetchReminders(matching: predicate) { results in
            //                if let results = results {
            //                    print(self.eventStore.description)
            //                    print(results)
            //                    DispatchQueue.main.async {
            //                        self.reminders = results
            //                    }
            //
            //                }
            //            }
            
            self.eventStore.fetchReminders(matching: incompletePredicate) { results in
                if let results = results {
                    print(results)
                    DispatchQueue.main.async {
                        self.reminders.append(contentsOf: results)
                        
                    }
                }
            }
            
            self.eventStore.fetchReminders(matching: completePredicate) { results in
                if let results = results {
                    print(results)
                    DispatchQueue.main.async {
                        self.reminders.append(contentsOf: results)
                    }
                }
            }
        }
        )
        
        
        
        // guard let remindersCalendar = eventStore.defaultCalendarForNewReminders() else { return }
        
        
    }
    
    //Create Reminder
    func createReminder(title: String, priority: Int, notes: String, date: DateComponents) {
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        reminder.notes = notes
        reminder.priority = priority
        reminder.dueDateComponents = date
        //reminder.calendar = remindersCalendar
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        
        //Create A Completed Task
        //reminder.isCompleted = false
        
        //Set A Task Deadline
        //reminder.dueDateComponents = DateComponents()
        
        do {
            try eventStore.save(reminder, commit: true)
        } catch {
            print("Saving Reminder Failed With Error: \(error.localizedDescription)")
        }
    }
    
    //delete reminder
    
    func deleteReminder(reminder: EKReminder) {
        do {
            try eventStore.remove(reminder, commit: true)
        } catch {
            print("Error removing the event from the database. Please try again.")
        }
    }
    
    func fetchRemindersForDate() {
        do {
            
        }
    }
}

extension Date {
    func endOfDay(for date: Date) -> Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        var startOfDay = Calendar.current.startOfDay(for: date)
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}
