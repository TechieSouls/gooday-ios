//
//  SqlliteDbManager+MeTimeRecurringEvent.swift
//  Cenes
//
//  Created by Cenes_Dev on 26/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {
    
    func createTableMeTimeRecurringEvents() {
        
        do {
            let cenesUsers = Table("metime_recurring_events")
            let recurringEventId = Expression<Int64>("recurring_event_id")
            let title = Expression<String?>("title")
            let createdById = Expression<Int64>("created_by_id")
            let startTime = Expression<Int64>("start_time")
            let endTime = Expression<Int64>("end_time")
            let timezone = Expression<String>("timezone")
            let status = Expression<String>("status")
            let source = Expression<String>("source")
            let processed = Expression<Int>("processed")
            let photo = Expression<String>("photo")

            try database.run(cenesUsers.create { t in
                t.column(recurringEventId, defaultValue: 0)
                t.column(title, defaultValue: "")
                t.column(createdById, defaultValue: 0)
                t.column(startTime, defaultValue: 0)
                t.column(endTime, defaultValue: 0)
                t.column(timezone, defaultValue: "")
                t.column(status, defaultValue: "")
                t.column(source, defaultValue: "")
                t.column(processed, defaultValue: 0)
                t.column(photo, defaultValue: "")
            })
        } catch {
            print("Error in createTableMeTimeRecurringEvents : ", error)
        }
    }
    
    func saveMeTimeRecurringEvent(metimeRecurringEvent: MetimeRecurringEvent) {
        do {
            let stmt = try database.prepare("INSERT into metime_recurring_events (recurring_event_id, title, created_by_id, start_time, end_time, timezone, status, source, processed, photo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            
            var startTime: Int64 = 0;
            if (metimeRecurringEvent.startTime != nil) {
               startTime = metimeRecurringEvent.startTime;
            }
            
            var endTime: Int64 = 0;
            if (metimeRecurringEvent.endTime != nil) {
               endTime = metimeRecurringEvent.endTime;
            }
            
            var timezone = "";
            if (metimeRecurringEvent.timezone != nil) {
               timezone = metimeRecurringEvent.timezone;
            }
            
            var status = "";
            if (metimeRecurringEvent.status != nil) {
               status = metimeRecurringEvent.status;
            }
            
            var source = "";
            if (metimeRecurringEvent.source != nil) {
               source = metimeRecurringEvent.source;
            }
            var photo = "";
            if (metimeRecurringEvent.photo != nil) {
               photo = metimeRecurringEvent.photo;
            }
            try stmt.run(Int64(metimeRecurringEvent.recurringEventId), metimeRecurringEvent.title, Int64(metimeRecurringEvent.createdById), startTime, endTime, timezone, status, source, metimeRecurringEvent.processed, photo);
            
            //Saving MetimeRecurring Patterns
            if (metimeRecurringEvent.patterns != nil && metimeRecurringEvent.patterns.count > 0) {
                for metimeRecurringPattern in metimeRecurringEvent.patterns {
                    saveMeTimeRecurringPattern(metimeRecurringPattern: metimeRecurringPattern);
                }
            }
        } catch {
            print("Error in saveMeTimeRecurringEvent : ", error)
        }
    }
    
    func findAllMeTimeRecurringEvent() -> [MetimeRecurringEvent] {
        
        var metimeRecurringEvents = [MetimeRecurringEvent]();
        do {
            
            for metimeRecurringEventDb in try database.prepare("SELECT * from metime_recurring_events") {
                let metimeRecurringEvent = MetimeRecurringEvent();
                metimeRecurringEvent.recurringEventId = Int32(metimeRecurringEventDb[0] as! Int64);
                metimeRecurringEvent.title = metimeRecurringEventDb[1] as? String;
                metimeRecurringEvent.createdById = Int32(metimeRecurringEventDb[2] as! Int64)
                metimeRecurringEvent.startTime = (metimeRecurringEventDb[3] as! Int64)
                metimeRecurringEvent.endTime = (metimeRecurringEventDb[4] as! Int64)
                metimeRecurringEvent.timezone = metimeRecurringEventDb[5] as? String
                metimeRecurringEvent.status = metimeRecurringEventDb[6] as? String
                metimeRecurringEvent.source = metimeRecurringEventDb[7] as? String
                metimeRecurringEvent.processed = Int(metimeRecurringEventDb[8] as! Int64)
                metimeRecurringEvent.photo = metimeRecurringEventDb[9] as? String;
                
                //Lets fetch MeTime Patterns from Recirring Event Id
                let metimeRecurringPatterns = findMeTimeRecurringPatternIdByRecurringEventId(recurringEventId: metimeRecurringEvent.recurringEventId);
                metimeRecurringEvent.patterns = metimeRecurringPatterns;
                
                metimeRecurringEvents.append(metimeRecurringEvent);
            }
        } catch {
            print("Error in findAllMeTimeRecurringEvent : ", error)
        }
        return metimeRecurringEvents;
    }
    
    func deleteMetimeRecurringEventByRecurringEventId(recurringEventId: Int32) {
        do {
            let stmt = try database.prepare("DELETE from metime_recurring_events where recurring_event_id = ?");
            try stmt.run(Int64(recurringEventId));
            //Delete Pattenrs By RecurringEvent Id
            deleteMeTimeRecurringPatternByRecurringEventId(recurringEventId: recurringEventId);
        } catch {
            print("Error in deleteMetimeRecurringEventByRecurringEventId", error)
        }
    }
    
    func deleteAllRecurringEvent() {
        do {
            let stmt = try database.prepare("DELETE from metime_recurring_events");
            try stmt.run();
            
            //Lets delete all Patterns also
            deleteAllMeTimeRecurringPatterns();
        } catch {
            print("Error in deleteAllRecurringEvent", error)
        }
    }
    
    func updateMetimeRecurringPhoto(photoUrl: String, metimeRecurringEvent: MetimeRecurringEvent) {
        do {
            let stmt = try database.prepare("UPDATE metime_recurring_events set photo = ? where recurring_event_id = ?");
            try stmt.run(metimeRecurringEvent.photo, Int64(metimeRecurringEvent.recurringEventId));
        } catch {
            print("Error in updateMetimeRecurringPhoto : ", error);
        }
    }
}
