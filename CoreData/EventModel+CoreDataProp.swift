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
    
    func saveEventModel(event: Event, context: NSManagedObjectContext) {
        
        
        var eventAlreadyExists = false;
        let eventMos = fetchOfflineEvents(context: context);
        for eventMo in eventMos {
            if (eventMo.eventId == event.eventId) {
                eventAlreadyExists = true;
                break;
            }
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
    
    func emtpyEventModel(context: NSManagedObjectContext) {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func emtpyEventMemberMOModel(context: NSManagedObjectContext) {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "EventMemberMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

    
    func fetchOfflineEvents(context: NSManagedObjectContext) -> [EventMO] {
        
        var eventsMo = [EventMO]();
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "EventMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            eventsMo = try context.fetch(fetchRequest) as! [EventMO]
            print("Offline Event Counts : \(eventsMo.count)")
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return eventsMo;
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
        
        
        let members = eventMo.mutableSetValue(forKey: "eventMembers");
        print(members.count)
        event.eventMembers = [EventMember]();
        for eventMemberMo in members.allObjects as! [EventMemberMO] {
            event.eventMembers.append(copyDataToEventMemberBo(eventMemberMO: eventMemberMo));
        }

        return event;
    }
    
     func copyDataToEventMemberBo(eventMemberMO: EventMemberMO) -> EventMember {
        
        let eventMember = EventMember();
        eventMember.eventMemberId = eventMemberMO.eventMemberId;
        eventMember.eventId = eventMemberMO.eventId;
        eventMember.name = eventMemberMO.name;
        eventMember.userId = eventMemberMO.userId;
        
        return eventMember;
    }
}
