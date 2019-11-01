//
//  MetimeRecurringPatternModel+CoreDataManager.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/10/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class MetimeRecurringPatternModel {
    
    func populateRecurringManagedObjectFromDictionary(metimeRecurringPatternDict: NSDictionary) -> MeTimeRecurringPatternMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let metimeRecurringPatternMO = MeTimeRecurringPatternMO(context: context);
        metimeRecurringPatternMO.dayOfWeek = Int16(metimeRecurringPatternDict.value(forKey: "dayOfWeek") as! Int);
        metimeRecurringPatternMO.recurringPatternId = metimeRecurringPatternDict.value(forKey: "recurringPatternId") as! Int32;
        
        if let dayOfWeekTimestamp = metimeRecurringPatternDict.value(forKey: "dayOfWeekTimestamp") as? Int64 {
            metimeRecurringPatternMO.dayOfWeekTimestamp = dayOfWeekTimestamp;
        }
        if let slotsGeneratedUpto = metimeRecurringPatternDict.value(forKey: "slotsGeneratedUpto") as? Int64 {
           metimeRecurringPatternMO.slotsGeneratedUpto = slotsGeneratedUpto;
       }

        return metimeRecurringPatternMO;
    }

    /*func saveMetimePatternEventMOFromDictionary(metimeRecurringPatternDict: NSDictionary) -> MeTimeRecurringPatternMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let entity = NSEntityDescription.entity(forEntityName: "MeTimeRecurringPatternMO", in: context)
        let meTimeRecurringPatternMO = NSManagedObject(entity: entity!, insertInto: context) as! MeTimeRecurringPatternMO
        
        meTimeRecurringPatternMO.dayOfWeek = Int16(metimeRecurringPatternDict.value(forKey: "dayOfWeek") as! Int);
        meTimeRecurringPatternMO.recurringPatternId = metimeRecurringPatternDict.value(forKey: "recurringPatternId") as! Int32;

        meTimeRecurringPatternMO.dayOfWeekTimestamp = metimeRecurringPatternDict.value(forKey: "dayOfWeekTimestamp") as! Int64;

        meTimeRecurringPatternMO.slotsGeneratedUpto = metimeRecurringPatternDict.value(forKey: "slotsGeneratedUpto") as! Int64;

        do {
            try context.save();
            return meTimeRecurringPatternMO;
        } catch {
            print(error, " in saveMetimeRecurringEventMOFromDictionary")
        }
        
        return MeTimeRecurringPatternMO(context: context);
    }*/
    
    func findAllMetimeRecurringPatterns() -> [MeTimeRecurringPatternMO] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        var meTimeRecurringPatternMOList = [MeTimeRecurringPatternMO]();
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "MeTimeRecurringPatternMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription

        do {
            let metimeRecurringPatternMOs = try context.fetch(fetchRequest) as! [MeTimeRecurringPatternMO]
            for metimeRecurringPatternMO in metimeRecurringPatternMOs {
                meTimeRecurringPatternMOList.append(metimeRecurringPatternMO);
            }
            return meTimeRecurringPatternMOList;
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return meTimeRecurringPatternMOList;
    }
    
    func getDaysStr(recurringPatterns: NSSet) -> String {
        
        let recurringPatternsSorted = recurringPatterns;
        //recurringPatternsSorted.sort(by: sorterForFileIDASC);
        var patternStr: String = "";
        
        patternStr = getCountinousDaysStr(recurringPatterns: recurringPatternsSorted);
        
        if (patternStr == "" && recurringPatternsSorted.count > 0) {
            for pattern in recurringPatternsSorted {
                let patternMO = pattern as! MeTimeRecurringPatternMO;
                let dayOfweek = Calendar.current.component(.weekday, from: Date(milliseconds: Int(patternMO.dayOfWeekTimestamp)));
                patternStr = "\(patternStr)\(MeTimeManager().dayKeyAndNameMap(dayKey: Int(patternMO.dayOfWeek))),"
            }
            patternStr = String(patternStr.prefix(patternStr.count-1));
        }
        
        return patternStr;
    }
    
    func sorterForFileIDASC(this:MeTimeRecurringPatternMO, that:MeTimeRecurringPatternMO) -> Bool {
        return this.dayOfWeek < that.dayOfWeek
    }
    
    func getCountinousDaysStr(recurringPatterns: NSSet) -> String {
        var daysStr: String = "";
        
        let sevenDays = ["1234567": "SUN-SAT", "123456": "SUN-FRI", "234567": "MON-SAT", "12345" : "SUN-THUR", "23456": "MON-FRI", "34567" : "TUE-SAT"] ;
        
        var daysIntStr: String = "";
        for pattern in recurringPatterns {
            let patternMO = pattern as! MeTimeRecurringPatternMO;
            daysIntStr = "\(daysIntStr)\(String(patternMO.dayOfWeek))"
        }
        
        if (sevenDays.index(forKey: daysIntStr) != nil) {
            daysStr = sevenDays[daysIntStr]!;
        }
        return daysStr;
    }

    func convertMetimeRecurringPatternMOToDictionary(metimeRecurringEventMO: MetimeRecurringEventMO,
meTimeRecurringPatternMO: MeTimeRecurringPatternMO) -> [String: Any] {
        
        var meTimeRecurringPatternDO = [String: Any]();
        let startCalendar = Calendar.current;
        var dateComponents = DateComponents()
        dateComponents.year = startCalendar.component(.year, from: Date(milliseconds: Int(metimeRecurringEventMO.startTime)))
        dateComponents.weekOfYear = startCalendar.component(.weekOfYear, from: Date(milliseconds: Int(metimeRecurringEventMO.startTime)))
        dateComponents.weekday = Int(meTimeRecurringPatternMO.dayOfWeek);
        
        dateComponents.hour = startCalendar.component(.hour, from: Date(milliseconds: Int(metimeRecurringEventMO.startTime)))
        dateComponents.minute = startCalendar.component(.minute, from: Date(milliseconds: Int(metimeRecurringEventMO.startTime)))
        dateComponents.second = 0;
        dateComponents.nanosecond = 0;
        let selectedStartDate = startCalendar.date(from: dateComponents)!
        print(selectedStartDate.millisecondsSince1970);
        meTimeRecurringPatternDO["startTime"] = selectedStartDate.millisecondsSince1970;
        
        let endCalendar = Calendar.current;
        var endDateComponents = DateComponents()
        endDateComponents.year = endCalendar.component(.year, from: Date(milliseconds: Int(metimeRecurringEventMO.endTime)))
        endDateComponents.weekOfYear = endCalendar.component(.weekOfYear, from: Date(milliseconds: Int(metimeRecurringEventMO.endTime)))
        endDateComponents.weekday = Int(meTimeRecurringPatternMO.dayOfWeek);
        
        endDateComponents.hour = endCalendar.component(.hour, from: Date(milliseconds: Int(metimeRecurringEventMO.endTime)))
        endDateComponents.minute = endCalendar.component(.minute, from: Date(milliseconds: Int(metimeRecurringEventMO.endTime)))
        endDateComponents.second = 0;
        endDateComponents.nanosecond = 0;
        let selectedEndDate = endCalendar.date(from: endDateComponents)!
        
        meTimeRecurringPatternDO["endTime"] = selectedEndDate.millisecondsSince1970;
        meTimeRecurringPatternDO["dayOfWeek"] = meTimeRecurringPatternMO.dayOfWeek;
        meTimeRecurringPatternDO["title"] = metimeRecurringEventMO.title;

        return meTimeRecurringPatternDO;
    }
}
