//
//  EventMemberModel+CoreDataManager.swift
//  Deploy
//
//  Created by Cenes_Dev on 04/10/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class EventMemberModel {
    
    func saveEventMemberModel(eventMemberDict: NSDictionary) -> EventMemberMO {
        
        let eventMemberId = eventMemberDict.value(forKey: "eventMemberId") as! Int32
        var eventMemberAlreadyExists = false;
        let eventMemberMo = fetchOfflineEventMemberByEventMemberId(eventMemberId: eventMemberId);
        
        if (eventMemberMo.eventMemberId != 0 && eventMemberMo.eventMemberId == eventMemberId) {
            eventMemberAlreadyExists = true;
            return eventMemberMo;
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;
        if (eventMemberAlreadyExists == false) {
            
            let entity = NSEntityDescription.entity(forEntityName: "EventMemberMO", in: context)
            let eventMemberModel = NSManagedObject(entity: entity!, insertInto: context) as! EventMemberMO
            
            eventMemberModel.eventMemberId = eventMemberDict.value(forKey: "eventMemberId") as! Int32;
            eventMemberModel.eventId = eventMemberDict.value(forKey: "eventId") as! Int32;
            
            if let userId = eventMemberDict.value(forKey: "userId") as? Int32 {
                eventMemberModel.userId = userId;
            }
            
            if let name = eventMemberDict.value(forKey: "name") as? String {
                eventMemberModel.name = name;
            }
            
            if let photo = eventMemberDict.value(forKey: "photo") as? String {
                eventMemberModel.photo = photo;
            }
            
            if let status = eventMemberDict.value(forKey: "status") as? String {
                eventMemberModel.status = status;
            }
            
            if let userContactId = eventMemberDict.value(forKey: "userContactId") as? Int32 {
                eventMemberModel.userContactId = userContactId;
            }

            do {
                if let userDict = eventMemberDict.value(forKey: "user") as? NSDictionary {
                    let user = CenesUserModel().saveCenesUserModel(cenesUserDict: userDict);
                    if (user.userId != 0) {
                        //print(user.description);
                        eventMemberModel.user = user;
                    }
                }
                try context.save()
                return eventMemberModel;
            } catch {
                print("Failed saving Event member mo, func : saveEventMemberModel")
            }
        }
        return EventMemberMO(context: context);
    }

    func fetchOfflineEventMemberByEventMemberId(eventMemberId: Int32) -> EventMemberMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventMemberMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "eventMemberId == %i", eventMemberId)
        do {
            let eventMembers = try context.fetch(fetchRequest) as! [EventMemberMO];
            if (eventMembers.count > 0) {
                return eventMembers[0];
            } else {
                return EventMemberMO(context: context);
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            print("Failed saving Event Member Managed Object func : fetchOfflineEventMemberByEventMemberId")

        }
        
        return EventMemberMO(context: context);
    }
    
    func loggedInUserAsEventMember(user: User) -> EventMemberMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let eventMember = EventMemberMO(context: context);
        eventMember.userId = user.userId;
        eventMember.user = CenesUserModel().loggedInUserAsCenesUser(user: user, context: context);
        eventMember.cenesMember = "yes";
        eventMember.status = "Going";
        return eventMember;
    }
    
    func saveIfNotPresent(eventMemDict: NSDictionary) -> EventMemberMO {

        let eventMemberId = eventMemDict.value(forKey: "eventMemberId") as! Int32;
        let eventMemberMo = fetchOfflineEventMemberByEventMemberId(eventMemberId: eventMemberId);
        if (eventMemberMo.eventMemberId != 0) {
            if let userDict = eventMemDict.value(forKey: "user") as? NSDictionary {
                let user = CenesUserModel().saveCenesUserModel(cenesUserDict: userDict);
                if (user.userId != 0) {
                    eventMemberMo.user = user;
                }
            }
            return eventMemberMo;
        } else {
            //Lets save Event Member
            return saveEventMemberModel(eventMemberDict: eventMemDict);
        }
    }
    
    func updateEventMemberStatus(eventId: Int32, userId: Int32, status: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventMemberMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "userId == %i AND eventId == %i", userId, eventId);
        do {
            var eventMemberMO = EventMemberMO(context: context);
            let eventMembers = try context.fetch(fetchRequest) as! [EventMemberMO];
            if (eventMembers.count > 0) {
                eventMemberMO = eventMembers[0];
            }
            if (eventMemberMO.eventMemberId > 0) {
                eventMemberMO.status = status;
                
                do {
                    try context.save();
                } catch {
                    print("Error in updating event member status ",error)
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            print("Failed saving Event Member Managed Object func : fetchOfflineEventMemberByEventMemberId")

        }
    }
    
    func updateEventMemberFromDictionary(eventMemberDict: NSDictionary) -> EventMemberMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext? = appDelegate.persistentContainer.viewContext;

        let eventMemberId = eventMemberDict.value(forKey: "eventMemberId") as! Int32;
        let eventId = eventMemberDict.value(forKey: "eventId") as! Int32;

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventMemberMO", in: context!)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "eventMemberId == %i AND eventId == %i", eventMemberId, eventId);
        do {
            var eventMemberMO = EventMemberMO(context: context!);
            let eventMembers = try context!.fetch(fetchRequest) as! [EventMemberMO];
            if (eventMembers.count > 0) {
                eventMemberMO = eventMembers[0];
            }
            if (eventMemberMO.eventMemberId > 0) {
                
                if let userId = eventMemberDict.value(forKey: "userId") as? Int32 {
                    eventMemberMO.userId = userId;
                }
                
                if let name = eventMemberDict.value(forKey: "name") as? String {
                    eventMemberMO.name = name;
                }
                
                if let photo = eventMemberDict.value(forKey: "photo") as? String {
                    eventMemberMO.photo = photo;
                }
                
                if let status = eventMemberDict.value(forKey: "status") as? String {
                    eventMemberMO.status = status;
                }
                
                if let userContactId = eventMemberDict.value(forKey: "userContactId") as? Int32 {
                    eventMemberMO.userContactId = userContactId;
                }
                do {
                    try context!.save();
                    return eventMemberMO;
                } catch {
                    print("Error in updating event member status ",error)
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            print("Failed saving Event Member Managed Object func : fetchOfflineEventMemberByEventMemberId")
        }
        return EventMemberMO(context: context!);
    }

    func emtpyEventMemberMOModel() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventMemberMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            //context.reset();

        } catch {
            print ("There was an error")
        }
    }

    func deleteEventMemberMOModelByEventId(eventId: Int32) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventMemberMO");
        deleteFetch.predicate = NSPredicate(format: "eventId == %i", eventId);
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print ("There was an error")
        }
    }

    func convertNSSetToNSArray(eventMembers: NSSet) -> [EventMemberMO] {
        
        var eventMembersToReturn = [EventMemberMO]();
        
        for eventMem in eventMembers {
            let eventMemMO = eventMem as! EventMemberMO;
            eventMembersToReturn.append(eventMemMO);
        }
        
        return eventMembersToReturn;
    }
    
    func copyBOToManagedObject(eventMember: EventMember) -> EventMemberMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;
        let eventMemberMO = EventMemberMO(context: context);
        eventMemberMO.userId = eventMember.userId;
        eventMemberMO.name = eventMember.name;
        eventMemberMO.photo = eventMember.photo;
        
        if let user = eventMember.user {
            eventMemberMO.user = CenesUserModel().copyBOToCenesUser(user: user);
        }
        return eventMemberMO;
    }
}
