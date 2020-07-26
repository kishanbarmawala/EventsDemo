//
//  EventsModel.swift
//  EventsDemo
//
//  Created by Kishan Barmawala on 17/07/20.
//  Copyright © 2020 Kishan Barmawala. All rights reserved.
//

import Foundation

class EventsModel {
    var eventDate = String()
    var eventName = String()
    var eventDesc = String()
    
    init() {}
    
    init(_ date: String, name: String, desc: String) {
        eventDate = date
        eventName = name
        eventDesc = desc
    }
}
