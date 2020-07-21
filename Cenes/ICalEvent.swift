//
//  ICalEvent.swift
//  Cenes
//
//  Created by Cenes_Dev on 18/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI

class ICalEvent {
    
    var sourceEventId: String!;
    var title: String!;
    var description: String!;
    var location: String!;
    var timezone: String!;
    var startTime: Int64!;
    var endTime: Int64!;

    func populateICalEventFromDict(icalEventDict: EKEvent) -> ICalEvent {
        
        let icalEvent = ICalEvent();
        icalEvent.startTime = icalEventDict.startDate.millisecondsSince1970
        icalEvent.endTime = icalEventDict.endDate.millisecondsSince1970
        var title = "";
           if (icalEventDict.title != nil) {
               title = icalEventDict.title
           }
        icalEvent.title = title;
        var  location = "";
        if (icalEventDict.location != nil) {
            location = icalEventDict.location!;
        }
        icalEvent.location = location;

        var description = ""
        if let desc = icalEventDict.notes{
            description = desc
        }
        icalEvent.description = description;
        icalEvent.sourceEventId = "\(icalEventDict.eventIdentifier!)\(String(describing: startTime))"

        return icalEvent;
    }
}
