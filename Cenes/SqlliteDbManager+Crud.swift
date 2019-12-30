//
//  SqlliteDbManager+Crud.swift
//  Cenes
//
//  Created by Cenes_Dev on 22/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {
    
    func createEventTable() {
    
        do {
            let events = Table("events")
            let eventId = Expression<Int64>("event_id") //0
            let title = Expression<String?>("title")    //1
            let location = Expression<String>("location")//2
            let latitude = Expression<String>("latitude")//3
            let longitude = Expression<String>("longitude")//4
            let startTime = Expression<Int64>("start_time")//5
            let endTime = Expression<Int64>("end_time")//6
            let createdById = Expression<Int64>("created_by_id")//7
            let source = Expression<String>("source")           //8
            let scheduleAs = Expression<String>("schedule_as")  //9
            let thumbnail = Expression<String>("thumbnail")     //10
            let eventPicture = Expression<String>("event_picture")//11
            let isPredictiveOn = Expression<Bool>("is_predictive_on")//12
            let isFullDay = Expression<Bool>("is_full_day")          //13
            let placeId = Expression<String>("place_id")             //14
            let fullDayStartTime = Expression<String>("full_day_start_time")//15
            let key = Expression<String>("key")                             //16
            let expired = Expression<Bool>("expired")                       //17
            let synced = Expression<Bool>("synced");                        //18
            let description = Expression<String>("description");            //19
            let eventPictureBinary = Expression<String>("event_picture_binary");            //20

            try database.run(events.create { t in
                t.column(eventId, defaultValue: 0)
                t.column(title)
                t.column(location, defaultValue: "")
                t.column(latitude, defaultValue: "")
                t.column(longitude, defaultValue: "")
                t.column(startTime)
                t.column(endTime)
                t.column(createdById, defaultValue: 0)
                t.column(source)
                t.column(scheduleAs)
                t.column(thumbnail, defaultValue: "")
                t.column(eventPicture, defaultValue: "")
                t.column(isPredictiveOn, defaultValue: false)
                t.column(isFullDay, defaultValue: false)
                t.column(placeId, defaultValue: "")
                t.column(fullDayStartTime, defaultValue: "")
                t.column(key, defaultValue: "")
                t.column(expired, defaultValue: false)
                t.column(synced, defaultValue: true)
                t.column(description, defaultValue: "")
                t.column(eventPictureBinary, defaultValue: "")

            })
            // CREATE TABLE "users" (
            //     "id" INTEGER PRIMARY KEY NOT NULL,
            //     "name" TEXT,
            //     "email" TEXT NOT NULL UNIQUE
            // )
        } catch {
            print("Create Event Table Error", error)
        }
    }
    
    func saveEvent(event: Event) {
        
        var dbEvent = Event();
        if (event.eventId != nil) {
            dbEvent = findEventByEventId(eventId: event.eventId);
        }
        if (dbEvent.title == nil) {
         
            do {
                let stmt = try database.prepare("INSERT INTO events (event_id, title, location, latitude, longitude, start_time, end_time, created_by_id, source, schedule_as, thumbnail, event_picture, is_predictive_on, is_full_day, place_id, full_day_start_time, key, expired, synced, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
                
                var placeId = "";
                if (event.placeId != nil) {
                    placeId = event.placeId ;
                }
                var thumbnail = "";
                if (event.thumbnail != nil) {
                    thumbnail = event.thumbnail ;
                }
                var eventPicture = "";
                if (event.eventPicture != nil) {
                    eventPicture = event.eventPicture ;
                }
                var location = "";
                if (event.location != nil) {
                    location = event.location ;
                }
                var latitude = "";
                if (event.latitude != nil) {
                    latitude = event.latitude ;
                }
                var longitude = "";
                if (event.longitude != nil) {
                    longitude = event.longitude ;
                }
                
                var fullDayStartTime = "";
                if (event.fullDayStartTime != nil) {
                    fullDayStartTime = event.fullDayStartTime ;
                }
                
                var key = "";
                if (event.key != nil) {
                    key = event.key ;
                }
                
                var description = "";
                if (event.description != nil) {
                    description = event.description ;
                }

                try stmt.run(Int64(event.eventId), event.title, location, latitude, longitude, event.startTime, event.endTime, Int64(event.createdById), event.source, event.scheduleAs, thumbnail, eventPicture, event.isPredictiveOn, event.isFullDay, placeId, fullDayStartTime, key, event.expired, event.synced, description);

                //Saving Event Members Of Event
                if (event.eventMembers != nil && event.eventMembers.count > 0) {
                    for eventMember in event.eventMembers {
                        saveEventMembers(eventMember: eventMember);
                    }
                } else {
                    event.eventMembers = [EventMember]();
                }
            } catch {
                print("Insert event error ",error)
            }
        } else {
            updateEventByEventId(eventId: event.eventId, eventFromApi:event);
        }
    }
    
    func saveEventWhenNoInternet(event: Event) {
                
        do {
            let stmt = try database.prepare("INSERT INTO events (event_id, title, location, latitude, longitude, start_time, end_time, created_by_id, source, schedule_as, thumbnail, event_picture, is_predictive_on, is_full_day, place_id, full_day_start_time, key, expired, synced, description, event_picture_binary) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
            
            
            event.eventId = Int32(Date().timeIntervalSince1970);
            event.synced = false;
            event.expired = false;
            event.scheduleAs = "Gathering";
            event.source = "Cenes";
            
            var placeId = "";
            if (event.placeId != nil) {
                placeId = event.placeId ;
            }
            var thumbnail = "";
            if (event.thumbnail != nil) {
                thumbnail = event.thumbnail ;
            }
            var eventPicture = "";
            if (event.eventPicture != nil) {
                eventPicture = event.eventPicture ;
            }
            var location = "";
            if (event.location != nil) {
                location = event.location ;
            }
            var latitude = "";
            if (event.latitude != nil) {
                latitude = event.latitude ;
            }
            var longitude = "";
            if (event.longitude != nil) {
                longitude = event.longitude ;
            }
            
            var fullDayStartTime = "";
            if (event.fullDayStartTime != nil) {
                fullDayStartTime = event.fullDayStartTime ;
            }
            
            var key = "";
            if (event.key != nil) {
                key = event.key ;
            }
            
            var description = "";
            if (event.description != nil) {
                description = event.description ;
            }

            try stmt.run(Int64(event.eventId), event.title, location, latitude, longitude, event.startTime, event.endTime, Int64(event.createdById), event.source, event.scheduleAs, thumbnail, eventPicture, event.isPredictiveOn, event.isFullDay, placeId, fullDayStartTime, key, event.expired, event.synced, description,  event.eventPictureBinary.base64EncodedString());

            //Saving Event Members Of Event
            let eventMember = EventMember();
            eventMember.eventId = event.eventId;
            eventMember.userId = event.createdById;
            saveEventMemberWhenNoInternet(eventMember: eventMember);
            event.eventMembers = [EventMember]();
            event.eventMembers.append(eventMember);
            /*if (event.eventMembers != nil && event.eventMembers.count > 0) {
                for eventMember in event.eventMembers {
                    saveEventMembers(eventMember: eventMember);
                }
            } else {
                event.eventMembers = [EventMember]();
            }*/
        } catch {
            print("Insert event error ",error)
        }
    }
    
    func updateEventByEventId(eventId: Int32, eventFromApi: Event) {
        
        do {
            let stmt = try database.prepare("update events set title =?, location = ?, latitude = ?, longitude = ?, start_time = ?, end_time = ?, thumbnail = ?, event_picture = ?, is_predictive_on = ?, is_full_day = ?, place_id = ?, expired = ?, description = ? where event_id = ?");
                           
            var placeId = "";
            if (eventFromApi.placeId != nil) {
                placeId = eventFromApi.placeId ;
            }
            var thumbnail = "";
            if (eventFromApi.thumbnail != nil) {
                thumbnail = eventFromApi.thumbnail ;
            }
            var eventPicture = "";
            if (eventFromApi.eventPicture != nil) {
                eventPicture = eventFromApi.eventPicture ;
            }
            var location = "";
            if (eventFromApi.location != nil) {
                location = eventFromApi.location ;
            }
            var latitude = "";
            if (eventFromApi.latitude != nil) {
                latitude = eventFromApi.latitude ;
            }
            var longitude = "";
            if (eventFromApi.longitude != nil) {
                longitude = eventFromApi.longitude ;
            }
            
            var description = "";
            if (eventFromApi.description != nil) {
                description = eventFromApi.description ;
            }

            try stmt.run(eventFromApi.title, location, latitude, longitude, eventFromApi.startTime, eventFromApi.endTime, thumbnail, eventPicture, eventFromApi.isPredictiveOn, eventFromApi.isFullDay, placeId, eventFromApi.expired, description, Int64(eventId));
            
            if (eventFromApi.eventMembers != nil && eventFromApi.eventMembers.count > 0) {
                for apiEventMember in eventFromApi.eventMembers {
                    saveEventMembers(eventMember: apiEventMember);
                }
            }
            
        } catch {
            print("Error in updateEventByEventId : ", error)
        }
    }
    
    func findEventByEventId(eventId: Int32) -> Event {
        
        var offlineEvent = Event();
        do {
            let selectStmt = try database.prepare("SELECT * from events where event_id = ?");
            for event in  try selectStmt.run(Int64(eventId)) {
                print("Event Title : ", event[1]!);
                offlineEvent = processSqlLiveEventData(event: event);
            }
        } catch {
           print("Insert event error ",error)
       }
        return offlineEvent;
    }
    
    func findAllEvents() -> [Event] {
        
        var offlineEvents = [Event]();
        do {
                for event in try database.prepare("SELECT * from events") {
                   print("Event Title : ", event[1]!);
                    let offlineEvent = processSqlLiveEventData(event: event);
                    offlineEvents.append(offlineEvent);
               }
                   
               } catch {
                  print("Insert event error ",error)
              }
        return offlineEvents;
    }
    
    func findHomeScreenEvents(loggedInUserId: Int32) -> [Event] {
        
        var calendarTabEvents = [Event]();
        let events = findAllEvents();
        for event in events {
            if (event.scheduleAs == "Notification") {
                continue;
            }
            if (event.eventMembers != nil && event.eventMembers.count > 0) {
                
                for eventMemer in event.eventMembers {
                    if (eventMemer.userId != nil && eventMemer.userId == loggedInUserId && eventMemer.status == "Going") {
                        calendarTabEvents.append(event);
                        break;
                    }
                }
            }
        }
        return calendarTabEvents;
    }

    
    func findEventsByEventMemberStatus(eventMemberStatus: String, loggedInUserId: Int32) -> [Event] {
        var invitationTabEvents = [Event]();
        let events = findAllEvents();
        for event in events {
            if (event.scheduleAs != "Gathering") {
                continue;
            }
            if (event.eventMembers != nil && event.eventMembers.count > 0) {
                
                for eventMemer in event.eventMembers {
                    if (eventMemberStatus == "GOING" && eventMemer.userId == loggedInUserId && eventMemer.status == "Going") {
                        invitationTabEvents.append(event);
                        break;
                    } else if (eventMemberStatus == "NOTGOING" && eventMemer.userId == loggedInUserId && eventMemer.status == "NotGoing") {
                        invitationTabEvents.append(event);
                        break;
                    }  else if (eventMemberStatus == "PENDING" && eventMemer.userId == loggedInUserId && (eventMemer.status == nil || eventMemer.status == "") && event.createdById != loggedInUserId) {
                       invitationTabEvents.append(event);
                       break;
                   }
                }

            }
        }
        return invitationTabEvents;
    }
    
    func findUnsynedEvents() -> [Event] {
        
        var unsyncedEvents = [Event]();
         do {
             let selectStmt = try database.prepare("SELECT * from events where synced = ?");
             for event in  try selectStmt.run(0) {
                print("Unsynced Event Title : ", event[1]!);
                let offlineEvent = processSqlLiveEventData(event: event);
                unsyncedEvents.append(offlineEvent);
             }
         } catch {
            print("Insert event error ",error)
        }
         return unsyncedEvents;
    }
    
    func updateSyncStatusEventByEventId(eventId: Int32) {
        
        do {
            let stmt = try database.prepare("update events set synced = ? where event_id = ?");
            try stmt.run(1, Int64(eventId));
                        
        } catch {
            print("Error in updateEventByEventId : ", error)
        }
    }
    
    func findAllEventCounts(){
        do {
            print("Event Counts : ", try database.scalar("SELECT count(*) FROM events"));
        } catch {
            print(error)
        }
    }
    
    func processSqlLiveEventData(event: Statement.Element) -> Event {
        
        let offlineEvent = Event();
        offlineEvent.eventId = Int32(event[0] as! Int64);
        offlineEvent.title = event[1]! as? String;
        offlineEvent.location = event[2]! as? String;
        offlineEvent.latitude = event[3]! as? String;
        offlineEvent.longitude = event[4]! as? String;
        offlineEvent.startTime = event[5]! as! Int64;
        offlineEvent.endTime = event[6]! as! Int64;
        offlineEvent.createdById = Int32(event[7]! as! Int64);
        offlineEvent.source = event[8]! as? String;
        offlineEvent.scheduleAs = event[9]! as? String;
        offlineEvent.thumbnail = event[10]! as? String;
        offlineEvent.eventPicture = event[11]! as? String;

        if ((event[12]! as! Int64) == 0) {
            offlineEvent.isPredictiveOn = false;
        } else {
            offlineEvent.isPredictiveOn = true;
        }
        if ((event[13]! as! Int64) == 0) {
            offlineEvent.isFullDay = false;
        } else {
            offlineEvent.isFullDay = true;
        }
        offlineEvent.placeId = event[14]! as? String;
        offlineEvent.fullDayStartTime = event[15]! as? String;
        offlineEvent.key = event[16]! as? String;
        if ((event[17]! as! Int64) == 0) {
            offlineEvent.expired = false;
        } else {
            offlineEvent.expired = true;
        }
        if ((event[18]! as! Int64) == 0) {
            offlineEvent.synced = false;
        } else {
            offlineEvent.synced = true;
        }
        offlineEvent.description = event[19]! as? String;

        let imageDataStr = event[20]! as? String;
        if (imageDataStr != nil && imageDataStr != "") {
            offlineEvent.eventPictureBinary = Data(base64Encoded: imageDataStr!)!;
        }
        let eventMembers = findEventMembersByEventId(eventId: offlineEvent.eventId);
        offlineEvent.eventMembers = eventMembers;
        
        return offlineEvent;
    }
    
    //Delete All Events
    func deleteAllEvents() {
     
        do {
            let deleteStmt = try database.prepare("DELETE from events");
            try deleteStmt.run();
            
            //Delete All Event Members
            deleteAllEventMembers();
        } catch {
            print("Delete All Events : ", error);
        }
    }
    
    //Delete Event By Event Id
    func deleteEventByEventId(eventId: Int32) {
     
        do {
            let deleteStmt = try database.prepare("DELETE from events where event_id = ?");
            try deleteStmt.run(Int64(eventId));
            
            //Deleting EventMember By EventId
            deleteEventMembersByEventId(eventId: eventId);
        } catch {
            print("deleteEventByEventId : ", error);
        }
    }

}
