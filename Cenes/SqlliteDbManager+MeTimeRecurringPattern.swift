//
//  SqlliteDbManager+MeTimeRecurringPattern.swift
//  Cenes
//
//  Created by Cenes_Dev on 26/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {
    
    func createTableMeTimeRecurringPatterns() {
        do {
            let cenesUsers = Table("metime_recurring_patterns")
            let recurringPatternId = Expression<Int64>("recurring_pattern_id")
            let dayOfWeek = Expression<Int>("day_of_week")
            let recurringEventId = Expression<Int64>("recurring_event_id")
            let dayOfWeekTimestamp = Expression<Int64>("day_off_week_timestamp")
            let slotsGeneratedUpto = Expression<Int64>("slots_generated_upto")

            try database.run(cenesUsers.create { t in
                t.column(recurringPatternId, defaultValue: 0)
                t.column(dayOfWeek, defaultValue: 0)
                t.column(recurringEventId, defaultValue: 0)
                t.column(dayOfWeekTimestamp, defaultValue: 0)
                t.column(slotsGeneratedUpto, defaultValue: 0)
            })
        } catch {
            print("Error in createTableMeTimeRecurringPatterns : ", error)
        }
    }
    
    func saveMeTimeRecurringPattern(metimeRecurringPattern: MeTimeRecurringPattern) {
     
        do {
            let stmt = try database.prepare("INSERT into metime_recurring_patterns (recurring_pattern_id, day_of_week, recurring_event_id, day_off_week_timestamp, slots_generated_upto) VALUES (?, ?, ?, ?, ?)");
            
            var dayOfWeekTimestamp: Int64 = 0;
            if (metimeRecurringPattern.dayOfWeekTimestamp != nil) {
                dayOfWeekTimestamp = metimeRecurringPattern.dayOfWeekTimestamp;
            }
            var slotsGeneratedUp: Int64 = 0;
            if (metimeRecurringPattern.slotsGeneratedUpto != nil) {
                slotsGeneratedUp = metimeRecurringPattern.slotsGeneratedUpto;
            }
            try stmt.run(Int64(metimeRecurringPattern.recurringPatternId), metimeRecurringPattern.dayOfWeek, Int64(metimeRecurringPattern.recurringEventId), dayOfWeekTimestamp, slotsGeneratedUp);
            
        } catch {
            print("Error in saveMeTimeRecurringPattern : ", error);
        }
    }
    
    func findMeTimeRecurringPatternIdByRecurringEventId(recurringEventId: Int32) -> [MeTimeRecurringPattern] {
        
        var recurringEventPatterns = [MeTimeRecurringPattern]();
        do {
            let stmt = try database.prepare("SELECT * from metime_recurring_patterns where recurring_event_id = ?");
            for metimeRecurringPatternDb in try stmt.run(Int64(recurringEventId)) {
                
                let metimeRecurringPattern = MeTimeRecurringPattern();
                metimeRecurringPattern.recurringPatternId = Int32(metimeRecurringPatternDb[0] as! Int64);
                metimeRecurringPattern.dayOfWeek = Int(metimeRecurringPatternDb[1] as! Int64);
                metimeRecurringPattern.recurringEventId = Int32(metimeRecurringPatternDb[2] as! Int64);
                metimeRecurringPattern.dayOfWeekTimestamp = (metimeRecurringPatternDb[3] as! Int64);
                metimeRecurringPattern.slotsGeneratedUpto = (metimeRecurringPatternDb[4] as! Int64);
                
                recurringEventPatterns.append(metimeRecurringPattern);
            }
        } catch {
            print("Error in findMeTimeRecurringPatternIdByRecurringEventId : ", error)
        }
        return recurringEventPatterns;
    }
    
    func deleteMeTimeRecurringPatternByRecurringEventId(recurringEventId: Int32) {
        do {
            let stmt = try database.prepare("DELETE from metime_recurring_patterns where recurring_event_id = ?");
            try stmt.run(Int64(recurringEventId));
        } catch {
            print("Error in deleteMeTimeRecurringPatternByRecurringEventId : ", error);
        }
    }
    
    func deleteAllMeTimeRecurringPatterns() {
        do {
            let stmt = try database.prepare("DELETE from metime_recurring_patterns");
            try stmt.run();
        } catch {
            print("Error in deleteMeTimeRecurringPatternByRecurringEventId : ", error);
        }
    }
}
