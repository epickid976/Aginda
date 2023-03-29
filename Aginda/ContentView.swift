//
//  ContentView.swift
//  Aginda
//
//  Created by Jose Blanco on 3/10/23.
//

import SwiftUI
import EventKit
import Shift
import ElegantCalendar
import ElegantPages

let startDate = Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (-30 * 36)))
let endDate = Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * (30 * 36)))

struct CalendarView: View {

    init() {
        calendarManager.datasource = self
        selectedDate = calendarManager.selectedDate ?? Date()
    }
    
    @State public var selectedDate = Self.now
    
   

    @ObservedObject var calendarManager = ElegantCalendarManager(
           configuration: CalendarConfiguration(startDate: startDate,
                                                endDate: endDate), initialMonth: Date())
    
    

       
           
    
    
    private static var now = Date()
    
    @StateObject var eventKitWrapper = Shift.shared
    @State private var selectedEvent: EKEvent?
    @StateObject var remindersWrapper = RemindersManager.shared
    @State private var selectedReminder: EKReminder?
    
    @Environment(\.colorScheme) var colorScheme


    var body: some View {
        
        ElegantCalendarView(calendarManager: calendarManager)
            .vertical()
            .onAppear() {
                Task {
                    try! await eventKitWrapper.fetchEvents(startDate: Calendar.current.startOfDay(for: selectedDate), endDate: Date().endOfDay(for: selectedDate))
                        print(Shift.shared.events)
                    try! await remindersWrapper.fetchReminders(date: selectedDate)
                }
            }
        


    }
        
    
}


// MARK: - Component

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
      CalendarView()
    }
}

extension CalendarView: ElegantCalendarDataSource, MonthlyCalendarDataSource, YearlyCalendarDataSource {
    
    //func calendar(backgroundColorOpacityForDate date: Date) -> Double {
    //    let start0fDay = Calendar.current.startOfDay(for: date)
    //return Double ((visitsByDay[startOfDay]?.count ?? 0) + 3) / 15.0
    //}
    
    //func calendar (canSelectDate date: Date) -> Bool {
    //let day = currentCalendar. dateComponents ([. day], from: date).day!
    //return day != 4
    //}
    
     func calendar (viewForSelectedDate date: Date, dimensions size: CGSize) -> AnyView {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return EventsList(selectedDate: calendarManager.selectedDate ?? Date()).erased
        
    }
}

extension CalendarView: ElegantCalendarDelegate {

    func calendar(didSelectDay date: Date) {
        print("Selected date: \(date)")
        
    }

    func calendar(willDisplayMonth date: Date) {
        print("Month displayed: \(date)")
    }

    func calendar(didSelectMonth date: Date) {
        print("Selected month: \(date)")
    }

    func calendar(willDisplayYear date: Date) {
        print("Year displayed: \(date)")
    }

}

public extension View {

    var erased: AnyView {
        AnyView(self)
    }

}
