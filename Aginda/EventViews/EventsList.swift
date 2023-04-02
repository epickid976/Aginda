//
//  EventsList.swift
//  Aginda
//
//  Created by Jose Blanco on 3/28/23.
//

import Foundation
import SwiftUI
import Shift
import EventKit
import ElegantCalendar

struct EventsList: View {
    
    var selectedDate: Date
    
    @StateObject var eventKitWrapper = Shift.shared
    @State private var selectedEvent: EKEvent?
    @StateObject var remindersWrapper = RemindersManager.shared
    @State private var selectedReminder: EKReminder?
    @StateObject var eventsManager = EventsManager()
    
    
    
    var body: some View {
        list
        .animation(.easeInOut)
        
    }
    
    private var list: some View {
        VStack {
            ForEach(EventsClass.shared.allEvents, id: \.self) { event in
                
                    switch event.type {
                    case .reminder:
                        HStack {
                            Image(systemName: "bell.circle")
                            Text((event.event as! EKReminder).title)
                        }
                        
                    case .event:
                        HStack {
                            Image(systemName: "calendar")
                            Text((event.event as! EKEvent).title)
                        }
                    case .habit:
                        HStack {
                            Image(systemName: "calendar")
                            Text((event.event as! EKEvent).title)
                        }
                    }
                
            }
            
//            ForEach(remindersWrapper.completedReminders, id: \.self) { reminder in
//                HStack {
//                    Image(systemName: "bell.circle")
//                    Text(reminder.title)
//                }
//            }
        }
        .onAppear() {
            /*Task {
                try! await eventKitWrapper.fetchEvents(startDate: Calendar.current.startOfDay(for: selectedDate), endDate: Date().endOfDay(for: selectedDate))
                    print(Shift.shared.events)
                try! await remindersWrapper.fetchReminders(date: selectedDate)
            }*/
            eventsManager.loadAllEventsAndReminders(date: Date(), onEvents: { events in
                EventsClass.shared.allEvents = events
            })
        }
    }
        
}

struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsList(selectedDate: Date())
    }
}
