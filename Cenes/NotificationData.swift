//
//  NotificationData.swift
//  Cenes
//
//  Created by Redblink on 23/10/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class NotificationData: NSObject {
    var title:String!
    var senderName :String!
    var message :String!
    var time : Int64!
    var notificationImageURL : String!
    var readStatus: String!;
    var notificationImage : UIImage!
    var type : String!
    var notificationTypeId : NSNumber!
    var notificationId : NSNumber!
    var user: User!
    
    func loadNotificationData(notificationDict: NSDictionary) -> NotificationData {
        
        let notification = NotificationData();
        notification.senderName = notificationDict.value(forKey: "sender") as? String
        notification.title = notificationDict.value(forKey: "title") as? String
        notification.message = notificationDict.value(forKey: "message") as? String
        notification.time = notificationDict.value(forKey: "createdAt") as? Int64
        notification.notificationImageURL = notificationDict.value(forKey: "senderPicture") as? String
        notification.notificationTypeId = notificationDict.value(forKey: "notificationTypeId") as? NSNumber
        notification.notificationId = notificationDict.value(forKey: "notificationId") as? NSNumber
        notification.type = notificationDict.value(forKey: "type") as? String
        notification.readStatus = notificationDict.value(forKey: "readStatus") as? String

        if (notificationDict.value(forKey: "user") != nil) {
            let user = User().loadUserData(userDataDict: (notificationDict.value(forKey: "user") as? NSDictionary)!);
            notification.user = user;
        }
        return notification;
    }
}
