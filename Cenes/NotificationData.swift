//
//  NotificationData.swift
//  Cenes
//
//  Created by Redblink on 23/10/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import CoreData

class NotificationData: NSObject {
    var title:String!
    var senderName :String!
    var message :String!
    var time : Int64!
    var notificationImageURL : String!
    var readStatus: String!;
    var notificationImage : UIImage!
    var type : String!
    var action: String!
    var notificationTypeId : Int32!
    var notificationId : Int32!
    var senderId : Int32!
    var createdAt : Int64!
    var user: User!
    var event: Event!
    
    func loadNotificationData(notificationDict: NSDictionary) -> NotificationData {
        
        let notification = NotificationData();
        notification.senderName = notificationDict.value(forKey: "sender") as? String
        notification.title = String(notificationDict.value(forKey: "title") as! String)
        notification.message = notificationDict.value(forKey: "message") as? String
        notification.time = notificationDict.value(forKey: "createdAt") as? Int64
        notification.notificationImageURL = notificationDict.value(forKey: "senderPicture") as? String
        notification.notificationTypeId = notificationDict.value(forKey: "notificationTypeId") as? Int32
        notification.notificationId = notificationDict.value(forKey: "notificationId") as? Int32
        notification.type = notificationDict.value(forKey: "type") as? String
        notification.readStatus = notificationDict.value(forKey: "readStatus") as? String
        notification.createdAt = notificationDict.value(forKey: "createdAt") as? Int64
        notification.action = notificationDict.value(forKey: "action") as? String
        notification.senderId = notificationDict.value(forKey: "senderId") as? Int32

        if (notificationDict.value(forKey: "user") != nil) {
            let user = User().loadUserData(userDataDict: (notificationDict.value(forKey: "user") as? NSDictionary)!);
            notification.user = user;
        }
        
        if (!(notificationDict.value(forKey: "event") is NSNull) && notificationDict.value(forKey: "event") != nil) {
            let event = Event().loadEventData(eventDict: notificationDict.value(forKey: "event") as! NSDictionary);
            notification.event = event;
        }
        return notification;
    }
    
    func loadNotificationList(notificationArray: NSArray) -> [NotificationData] {
        var notifications = [NotificationData]();
        
        for notificationDict in notificationArray {
            notifications.append(loadNotificationData(notificationDict: notificationDict as! NSDictionary));
        }
        
        return notifications;
    }
    
}
