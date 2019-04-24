//
//  NotificationPersistanceManager.swift
//  Deploy
//
//  Created by Cenes_Dev on 13/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData;

class NotificationPersistanceManager : PersistanceManager {
    
    var context: NSManagedObjectContext!;
    var entity: NSEntityDescription!;
    
    func initPersistanceManager() {
        context = getContext();
        entity = NSEntityDescription.entity(forEntityName: "Notification", in: context);
    }
    
    
    func saveNotification(notificationData: NotificationData) {
        
        initPersistanceManager();
        
        let notificationObj = NSManagedObject(entity: entity!, insertInto: context)

        notificationObj.setValue(notificationData.notificationId, forKey: "notificationId")
        notificationObj.setValue(notificationData.notificationTypeId, forKey: "notificationTypeId")
        notificationObj.setValue(notificationData.action, forKey: "action")
        notificationObj.setValue(notificationData.message, forKey: "message")
        notificationObj.setValue(notificationData.readStatus, forKey: "readStatus")
        notificationObj.setValue(notificationData.title, forKey: "title")
        notificationObj.setValue(notificationData.type, forKey: "type")
        notificationObj.setValue(notificationData.createdAt, forKey: "createdAt")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getAllNotifications() -> [NotificationData] {
        
        initPersistanceManager();

        var notificationDataList = [NotificationData]();
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notification")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                //print(data.value(forKey: "username") as! String)
                notificationDataList.append(data as! NotificationData);
            }
        } catch {
            
            print("Failed")
        }
        return notificationDataList;
    }
    
    
}
