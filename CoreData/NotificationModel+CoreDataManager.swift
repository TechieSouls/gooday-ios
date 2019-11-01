//
//  NotificationModel+CoreDataManager.swift
//  Deploy
//
//  Created by Cenes_Dev on 03/10/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class NotificationModel {
    
    /*func saveNotificationModel(notificationData: NotificationData, context: NSManagedObjectContext) {
        
        
        var notificationAlreadyExists = false;
        let notificationMos = fetchOfflineNotifications(context: context);
        for notificationMo in notificationMos {
            if (notificationMo.notificationId == notificationData.notificationId) {
                notificationAlreadyExists = true;
                break;
            }
        }
        if (notificationAlreadyExists == false) {
            
            let entity = NSEntityDescription.entity(forEntityName: "NotificationMO", in: context)
            
            let entityModel = NSManagedObject(entity: entity!, insertInto: context) as! NotificationMO
            
            entityModel.notificationId = notificationData.notificationId;
            entityModel.title = notificationData.title;
            entityModel.message = notificationData.message;
            entityModel.notificationTypeId = notificationData.notificationTypeId;
            entityModel.readStatus = notificationData.readStatus;
            entityModel.type = notificationData.type;
            entityModel.action = notificationData.action;
            // Create Mutable Set
            let event = notificationData.event;
            if (event != nil) {
                EventModel().saveEventModel(event: event!, context: context);
            }
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }*/
    
    func saveNotificationModelArray(notificationDataArray: NSArray) -> [NotificationMO] {
    
        var notificationMOs = [NotificationMO]();
        for notificationArrItem in notificationDataArray {
            
            let notificationDict = notificationArrItem as! NSDictionary;
            var notificationMO = findNotificationByNotifcationId(notificationId: notificationDict.value(forKey: "notificationId") as! Int32);
            
            if (notificationMO.notificationId == 0) {
                notificationMO = saveNotificationModel(notificationDataDict: notificationDict);
                //print(notificationMO.notificationId)
                if (notificationMO.notificationId != 0) {
                    notificationMOs.append(notificationMO);
                }
            }

        }
        return notificationMOs;
    }

    func saveNotificationModel(notificationDataDict: NSDictionary) -> NotificationMO {
            
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

            
        let entity = NSEntityDescription.entity(forEntityName: "NotificationMO", in: context)
        let entityModel = NSManagedObject(entity: entity!, insertInto: context) as! NotificationMO

        entityModel.notificationId = notificationDataDict.value(forKey: "notificationId") as! Int32;
        entityModel.title = (notificationDataDict.value(forKey: "title") as! String);
        entityModel.message = (notificationDataDict.value(forKey: "message") as! String);
        entityModel.notificationTypeId = notificationDataDict.value(forKey: "notificationTypeId") as! Int32;
        entityModel.readStatus =  (notificationDataDict.value(forKey: "readStatus") as! String);
        entityModel.type = (notificationDataDict.value(forKey: "type") as! String);
        entityModel.action = (notificationDataDict.value(forKey: "action") as! String);
        entityModel.createdAt = notificationDataDict.value(forKey: "createdAt") as! Int64;
        entityModel.senderId = notificationDataDict.value(forKey: "senderId") as! Int32;
        entityModel.recepientId = notificationDataDict.value(forKey: "recepientId") as! Int32;

        do {
            //Lets Save the event also if its there.
            if let eventDict = notificationDataDict.value(forKey: "event") as? NSDictionary {
                let eventMO = EventModel().saveEventModelByEventDictnory(eventDict: eventDict);
                entityModel.event = eventMO;
            }
            
            //Lets Save the user also if its there.
            if let userDict = notificationDataDict.value(forKey: "user") as? NSDictionary {
                let cenesUser = CenesUserModel().saveCenesUserModel(cenesUserDict: userDict);
                entityModel.user = cenesUser;
            }
            
            try context.save();

            return entityModel;
        } catch {
            print("Failed saving")
        }
        
        return NotificationMO(context: context);
    }

    func fetchOfflineNotifications() -> [NotificationMO] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        var notificationMos = [NotificationMO]();
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "NotificationMO", in: context)
        let sortDescriptors = [NSSortDescriptor(key:"createdAt" ,
                                                ascending:false), NSSortDescriptor(key:"readStatus" ,
                                                                                     ascending:false )]

        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.sortDescriptors = sortDescriptors;
        do {
            let notificationMosTemp = try context.fetch(fetchRequest) as! [NotificationMO];
            
            for notificationMoTemp in notificationMosTemp {
                if (notificationMoTemp.notificationId != 0) {
                    print(notificationMoTemp.notificationTypeId, notificationMoTemp.event?.title);
                    notificationMos.append(notificationMoTemp);
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return notificationMos;
    }
    
    func findNotificationByNotifcationId(notificationId: Int32) -> NotificationMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "NotificationMO", in: context)

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()

        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "notificationId == %i", notificationId);

        do {
            let notificationMOs = try context.fetch(fetchRequest) as! [NotificationMO];
            if (notificationMOs.count > 0) {
                return notificationMOs[0];
            }
            
        } catch {
            print(error)
        }
        return NotificationMO(context: context);
    }
    
    
    func emtpyNotificationModel() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func deleteNotificationByNotificationId(eventId: Int32) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "NotificationMO")
        deleteFetch.predicate = NSPredicate(format: "notificationTypeId == %i", eventId);
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }

    }
    
    func updateNotificationReadStatus(readStatus: String, notificationId: Int32) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "NotificationMO", in: context)

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()

        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "notificationId != %i", notificationId);

        do {
            let notificationMOs = try context.fetch(fetchRequest) as! [NotificationMO];
            let notification = notificationMOs[0];
            notification.readStatus = "Read";
            
            do {
                try context.save();
            } catch {
                print(error);
            }
        } catch {
            print(error)
        }
    }
    
    func copyNotificationMOToNotificationDataBO(notificationMO: NotificationMO) -> NotificationData {
        
        let notificationData = NotificationData();
        notificationData.notificationId = notificationMO.notificationId
        notificationData.notificationTypeId = notificationMO.notificationTypeId
        notificationData.readStatus = notificationMO.readStatus
        notificationData.action = notificationMO.action
        notificationData.readStatus = notificationMO.readStatus
        notificationData.createdAt = notificationMO.createdAt
        notificationData.message = notificationMO.message
        notificationData.senderId = notificationMO.senderId
        notificationData.title = notificationMO.title
        notificationData.type = notificationMO.type;
        
        if let event = notificationMO.event {
            notificationData.event = EventModel().copyDataToEventBo(eventMo: event);
        }
        
        if let user = notificationMO.user {
            notificationData.user = CenesUserModel().copyManagedObjectToBO(cenesUserMO: user);
        }

        return notificationData;
    }
}
