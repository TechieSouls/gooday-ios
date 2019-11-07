//
//  NotificationManager.swift
//  Deploy
//
//  Created by Cenes_Dev on 02/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class NotificationManager {
    
    func parseNotificationData(notifications: [NotificationData], notificationDtos: [NotificationDto]) -> [NotificationDto] {
        
        var unreadNotifications: [NotificationData]!;
        var readNotifications: [NotificationData]!;

        unreadNotifications = [NotificationData]();
        readNotifications = [NotificationData]();

        for notification in notifications {
            if (notification.readStatus == "Read") {
                if (readNotifications == nil) {
                    readNotifications = [NotificationData]();
                }
                readNotifications.append(notification);
            } else {
                if (unreadNotifications == nil) {
                    unreadNotifications = [NotificationData]();
                }
                unreadNotifications.append(notification);
            }
        }
        
        var notificationDtos = [NotificationDto]();
        if (unreadNotifications != nil && unreadNotifications.count > 0) {
            let notificationDto = NotificationDto();
            notificationDto.header = "New"
            notificationDto.notifications = unreadNotifications;
            notificationDtos.append(notificationDto);
        }
        if (readNotifications != nil && readNotifications.count > 0) {
            let notificationDto = NotificationDto();
            notificationDto.header = "Seen"
            notificationDto.notifications = readNotifications;
            notificationDtos.append(notificationDto);
        }
        return notificationDtos;
    }
    
    
    
    func parseNotificationModelList(notifications: [NotificationMO], notificationDtos: [NotificationDto]) -> [NotificationDto] {
        
        var unreadNotifications: [NotificationMO]!;
        var readNotifications: [NotificationMO]!;
        
        unreadNotifications = [NotificationMO]();
        readNotifications = [NotificationMO]();
        
        for notification in notifications {
            if (notification.readStatus == "Read") {
                if (readNotifications == nil) {
                    readNotifications = [NotificationMO]();
                }
                readNotifications.append(notification);
            } else {
                if (unreadNotifications == nil) {
                    unreadNotifications = [NotificationMO]();
                }
                
                //let eventMO = EventModel().fetchOfflineEventByEventId(eventId: notification.notificationTypeId);
                //notification.event = eventMO;
                
                
                //let cenesUser = CenesUserModel().fetchOfflineCenesUserByUserId(cenesUserId: notification.senderId);
                //notification.user = cenesUser;
                
                unreadNotifications.append(notification);
            }
        }
        
        var notificationDtos = [NotificationDto]();
        if (unreadNotifications != nil && unreadNotifications.count > 0) {
            
            unreadNotifications = unreadNotifications.sorted(by: { $0.createdAt > $1.createdAt });
            
            let notificationDto = NotificationDto();
            notificationDto.header = "New"
            notificationDto.notificationModels = unreadNotifications;
            notificationDtos.append(notificationDto);
        }
        if (readNotifications != nil && readNotifications.count > 0) {
            
            readNotifications = readNotifications.sorted(by: { $0.createdAt > $1.createdAt });
            
            let notificationDto = NotificationDto();
            notificationDto.header = "Seen"
            notificationDto.notificationModels = readNotifications;
            notificationDtos.append(notificationDto);
        }
        
        return notificationDtos;
    }
}
