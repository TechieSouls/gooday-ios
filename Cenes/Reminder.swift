//
//  Reminder.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/27/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation

class Reminders :NSObject ,UNUserNotificationCenterDelegate{
    
    func removeNotification(identifiers: [String]) {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func scheduleNotification(at date: Date, identifier: String, reminderTitle: String) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        let extractedExpr = UNMutableNotificationContent()
        let content = extractedExpr
        content.title = "Cenes Reminder"
        content.body = reminderTitle
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
    
    func locationNotification(at region:CLRegion, identifier: String, title: String) {
        let trigger = UNLocationNotificationTrigger(region: region, repeats:false)
        print("locationNotification\(region)")
        let content = UNMutableNotificationContent()
        content.title = "Cenes Reminder"
        content.body = "At your location"
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}
