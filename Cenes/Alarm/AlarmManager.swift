//
//  AlarmManager.swift
//  Cenes
//
//  Created by Chinna Addepally on 11/19/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension AddAlarmViewController {
    
    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone.local
        
        return dateFormatter
    }
    
    func saveContext() {
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func addAlarm() {
        
        let date = getDateFormatter().date(from: String.init(format: "%@:%@", selectedHour,selectedMin))

        let newAlarm = NSEntityDescription.entity(forEntityName: "Alarm", in: self.managedObjectContext)
        
        let managedObject = NSManagedObject.init(entity: newAlarm!, insertInto: self.managedObjectContext)
        
        managedObject.setValue(self.autoIncrementID, forKey: "alarmID")
        managedObject.setValue(alarmInfo[0].info, forKey: "weekdaysName")
//        managedObject.setValue(alarmInfo[2].info, forKey: "sound")
        managedObject.setValue(alarmInfo[1].info, forKey: "alarmName")
        managedObject.setValue(date, forKey: "alarmTime")
        managedObject.setValue(true, forKey: "enabled")
        managedObject.setValue(selectedDays, forKey: "weekdays")
        
        //Schedule Notification for Alarm
        Scheduler().setNotificationWithDate(date!, weekdays: selectedDays, sound: "", alarmName: alarmInfo[1].info, identifier: String(self.autoIncrementID))
        
        saveContext()        
    }
    
    func editAlarm() {
        
        let date = getDateFormatter().date(from: String.init(format: "%@:%@", selectedHour,selectedMin))

        selectedAlarm.setValue(alarmInfo[0].info, forKey: "weekdaysName")
//        selectedAlarm.setValue(alarmInfo[2].info, forKey: "sound")
        selectedAlarm.setValue(alarmInfo[1].info, forKey: "alarmName")
        selectedAlarm.setValue(date, forKey: "alarmTime")
        
        Scheduler().deleteNotification(identifier: String(selectedAlarm.alarmID), weekdays: selectedAlarm.weekdays!)
        Scheduler().setNotificationWithDate(date!, weekdays: selectedDays, sound: "", alarmName: alarmInfo[1].info, identifier: String(selectedAlarm.alarmID))

        saveContext()
    }
    
    func deleteAlarm() {
        Scheduler().deleteNotification(identifier: String(selectedAlarm.alarmID), weekdays: selectedAlarm.weekdays!)
        self.managedObjectContext.delete(selectedAlarm)
        
        saveContext()
    }
}
