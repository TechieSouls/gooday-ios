//
//  MetimeRecurringEvent.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class MetimeRecurringEvent {
    
    var recurringEventId: Int32!;
    var title: String!;
    var createdById: Int32!;
    var startTime: Int64!;
    var endTime: Int64!;
    var timezone: String!;
    var status: String!;
    var source: String!;
    var processed: Int!;
    var photo: String!;
    var patterns: [MeTimeRecurringPattern]!;
    
    func loadMetimeRecurringEvents(meTimeArray: NSArray) -> [MetimeRecurringEvent] {
        var recurringEvents = [MetimeRecurringEvent]();
        for recurringEvent in meTimeArray {
            let recurringEventDict = recurringEvent as! NSDictionary;
            recurringEvents.append(loadMetimeRecurringEvent(meTimeDict: recurringEventDict));
        }
        return recurringEvents;
    }
    
    func loadMetimeRecurringEvent(meTimeDict: NSDictionary) -> MetimeRecurringEvent {
        let metimeRecurringEvent = MetimeRecurringEvent();
        
        metimeRecurringEvent.recurringEventId = meTimeDict["recurringEventId"] as? Int32
        metimeRecurringEvent.title = meTimeDict["title"] as? String;
        metimeRecurringEvent.startTime = meTimeDict["startTime"] as? Int64;
        metimeRecurringEvent.endTime = meTimeDict["endTime"] as? Int64;
        metimeRecurringEvent.createdById = meTimeDict["createdById"] as? Int32;
        metimeRecurringEvent.timezone = meTimeDict["timezone"] as? String;
        metimeRecurringEvent.status = meTimeDict["status"] as? String;
        metimeRecurringEvent.source = meTimeDict["source"] as? String;
        metimeRecurringEvent.processed = meTimeDict["processed"] as? Int;
        metimeRecurringEvent.photo = meTimeDict["photo"] as? String;
        
        metimeRecurringEvent.patterns = MeTimeRecurringPattern().loadRecurringPatterns(patterns: meTimeDict["recurringPatterns"] as! NSArray)
        
        return metimeRecurringEvent;
    }
    
    func toString() -> Void {
        print("[Title : \(self.title), Start Time : \(self.startTime), End Time : \(self.endTime), Photo : \(photo), Patterns : \(MeTimeRecurringPattern().toStringList(patterns: self.patterns))]");
    }
    
    func toDictionary() -> [String: Any] {
        
        var recurringEventJson: [String: Any] = [:];
        recurringEventJson["userId"] = self.createdById;
        recurringEventJson["recurringEventId"] = self.recurringEventId;
        recurringEventJson["timezone"] = TimeZone.current.identifier;
        
        var events: [[String: Any]]! = [];
        for metimeEvent in self.patterns {
            var meTimeEventTemp: [String: Any] = [:];
            
            let startCalendar = Calendar.current;
            var dateComponents = DateComponents()
            dateComponents.year = startCalendar.component(.year, from: Date(milliseconds: Int(self.startTime)))
            dateComponents.weekOfYear = startCalendar.component(.weekOfYear, from: Date(milliseconds: Int(self.startTime)))
            dateComponents.weekday = metimeEvent.dayOfWeek
            
            dateComponents.hour = startCalendar.component(.hour, from: Date(milliseconds: Int(self.startTime)))
            dateComponents.minute = startCalendar.component(.minute, from: Date(milliseconds: Int(self.startTime)))
            dateComponents.second = 0;
            dateComponents.nanosecond = 0;
            let selectedStartDate = startCalendar.date(from: dateComponents)!
            print(selectedStartDate.millisecondsSince1970);
            meTimeEventTemp["startTime"] = selectedStartDate.millisecondsSince1970;
            
            let endCalendar = Calendar.current;
            var endDateComponents = DateComponents()
            endDateComponents.year = endCalendar.component(.year, from: Date(milliseconds: Int(self.endTime)))
            endDateComponents.weekOfYear = endCalendar.component(.weekOfYear, from: Date(milliseconds: Int(self.endTime)))
            endDateComponents.weekday = metimeEvent.dayOfWeek
            
            endDateComponents.hour = endCalendar.component(.hour, from: Date(milliseconds: Int(self.endTime)))
            endDateComponents.minute = endCalendar.component(.minute, from: Date(milliseconds: Int(self.endTime)))
            endDateComponents.second = 0;
            endDateComponents.nanosecond = 0;
            let selectedEndDate = endCalendar.date(from: endDateComponents)!
            
            meTimeEventTemp["endTime"] = selectedEndDate.millisecondsSince1970;
            meTimeEventTemp["dayOfWeek"] = metimeEvent.dayOfWeek;
            meTimeEventTemp["title"] = self.title;
            events.append(meTimeEventTemp);
        }
        recurringEventJson["events"] = events;
        return recurringEventJson;
        
    }
}


class MeTimeRecurringPattern {
    
    var recurringPatternId: Int32!;
    var dayOfWeek: Int!;
    var recurringEventId: Int32!;
    var dayOfWeekTimestamp: Int64!;
    var slotsGeneratedUpto: Int64!;
    
    
    func loadRecurringPatterns(patterns: NSArray) -> [MeTimeRecurringPattern] {
        
        var recurringPatterns = [MeTimeRecurringPattern]();
        
        for pattern in patterns {
            let patternDict = pattern as! NSDictionary;
            
            let metimeRecurringPattern = MeTimeRecurringPattern();
            metimeRecurringPattern.recurringEventId = patternDict["recurringEventId"] as? Int32;
            metimeRecurringPattern.dayOfWeek = patternDict["dayOfWeek"] as? Int;
            metimeRecurringPattern.dayOfWeekTimestamp = patternDict["dayOfWeekTimestamp"] as? Int64;
            metimeRecurringPattern.recurringPatternId = patternDict["recurringPatternId"] as? Int32;
            
            recurringPatterns.append(metimeRecurringPattern);
        }
        return recurringPatterns;
    }
    
    func toStringList(patterns: [MeTimeRecurringPattern]) -> String {
         var dayOfWeekStr = "";
        for pattern in patterns {
            dayOfWeekStr = dayOfWeekStr + "Day Of Week : \(pattern.dayOfWeek)";
        }
        return dayOfWeekStr;
    }
}
