//
//  SqlliteDbManager+ICalEvent.swift
//  Cenes
//
//  Created by Cenes_Dev on 18/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {
    
    func createTableICalEvent() {
        do {
            let icalEvents = Table("ical_events")
            let sourceEventId = Expression<String>("source_event_id")
            let title = Expression<String?>("title")
            let description = Expression<String?>("description")
            let location = Expression<String>("location")
            let timezone = Expression<String>("timezone")
            let startTime = Expression<Int64>("start_time")
            let endTime = Expression<Int64>("end_time")

            try database.run(icalEvents.create { t in
                t.column(sourceEventId, defaultValue: "")
                t.column(title)
                t.column(location, defaultValue: "")
                t.column(description, defaultValue: "")
                t.column(timezone, defaultValue: TimeZone.current.identifier)
                t.column(startTime, defaultValue: 0)
                t.column(endTime, defaultValue: 0)
            })
        } catch {
            print("Create ICalEvent Table Error", error)
        }
    }
    
    func findICalEventBySourceEventId(sourceEventId: String) -> ICalEvent {
        
        let icalEvent = ICalEvent();

        do {
            let stmt = try database.prepare("SELECT * from ical_events where source_event_id = ?");
            for iCalEventDB in try stmt.run(sourceEventId) {
                    
                icalEvent.sourceEventId = (iCalEventDB[0] as! String);
                icalEvent.title = iCalEventDB[1] as? String;
                icalEvent.description = iCalEventDB[2] as? String;
                icalEvent.location = iCalEventDB[3] as? String;
                icalEvent.timezone = iCalEventDB[4] as? String;
                icalEvent.startTime = iCalEventDB[5] as? Int64;
                icalEvent.endTime = iCalEventDB[6] as? Int64;
                
            }
        } catch {
            print("Error in saveCenesUser : ", error)
        }
        return icalEvent;
    }
    
    func saveICalEvent(icalEvent: ICalEvent) {
        
        let icalEventDB = findICalEventBySourceEventId(sourceEventId: icalEvent.sourceEventId);
        if (icalEventDB.sourceEventId == nil) {
            do {
                let stmt = try database.prepare("INSERT into ical_events (source_event_id, title, description, location, timezone, start_time, end_time) VALUES (?, ?, ?, ?, ?, ?, ?)");
                
                var title = "";
                if (icalEventDB.title != nil) {
                    title = icalEventDB.title;
                }
                var description = "";
                if (icalEventDB.description != nil) {
                    description = icalEventDB.description;
                }
                var location = "";
                if (icalEventDB.location != nil) {
                    location = icalEventDB.location;
                }
                var timezone = "";
                if (icalEventDB.timezone != nil) {
                    timezone = icalEventDB.timezone;
                }
                try stmt.run(icalEventDB.sourceEventId, title, description, location, timezone, icalEventDB.startTime, icalEventDB.endTime);
                
            } catch {
                print("Error in saveICalEvent : ", error)
            }
        } else {
            updateICalEventBySourceEventId(icalEvent: icalEventDB);
        }
    }
    
    func updateICalEventBySourceEventId(icalEvent: ICalEvent) {
        
        do {
            let stmt = try database.prepare("UPDATE ical_events set title = ?, description = ?, location = ?,timezone = ? where source_event_id =  ?");
            var title = "";
            if (icalEvent.title != nil) {
                title = icalEvent.title;
            }
            var description = "";
            if (icalEvent.description != nil) {
                description = icalEvent.description;
            }
            var location = "";
            if (icalEvent.location != nil) {
                location = icalEvent.location;
            }
            var timezone = "";
            if (icalEvent.timezone != nil) {
                timezone = icalEvent.timezone;
            }
            try stmt.run(title, description, location, timezone, icalEvent.sourceEventId);
            
        } catch {
            print("Error in updateICalEventBySourceEventId : ", error);
        }
    }
    
    func deleteICalEventBySourceEventId(sourceEventId: String) {
        do {
            let stmt = try database.prepare("DELETE from ical_events where source_event_id = ?");
            try stmt.run(sourceEventId);
        } catch {
            print("Error in deleteICalEventByEventId : ", error)
        }
    }

    func deleteAllICalEvents() {
        do {
            let stmt = try database.prepare("DELETE from ical_events");
            try stmt.run();
        } catch {
            print("Error in deleteAllICalEvents : ", error)
        }
    }
}
