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
    
        func scheduleNotification(at date: Date) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "remind me on"
        content.body = "\(date)"
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
                }
            }
       
        }
    func locationNotification(at region:CLRegion)
    {
        let trigger = UNLocationNotificationTrigger(region: region, repeats:false)
        print("locationNotification\(region)")
        let content = UNMutableNotificationContent()
        content.title = "It's My Place"
        content.body = "It's working!"
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
