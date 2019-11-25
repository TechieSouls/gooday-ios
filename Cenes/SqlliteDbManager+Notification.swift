//
//  SqlliteDbManager+Notification.swift
//  Cenes
//
//  Created by Cenes_Dev on 25/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {
    
    func createTableNotifications() {
        do {
            let cenesUsers = Table("notifications")
            let notificationId = Expression<Int64>("notification_id")
            let title = Expression<String?>("title")
            let senderName = Expression<String>("sender_name")
            let message = Expression<String>("message")
            let notificationTime = Expression<Int64>("notification_time")
            let notificationImageURL = Expression<String>("notification_image_url")
            let readStatus = Expression<String>("read_status")
            let type = Expression<String>("type")
            let action = Expression<String>("action")
            let notificationTypeId = Expression<Int64>("notification_type_id")
            let senderId = Expression<Int64>("sender_id")
            let createdAt = Expression<Int64>("created_at")

            try database.run(cenesUsers.create { t in
                t.column(notificationId, defaultValue: 0)
                t.column(title, defaultValue: "")
                t.column(senderName, defaultValue: "")
                t.column(message, defaultValue: "")
                t.column(notificationTime, defaultValue: 0)
                t.column(notificationImageURL, defaultValue: "")
                t.column(readStatus, defaultValue: "")
                t.column(type, defaultValue: "")
                t.column(action, defaultValue: "")
                t.column(notificationTypeId, defaultValue: 0)
                t.column(senderId, defaultValue: 0)
                t.column(createdAt, defaultValue: 0)

            })
            // CREATE TABLE "notifications" (
            //     "id" INTEGER PRIMARY KEY NOT NULL,
            //     "name" TEXT,
            //     "email" TEXT NOT NULL UNIQUE
            // )
        } catch {
            print("Create Event Table Error", error)
        }
    }
    
    func saveNotification(notification: NotificationData) {
        
        do {
            
            let stmt = try database.prepare("INSERT into notifications (notification_id, title, sender_name, message, notification_time, notification_image_url, read_status, type, action, notification_type_id, sender_id, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            
            var senderName = "";
            if (notification.senderName != nil) {
                senderName = notification.senderName;
            }
            var notificationImageUrl = "";
            if (notification.notificationImageURL != nil) {
                notificationImageUrl = notification.notificationImageURL;
            }
            var type = "";
            if (notification.type != nil) {
                type = notification.type;
            }
            
            var action = "";
            if (notification.action != nil) {
                action = notification.action;
            }
            try stmt.run(Int64(notification.notificationId), notification.title, senderName, notification.message, notification.time, notificationImageUrl, notification.readStatus, type, action, Int64(notification.notificationTypeId), Int64(notification.senderId), notification.createdAt);
                
            //Saving Event From Notification
            if (notification.event != nil) {
                saveEvent(event: notification.event);
            }
            
            //Saving Notifcation Sender
            if (notification.user != nil) {
                saveCenesUser(cenesUser: notification.user);
            }
        } catch {
            print("Error in saveNotification : ", error)
        }
    }
    
    func findAllNotifications() -> [NotificationData] {
        
        var notifications = [NotificationData]();
        do {
            for notification in try database.prepare("SELECT * from notifications") {
               print("Event Title : ", notification[1]!);
               let offlineNotification = processSqlliteNotificationData(notification: notification);
                notifications.append(offlineNotification);
           }
        } catch {
          print("Insert event error ",error)
        }
       return notifications;
    }
    
    func findNotifictionByNotificationId(notificationId: Int32) -> NotificationData {
        
        var notificationData = NotificationData();
        do {
            let selectStmt = try database.prepare("SELECT * from notifications where notification_id = ?");
            for notification in try selectStmt.run(Int64(notificationId)) {
                print("Event Title : ", notification[1]!);
                notificationData = processSqlliteNotificationData(notification: notification);
            }
        } catch {
          print("Insert event error ",error)
        }
        return notificationData;
    }
    
    func updateNotificationReadStatusByNotificationId(readStatus: String, notification: NotificationData) {
        
        do {
            let selectStmt = try database.prepare("UPDATE notificaitons set read_status = ? where notification_id = ?");
            try selectStmt.run(notification.readStatus, Int64(notification.notificationId));
            
        } catch {
            print("Update Error : ", updateNotificationReadStatusByNotificationId)
        }
    }
    
    func deleteAllNotifications() {
        do {
            let selectStmt = try database.prepare("DELETE from notifications");
            try selectStmt.run();
            
        } catch {
            print(error)
        }
    }

    func processSqlliteNotificationData(notification: Statement.Element) -> NotificationData {
        
        let notificationData = NotificationData();
        
        notificationData.notificationId = Int32(notification[0] as! Int64);
        notificationData.title = notification[1] as? String;
        notificationData.senderName = notification[2] as? String;
        notificationData.message = notification[3] as? String;
        notificationData.time = (notification[4] as! Int64);
        notificationData.notificationImageURL = notification[5] as? String
        notificationData.readStatus = notification[6] as? String
        notificationData.type = notification[7] as? String
        notificationData.action = notification[8] as? String
        notificationData.notificationTypeId = Int32(notification[9] as! Int64)
        notificationData.senderId = Int32(notification[10] as! Int64)
        notificationData.createdAt = (notification[11] as! Int64);
        
        //Fetching Event
        if (notificationData.notificationTypeId != nil && notificationData.notificationTypeId != 0) {
            let event = findEventByEventId(eventId: notificationData.notificationTypeId);
            notificationData.event = event;
        }
        
        //Fetching Sending User
        if (notificationData.senderId != nil && notificationData.senderId != 0) {
            let user = findCenesUserByUserId(userId: notificationData.senderId);
            notificationData.user = user;
        }
        return notificationData;
    }

}
