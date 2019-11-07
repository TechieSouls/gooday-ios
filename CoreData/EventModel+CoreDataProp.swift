//
//  EventModel+CoreDataProp.swift
//  Deploy
//
//  Created by Cenes_Dev on 26/08/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class EventModel {
    
    func saveEventModel(event: Event) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        var eventAlreadyExists = false;
        let eventMO = fetchOfflineEventByEventId(eventId: event.eventId);
        if (eventMO.eventId != 0) {
            eventAlreadyExists = true;
        }
        if (eventAlreadyExists == false) {
            
            let entity = NSEntityDescription.entity(forEntityName: "EventMO", in: context)
            
            let entityModel = NSManagedObject(entity: entity!, insertInto: context) as! EventMO
            
            entityModel.eventId = event.eventId;
            entityModel.title = event.title;
            entityModel.desc = event.description;
            entityModel.location = event.location;
            entityModel.latitude = event.latitude;
            entityModel.longitude = event.longitude;
            entityModel.startTime = event.startTime;
            entityModel.endTime = event.endTime;
            entityModel.key = event.key;
            entityModel.createdById = event.createdById;
            entityModel.eventPicture = event.eventPicture;
            entityModel.scheduleAs = event.scheduleAs;
            entityModel.eventSource = event.source;
            entityModel.thumbnail = event.thumbnail;
            entityModel.isFullDay = event.isFullDay
            
            // Create Mutable Set
            let eventMembers = event.eventMembers;
            if (eventMembers!.count > 0) {
                
                for eventMem in eventMembers! {
                    
                    let entityMember = NSEntityDescription.entity(forEntityName: "EventMemberMO", in: context)
                    
                    let entityMemberModel = NSManagedObject(entity: entityMember!, insertInto: context) as! EventMemberMO

                    entityMemberModel.eventMemberId = eventMem.eventMemberId;
                    if (eventMem.userId != nil) {
                        entityMemberModel.userId = eventMem.userId;
                    }
                    if (eventMem.name != nil) {
                        entityMemberModel.name = eventMem.name;
                    }
                    entityMemberModel.eventId = eventMem.eventId;
                    entityModel.addToEventMembers(entityMemberModel);
                }
            }
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func saveNewEventModelOffline(event: Event, user: User) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;
        
        let entityModel = EventMO(context: context);

        entityModel.eventId = Int32(Date().timeIntervalSince1970);
        entityModel.synced = false;
        entityModel.expired = false;
        entityModel.scheduleAs = "Gathering";
        entityModel.source = "Cenes";
        entityModel.createdById = event.createdById;

        entityModel.title = event.title;
        entityModel.startTime = event.startTime;
        entityModel.endTime = event.endTime;
        
        if let description = event.description {
            entityModel.desc = description;
        }
        if let location = event.location {
            entityModel.location = location;
        }
        if let latitude = event.latitude {
           entityModel.latitude = latitude;
        }
        if let longitude = event.longitude {
           entityModel.longitude = longitude;
        }
        if let placeId = event.placeId {
           entityModel.placeId = placeId;
        }
        if let photo = event.eventPicture {
           entityModel.eventPicture = photo;
        }
        if let thumbnail = event.thumbnail {
           entityModel.thumbnail = thumbnail;
        }
        
        entityModel.eventPictureBinary = event.eventPictureBinary;

        for eventMem in event.eventMembers {
            entityModel.addToEventMembers(EventMemberModel().copyBOToManagedObject(eventMember: eventMem));
        }
        //let eventMemberMO = EventMemberModel().loggedInUserAsEventMember(user: user);
        //entityModel.addToEventMembers(eventMemberMO);
        
        print(entityModel.description);
        do {
            try context.save();
        } catch {
            print(error);
        }
    }
    
    func saveEventModelByEventDictnory(eventDict: NSDictionary) -> EventMO {
        
        print(eventDict.value(forKey: "title") as! String)
        let eventId = eventDict.value(forKey: "eventId") as! Int32;
        var eventAlreadyExists = false;
        let eventMo = fetchOfflineEventByEventId(eventId: eventId);
        if eventMo.eventId != 0 && eventMo.title != nil {
            eventAlreadyExists = true;
            return eventMo;
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        if (eventAlreadyExists == false) {
            
            let entity = NSEntityDescription.entity(forEntityName: "EventMO", in: context)
            let entityModel = NSManagedObject(entity: entity!, insertInto: context) as! EventMO
            
            //print("Title", eventDict.value(forKey: "title") as! String);
            entityModel.eventId = eventDict.value(forKey: "eventId") as! Int32;
            entityModel.title = (eventDict.value(forKey: "title") as! String);
            
            if let desc = eventDict.value(forKey: "description") as? String {
                entityModel.desc = desc;
            }
            if let location = eventDict.value(forKey: "location") as? String {
                entityModel.location = location;
            }
            if let latitude = eventDict.value(forKey: "latitude") as? String {
                entityModel.latitude = latitude;
            }
            if let longitude = eventDict.value(forKey: "longitude") as? String {
                entityModel.longitude = longitude;
            }

            entityModel.startTime = eventDict.value(forKey: "startTime") as! Int64;
            entityModel.endTime = eventDict.value(forKey: "endTime") as! Int64;
            
            if let expired = eventDict.value(forKey: "expired") as? Bool {
                entityModel.expired = expired;
            }

            if let key = eventDict.value(forKey: "key") as? String {
                entityModel.key = key;
            }
            entityModel.createdById = eventDict.value(forKey: "createdById") as! Int32;
            if let eventPicture = eventDict.value(forKey: "eventPicture") as? String {
                entityModel.eventPicture = eventPicture;
            }
            entityModel.scheduleAs = (eventDict.value(forKey: "scheduleAs") as! String);
            entityModel.eventSource = (eventDict.value(forKey: "source") as! String);
            if let thumbnail = eventDict.value(forKey: "thumbnail") as? String {
                entityModel.thumbnail = thumbnail;
            }
            entityModel.isFullDay = eventDict.value(forKey: "isFullDay") as! Bool;
            entityModel.synced = true;
            // Create Mutable Set
            
            do {
                //print(entityModel.description)
                if let eventMembersArray = eventDict.value(forKey: "eventMembers") as? NSArray {
                    
                    for eventMemObj in eventMembersArray {
                        
                        let eventMemberDict = eventMemObj as! NSDictionary;
                        let eventMemberMO = EventMemberModel().saveEventMemberModel(eventMemberDict: eventMemberDict);
                        if (eventMemberMO.eventMemberId != 0) {
                            //print(eventMemberMO.description);
                            entityModel.addToEventMembers(eventMemberMO);

                        }
                    }
                }
                
                try context.save();
                return entityModel;
            } catch {
                print("Failed saving Event Managed Object func : saveEventModelByEventDictnory")
            }
        }
        
        return EventMO(context: context);
    }
    
    
    func emtpyEventModel() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest);
            //context.reset();
        } catch {
            print ("There was an error")
        }
    }
    
    
    func deleteEventByEventId(eventId: Int32) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventMO")
        deleteFetch.predicate = NSPredicate(format: "eventId == %i", eventId)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
        } catch {
            print ("There was an error")
        }
    }

    func fetchOfflineEvents() -> [Event] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        var events = [Event]();
        var eventsMo = [EventMO]();
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<EventMO> = EventMO.fetchRequest();
        
        let sortDescriptors = [NSSortDescriptor(key:"startTime" ,
                                                ascending:true )]
        fetchRequest.sortDescriptors = sortDescriptors;
        do {
            let eventsMOTemp = try context.fetch(fetchRequest) as! [EventMO]
            if (eventsMOTemp.count > 0) {
                for eventMoTemp in eventsMOTemp {
                    if (eventMoTemp.eventId != 0 && eventMoTemp.title != nil) {
                        eventsMo.append(eventMoTemp);
                    }
                }
            }
            
            for eventMO in eventsMo {
                let eventBO = copyDataToEventBo(eventMo: eventMO);
                events.append(eventBO);
            }
            
            return events;
            //print("Offline Event Counts : \(eventsMo.count)")
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return events;
    }

    func fetchEventsByEventMemberStatus(loggedInUserId: Int32, eventMemberStatus: String) -> [Event] {
        
        var invitationTabEvents = [Event]();
        let events = fetchOfflineEvents();
        for event in events {
            
            if (event.title == nil && event.scheduleAs != "Gathering") {
                continue;
            }
            for eventMemer in event.eventMembers {
                
                if (eventMemberStatus == "GOING" && eventMemer.userId == loggedInUserId && eventMemer.status == "Going") {
                    invitationTabEvents.append(event);
                    break;
                } else if (eventMemberStatus == "NOTGOING" && eventMemer.userId == loggedInUserId && eventMemer.status == "NotGoing") {
                    invitationTabEvents.append(event);
                    break;
                }  else if (eventMemberStatus == "PENDING" && eventMemer.userId == loggedInUserId && eventMemer.status == nil && event.createdById != loggedInUserId) {
                   invitationTabEvents.append(event);
                   break;
               }
            }
        }
        
        return invitationTabEvents;
    }
    
    func fetchOfflineEventByEventId(eventId: Int32) -> EventMO {
                
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "eventId == %i", eventId)
        fetchRequest.relationshipKeyPathsForPrefetching = ["eventMembers"];
        do {
            let eventMos = try context.fetch(fetchRequest) as! [EventMO];
            for eventM in eventMos {
                //print(eventM.eventId, eventM.description)
                if (eventM.title != nil) {
                    return eventM;
                }
            }
            return EventMO(context: context);
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return EventMO(context: context);
    }
    
    func updateEventManagedObjectFromDictionary(eventDict: NSDictionary) -> Event {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "eventId == %i", eventDict.value(forKey: "eventId") as! Int32);
        fetchRequest.relationshipKeyPathsForPrefetching = ["eventMembers"];
        do {
            let eventMos = try context.fetch(fetchRequest) as! [EventMO];
            if (eventMos.count > 0) {
                for eventM in eventMos {
                    //print(eventM.eventId, eventM.description)
                    if (eventM.title != nil) {
                            
                        eventM.title = (eventDict.value(forKey: "title") as! String);
                        
                        if let desc = eventDict.value(forKey: "description") as? String {
                            eventM.desc = desc;
                        }
                        if let location = eventDict.value(forKey: "location") as? String {
                            eventM.location = location;
                        }
                        if let latitude = eventDict.value(forKey: "latitude") as? String {
                            eventM.latitude = latitude;
                        }
                        if let longitude = eventDict.value(forKey: "longitude") as? String {
                            eventM.longitude = longitude;
                        }

                        eventM.startTime = eventDict.value(forKey: "startTime") as! Int64;
                        eventM.endTime = eventDict.value(forKey: "endTime") as! Int64;
                        
                        if let eventPicture = eventDict.value(forKey: "eventPicture") as? String {
                            eventM.eventPicture = eventPicture;
                        }
                        if let thumbnail = eventDict.value(forKey: "thumbnail") as? String {
                            eventM.thumbnail = thumbnail;
                        }
                        
                        do {
                            try context.save();
                            
                            eventM.eventMembers = nil;
                            for eventMem in eventDict.value(forKey: "eventMembers") as! NSArray {
                                let eventMemDict = eventMem as! NSDictionary;
                                eventM.addToEventMembers(EventMemberModel().updateEventMemberFromDictionary(eventMemberDict: eventMemDict));
                            }
                            
                            return copyDataToEventBo(eventMo: eventM);
                        } catch {
                            print(error);
                        }
                    }
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return copyDataToEventBo(eventMo: saveEventModelByEventDictnory(eventDict: eventDict));
    }
    
    func updateEventManagedObjectSyncedStatus(eventMO: EventMO) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "eventId == %i", eventMO.eventId);
        do {
            let eventMos = try context.fetch(fetchRequest) as! [EventMO];
            for eventM in eventMos {
                //print(eventM.eventId, eventM.description)
                if (eventM.title != nil) {
                        
                    eventM.synced = true;
                    do {
                        try context.save();
                        
                    } catch {
                        print(error);
                    }
                    break;
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func findAllUnSyncedEvents() -> [EventMO] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;
        
        var eventManagedObjects = [EventMO]();
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "synced == %i", false)
        fetchRequest.relationshipKeyPathsForPrefetching = ["eventMembers"];
        do {
            let eventMos = try context.fetch(fetchRequest) as! [EventMO];
            for eventM in eventMos {
                //print(eventM.eventId, eventM.description)
                if (eventM.title != nil) {
                    eventManagedObjects.append(eventM);
                }
            }
            return eventManagedObjects;
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return eventManagedObjects;

    }
    
    func copyDataToNewEventObject(event: EventMO, context: NSManagedObjectContext) -> EventMO {
        
        let tempEvent = EventMO(context: context);
        tempEvent.title = event.title;
        tempEvent.desc = event.desc;
        tempEvent.eventPicture = event.eventPicture
        tempEvent.eventId = event.eventId;
        tempEvent.startTime = event.startTime;
        tempEvent.endTime = event.endTime;
        tempEvent.location = event.location;
        tempEvent.source = event.source;
        tempEvent.sourceEventId = event.sourceEventId;
        tempEvent.latitude = event.latitude;
        tempEvent.longitude = event.longitude;
        tempEvent.scheduleAs = event.scheduleAs;
        tempEvent.createdById = event.createdById;
        tempEvent.thumbnail = event.thumbnail;
        tempEvent.isPredictiveOn = event.isPredictiveOn;
        tempEvent.isFullDay = event.isFullDay;
        tempEvent.placeId = event.placeId;
        tempEvent.predictiveData = event.predictiveData;
        tempEvent.fullDayStartTime = event.fullDayStartTime;
        tempEvent.key = event.key;
        tempEvent.expired = event.expired;
        
        
        tempEvent.eventMembers = event.eventMembers;
        //print("Event Id : ", event.eventId, "EventMember Counts : ", event.eventMembers!.count);
        for eventMem in event.eventMembers! {
            let eventMemMO  = eventMem as! EventMemberMO;
            //print(eventMemMO.description);
        }
        
        return tempEvent;
    }
    
    func copyDataToEventBo(eventMo: EventMO) -> Event{
        
        let event = Event();
        event.eventId = eventMo.eventId;
        event.title = eventMo.title;
        event.description = eventMo.desc;
        event.createdById = eventMo.createdById;
        event.startTime = eventMo.startTime;
        event.endTime = eventMo.endTime;
        event.eventPicture = eventMo.eventPicture;
        event.expired = eventMo.expired;
        event.source = eventMo.eventSource;
        event.scheduleAs = eventMo.scheduleAs;
        event.latitude = eventMo.latitude;
        event.longitude = eventMo.longitude;
        event.location = eventMo.location;
        event.key = eventMo.key;
        event.isFullDay = eventMo.isFullDay;
        event.thumbnail = eventMo.thumbnail;
        event.expired = eventMo.expired;

        event.eventMembers = [EventMember]();
        for eventMember in eventMo.eventMembers!{
            let eventMemberMo = eventMember as! EventMemberMO;
            event.eventMembers.append(copyDataToEventMemberBo(eventMo: eventMo, eventMemberMO: eventMemberMo));
        }

        return event;
    }
    
     func copyDataToEventMemberBo(eventMo: EventMO, eventMemberMO: EventMemberMO) -> EventMember {
        
        let eventMember = EventMember();
        eventMember.eventMemberId = eventMemberMO.eventMemberId;
        eventMember.eventId = eventMo.eventId;
        eventMember.name = eventMemberMO.name;
        eventMember.userId = eventMemberMO.userId;
        
        if let status = eventMemberMO.status {
            eventMember.status = status;
        }
        if let user = eventMemberMO.user {
            print(eventMemberMO.user?.description)
            eventMember.user = CenesUserModel().copyManagedObjectToBO(cenesUserMO: user);
        }
        return eventMember;
    }
    
}
