//
//  Scheduler.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/25/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class Scheduler {
    
    func setNotificationWithDate(_ date: Date, weekdays: [Int], sound: String, alarmName: String, identifier: String){

        for weekday in weekdays {
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(in: .current, from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: components.hour!, minute: components.minute!, weekday: weekday), repeats: true)
            print(trigger.nextTriggerDate() ?? "nil")
            
            let content = UNMutableNotificationContent()
            content.title = "Cenes"
            content.body = alarmName
//            content.sound = UNNotificationSound(named: "Bell.aiff")
            content.sound = UNNotificationSound.default()
            
            let notificationIdentifier = String(format:"%@%d", identifier, weekday)
            // make sure you give each request a unique identifier. (nextTriggerDate description)
            let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                    return
                }
            }
        }
    }
    
    func deleteNotification(identifier: String, weekdays: [Int]) {
        for weekday in weekdays {
            let notificationIdentifier = String(format:"%@%d", identifier, weekday)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
        }
    }
    
    /*
    
    func setupNotification(date: Date, alarmName: String, identifier: String, weekday: Int){
        
        let calendar = Calendar(identifier: .gregorian)
        
        let components = calendar.dateComponents(in: .current, from: date)
     
        let currentDateComponents = calendar.dateComponents(in: .current, from: Date())
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: currentDateComponents.month, day: currentDateComponents.day, hour: components.hour, minute: components.minute, second: components.second, weekday: weekday)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Cenes"
        content.body = "\(alarmName), Alarm."
        content.sound = UNNotificationSound(named: "Bell.aiff")
        
        let identifier = identifier
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Something went wrong and an error was found: \(error)")
            }
        }
    }
    
    func correctDate(_ date: Date, onWeekdaysForNotify weekdays:[Int], sound: String) -> [Date] {
        
        var correctedDate: [Date] = [Date]()
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let flags: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day]
        let dateComponents = (calendar as NSCalendar).components(flags, from: date)
        let weekday:Int = dateComponents.weekday!
        
        //no repeat
        if weekdays.isEmpty{
            //scheduling date is eariler than current date
            if date < now {
                //plus one day, otherwise the notification will be fired righton
                correctedDate.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchStrictly)!)
            }
            else { //later
                correctedDate.append(date)
            }
            return correctedDate
        } else {    // Repeat
            let daysInWeek = 7
            correctedDate.removeAll(keepingCapacity: true)
            for wd in weekdays {
                
                var wdDate: Date!
                //schedule on next week
                if compare(weekday: wd, with: weekday) == .before {
                    wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd+daysInWeek-weekday, to: date, options:.matchStrictly)!
                }
                    //schedule on today or next week
                else if compare(weekday: wd, with: weekday) == .same {
                    //scheduling date is eariler than current date, then schedule on next week
                    if date.compare(now) == ComparisonResult.orderedAscending {
                        wdDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: daysInWeek, to: date, options:.matchStrictly)!
                    }
                    else { //later
                        wdDate = date
                    }
                }
                    //schedule on next days of this week
                else { //after
                    wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd-weekday, to: date, options:.matchStrictly)!
                }
                
                //fix second component to 0
                wdDate = correctSecondComponent(date: wdDate, calendar: calendar)
                correctedDate.append(wdDate)
            }
            return correctedDate
        }
    }
    
    private enum weekdaysComparisonResult {
        case before
        case same
        case after
    }
    
    private func compare(weekday w1: Int, with w2: Int) -> weekdaysComparisonResult
    {
        if w1 != 1 && w2 == 1 {return .before}
        else if w1 == w2 {return .same}
        else {return .after}
    }
    
    
    private func correctSecondComponent(date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian))->Date {
        let second = calendar.component(.second, from: date)
        let d = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: date, options:.matchStrictly)!
        return d
    }
*/
}
