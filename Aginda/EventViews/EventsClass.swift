//
//  EventClass.swift
//  Aginda
//
//  Created by Jose Blanco on 3/29/23.
//

import Foundation

enum EventType {
    case event
    case reminder
    case habit
}

public class EventsClass: ObservableObject {
    
    public static let shared = EventsClass()
    
    var allEvents: [MyEvent] = []
    
    
    
}
