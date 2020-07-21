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
    
    func emptyDatabase() {
        sqlDatabaseManager.deleteAllEvents();
        sqlDatabaseManager.deleteAllEventMembers();
        sqlDatabaseManager.deleteAllCenesUser();
        sqlDatabaseManager.deleteAllUserContacts();
        sqlDatabaseManager.deleteAllNotifications();
        sqlDatabaseManager.deleteAllRecurringEvent();
        sqlDatabaseManager.deleteAllMeTimeRecurringPatterns();
        sqlDatabaseManager.deleteAllEventChats();
        sqlDatabaseManager.deleteAllCalendarSyncTokens();
        sqlDatabaseManager.deleteAllRecurringEventMembers();
        sqlDatabaseManager.deleteAllEventCategories();
    }
    
    func createDatabase() {
        
        sqlDatabaseManager.createTableSplashRecords();
        sqlDatabaseManager.createEventTable();
        sqlDatabaseManager.createEventMemberTable();
        sqlDatabaseManager.createTableCenesUser();
        sqlDatabaseManager.createTableCenesContact();
        sqlDatabaseManager.createTableNotifications();
        sqlDatabaseManager.createTableMeTimeRecurringEvents();
        sqlDatabaseManager.createTableMeTimeRecurringPatterns();
        sqlDatabaseManager.createTableEventChats();
        sqlDatabaseManager.createTableCalendarSyncToken();
        sqlDatabaseManager.createTableRecurringEventMember();
        sqlDatabaseManager.createTableEventCategory();
    }
    
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
            let createdAt = Expression<Int64>("created_at")//21
            let updatedAt = Expression<Int64>("update_at")//22
            let displayScreenAt = Expression<String>("display_screen_at")//23
            let processed = Expression<Int64>("processed")//24

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
                t.column(createdAt, defaultValue: 0)
                t.column(updatedAt, defaultValue: 0)
                t.column(displayScreenAt, defaultValue: "")
                t.column(processed, defaultValue: 1)
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
                let saveEventQuery = "INSERT INTO events (event_id, title, location, latitude, longitude, start_time, end_time, created_by_id, source, schedule_as, thumbnail, event_picture, is_predictive_on, is_full_day, place_id, full_day_start_time, key, expired, synced, description, created_at, update_at, display_screen_at, processed) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                print("Save Event Query : ",saveEventQuery);
                let stmt = try database.prepare(saveEventQuery)
                
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
                
                var createdAt = Date().millisecondsSince1970;
                if (event.createdAt != nil) {
                    createdAt = event.createdAt;
                }
                
                var updateAt = Date().millisecondsSince1970;
                if (event.updateAt != nil) {
                    updateAt = event.updateAt;
                }

                try stmt.run(Int64(event.eventId), event.title, location, latitude, longitude, event.startTime, event.endTime, Int64(event.createdById), event.source, event.scheduleAs, thumbnail, eventPicture, event.isPredictiveOn, event.isFullDay, placeId, fullDayStartTime, key, event.expired, event.synced, description, createdAt, updateAt, event.displayScreenAt, Int64(event.processed));

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
            let stmt = try database.prepare("INSERT INTO events (event_id, title, location, latitude, longitude, start_time, end_time, created_by_id, source, schedule_as, thumbnail, event_picture, is_predictive_on, is_full_day, place_id, full_day_start_time, key, expired, synced, description, event_picture_binary, display_screen_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)")
            
            
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

            try stmt.run(Int64(event.eventId), event.title, location, latitude, longitude, event.startTime, event.endTime, Int64(event.createdById), event.source, event.scheduleAs, thumbnail, eventPicture, event.isPredictiveOn, event.isFullDay, placeId, fullDayStartTime, key, event.expired, event.synced, description,  event.eventPictureBinary.base64EncodedString(), event.displayScreenAt);

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
                deleteEventMembersByEventId(eventId: eventFromApi.eventId);
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
    
    func findEventListByEventId(eventId: Int32) -> [Event] {
        
        var offlineEvents = [Event]();
        do {
            let selectStmt = try database.prepare("SELECT * from events where event_id = ?");
            for event in  try selectStmt.run(Int64(eventId)) {
                print("Event Title : ", event[1]!);
                let offlineEvent: Event = processSqlLiveEventData(event: event);
                offlineEvents.append(offlineEvent);
            }
        } catch {
           print("Insert event error ",error)
       }
        return offlineEvents;
    }
    
    func findEventByEventIdAndDisplayScreenAt(eventId: Int32, displayScreenAt: String) -> Event {
        
        var offlineEvent = Event();
        do {
            let selectStmt = try database.prepare("SELECT * from events where event_id = ? and display_screen_at = ?");
            for event in  try selectStmt.run(Int64(eventId), displayScreenAt) {
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
            let selectEventsQuery = "SELECT * from events";
            print("Select Event Query : ",selectEventsQuery);
            for event in try database.prepare(selectEventsQuery) {
               //print("Event Title : ", event[1]!);
                let offlineEvent = processSqlLiveEventData(event: event);
                offlineEvents.append(offlineEvent);
            }
               
           } catch {
              print("Insert event error ",error)
          }
        return offlineEvents;
    }
    
    func findEventsByDisplayAtScreen(displayAtScreen: String) -> [Event] {
        
        var offlineEvents = [Event]();
        do {
            let selectEventsQuery = "SELECT * from events where display_screen_at = ? and schedule_as != ? order by start_time asc";
            print("Select Event Query : ",selectEventsQuery);
            let selectStmt = try database.prepare(selectEventsQuery);
            for event in  try selectStmt.run(displayAtScreen, EventScheduleAs.NOTIFICATION) {
               //print("Event Title : ", event[1]!);
                let offlineEvent = processSqlLiveEventData(event: event);
                offlineEvents.append(offlineEvent);
            }
               
           } catch {
              print("Insert event error ",error)
          }
        return offlineEvents;
    }
    
    func findHomeScreenEvents(userId: Int32) -> [Event] {
        
        var offlineEvents = [Event]();
        do {
            let selectEventsQuery = "SELECT e.* from events e LEFT JOIN event_members em on e.event_id = em.event_id where em.status = ? and em.user_id = ? and e.expired = ? order by start_time asc";
            print("Select Event Query : ",selectEventsQuery);
            let selectStmt = try database.prepare(selectEventsQuery);
            for event in  try selectStmt.run(EventMemberStatus.GOING, Int64(userId), false) {
               //print("Event Title : ", event[1]!);
                let offlineEvent = processSqlLiveEventData(event: event);
                offlineEvents.append(offlineEvent);
            }
               
           } catch {
              print("Insert event error ",error)
          }
        return offlineEvents;
    }
    
    func findAcceptedEvents(userId: Int32) -> [Event] {
        
        var offlineEvents = [Event]();
        do {
            let selectEventsQuery = "SELECT e.* from events e LEFT JOIN event_members em on e.event_id = em.event_id where schedule_as = ? and em.status = ? and em.user_id = ? and e.expired = ? order by start_time asc";
            print("Select Event Query : ",selectEventsQuery);
            let selectStmt = try database.prepare(selectEventsQuery);
            for event in  try selectStmt.run(EventScheduleAs.GATHERING, EventMemberStatus.GOING, Int64(userId), false) {
               //print("Event Title : ", event[1]!);
                let offlineEvent = processSqlLiveEventData(event: event);
                offlineEvents.append(offlineEvent);
            }
               
           } catch {
              print("Insert event error ",error)
          }
        return offlineEvents;
    }

    func findPendingEvents(userId: Int32) -> [Event] {
        
        var offlineEvents = [Event]();
        do {
            let selectEventsQuery = "SELECT e.* from events e LEFT JOIN event_members em on e.event_id = em.event_id where schedule_as = ? and em.status != ? and em.status != ? and em.user_id = ? and e.expired = ? order by start_time asc";
            print("Select Event Query : ",selectEventsQuery);
            let selectStmt = try database.prepare(selectEventsQuery);
            for event in  try selectStmt.run(EventScheduleAs.GATHERING, EventMemberStatus.GOING, EventMemberStatus.NOTGOING, Int64(userId), false) {
               //print("Event Title : ", event[1]!);
                let offlineEvent = processSqlLiveEventData(event: event);
                offlineEvents.append(offlineEvent);
            }
               
           } catch {
              print("Insert event error ",error)
          }
        return offlineEvents;
    }

    func findDeclinedEvents(userId: Int32) -> [Event] {
        
        var offlineEvents = [Event]();
        do {
            let selectEventsQuery = "SELECT e.* from events e LEFT JOIN event_members em on e.event_id = em.event_id where schedule_as = ? and em.status = ? and em.user_id = ? and e.expired = ? order by start_time asc";
            print("Select Event Query : ",selectEventsQuery);
            let selectStmt = try database.prepare(selectEventsQuery);
            for event in  try selectStmt.run(EventScheduleAs.GATHERING, EventMemberStatus.NOTGOING, Int64(userId), false) {
               //print("Event Title : ", event[1]!);
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
                    if (eventMemberStatus == EventMemberStatus.GOING && eventMemer.userId == loggedInUserId && eventMemer.status == "Going") {
                        invitationTabEvents.append(event);
                        break;
                    } else if (eventMemberStatus == EventMemberStatus.NOTGOING && eventMemer.userId == loggedInUserId && eventMemer.status == "NotGoing") {
                        invitationTabEvents.append(event);
                        break;
                    }  else if (eventMemberStatus == EventMemberStatus.PENDING && eventMemer.userId == loggedInUserId && (eventMemer.status == nil || eventMemer.status == "") && event.createdById != loggedInUserId) {
                       invitationTabEvents.append(event);
                       break;
                   }
                }

            }
        }
        return invitationTabEvents;
    }
    
    func findEventsByEventMemberStatusAndGreaterThanNow(eventMemberStatus: String, loggedInUserId: Int32, currentTime: Int64) -> [Event] {
        var invitationTabEvents = [Event]();
        let events = findAllEvents();
        for event in events {
            if (event.scheduleAs != "Gathering") {
                continue;
            }
            if (event.eventMembers != nil && event.eventMembers.count > 0) {
                
                if (currentTime > event.endTime) {
                    continue;
                }
                for eventMemer in event.eventMembers {
                    if (eventMemberStatus == EventMemberStatus.GOING && eventMemer.userId == loggedInUserId && eventMemer.status == "Going") {
                        invitationTabEvents.append(event);
                        break;
                    } else if (eventMemberStatus == EventMemberStatus.NOTGOING && eventMemer.userId == loggedInUserId && eventMemer.status == "NotGoing") {
                        invitationTabEvents.append(event);
                        break;
                    }  else if (eventMemberStatus == EventMemberStatus.PENDING && eventMemer.userId == loggedInUserId && (eventMemer.status == nil || eventMemer.status == "") && event.createdById != loggedInUserId) {
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
    
    func findPastEvents(currentTime: Int64) -> [Event] {
        var pastEvents = [Event]();
         do {
             let selectStmt = try database.prepare("SELECT * from events where start_time < ?");
             for event in  try selectStmt.run(currentTime) {
                let pastEvent = processSqlLiveEventData(event: event);
                pastEvents.append(pastEvent);
             }
         } catch {
            print("Select Past event error ",error)
        }
         return pastEvents;
    }
    
    func updateSyncStatusEventByEventId(eventId: Int32) {
        
        do {
            let stmt = try database.prepare("update events set synced = ? where event_id = ?");
            try stmt.run(1, Int64(eventId));
                        
        } catch {
            print("Error in updateEventByEventId : ", error)
        }
    }
    
    func updateExpiredStatusByEventId(event: Event) {
        
        do {
            let stmt = try database.prepare("update events set expired = ? where event_id = ?");
            try stmt.run(true, Int64(event.eventId));
        } catch {
            print("Error in updateEventByEventId : ", error)
        }
    }
    
    func updateEventInfoByEventId(event: Event) {
        
        do {
            let updateEventQuery = "update events set title = ?, start_time = ?, end_time = ?, description = ?, location = ?, latitude = ?, longitude = ?, event_picture = ? where event_id = ?";
            let stmt = try database.prepare(updateEventQuery);
            
            var description = "";
            if (event.description != nil) {
                description = event.description;
            }
            var location = "";
            if (event.location != nil) {
                location = event.location;
            }
            var latitude = "";
            if (event.latitude != nil) {
                latitude = event.latitude;
            }
            var longitude = "";
            if (event.longitude != nil) {
                longitude = event.longitude;
            }
            var eventPicture = "";
            if (event.eventPicture != nil) {
                eventPicture = event.eventPicture;
            }
            try stmt.run(event.title!, event.startTime, event.endTime, description, location, latitude, longitude, eventPicture, Int64(event.eventId));
                        
        } catch {
            print("Error in updateEventBy EventModel : ", error)
        }
    }

    
    func findAllEventCounts() {
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
        
        offlineEvent.createdAt = event[21]! as! Int64;
        offlineEvent.updateAt = event[22]! as! Int64;
        offlineEvent.displayScreenAt = event[23]! as! String;
        offlineEvent.processed = Int8(event[24]! as! Int64);

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
            let deleteQuery = "DELETE from events where event_id = ?";
            print("Delet query : ",deleteQuery);
            let deleteStmt = try database.prepare(deleteQuery);
            try deleteStmt.run(Int64(eventId));
            
            //Deleting EventMember By EventId
            deleteEventMembersByEventId(eventId: eventId);
        } catch {
            print("deleteEventByEventId : ", error);
        }
    }
    
    //Delete All Events
    func deleteAllEventsByDisplayAtScreen(displatAtScreen: String) {
     
        do {
            let deleteStmt = try database.prepare("DELETE from events where display_screen_at = ?");
            try deleteStmt.run(displatAtScreen);
            
            //Delete All Event Members
            deleteAllEventMembers();
        } catch {
            print("Delete All Events : ", error);
        }
    }
    
    //Delete All Events
    func deleteAllEventsByScheduleAs(scheduleAs: String) {
     
        do {
            let selectQuery = "SELECT * from events where schedule_as = ?";
            print(selectQuery);
            let selectStmt = try database.prepare(selectQuery);
            for event in  try selectStmt.run(scheduleAs) {
               let scheduleAsEvent = processSqlLiveEventData(event: event);
                                
                deleteEventByEventId(eventId: scheduleAsEvent.eventId);
            }
        } catch {
            print("Delete All Events : ", error);
        }
    }

    //Delete All Events
    func deleteAllEventsBySourceAndScheduleAs(source: String, scheduleAs: String) {
        do {
            let selectQuery = "SELECT * from events where schedule_as = ? and source = ?";
            print(selectQuery);
            let selectStmt = try database.prepare(selectQuery);
            for event in  try selectStmt.run(scheduleAs, source) {
               let scheduleAsEvent = processSqlLiveEventData(event: event);
                                
                deleteEventByEventId(eventId: scheduleAsEvent.eventId);
            }
        } catch {
            print("Delete All Events : ", error);
        }
    }
    //Delete All UnProcessed Events
    func deleteAllEventsByProcessedStatus(processed: Int8) {
     
        var unprocessedEvents = [Event]();
         do {
             let selectStmt = try database.prepare("SELECT * from events where processed = ?");
             for event in  try selectStmt.run(Int64(processed)) {
                let unprocessedEvent = processSqlLiveEventData(event: event);
                unprocessedEvents.append(unprocessedEvent);
             }
         } catch {
            print("UnProcessed Event error ",error)
        }
        
        if (unprocessedEvents.count > 0) {
            
            for eventTmp in unprocessedEvents {
                
                do {
                    deleteEventByEventId(eventId: eventTmp.eventId)
                } catch {
                    print("Delete All Events : ", error);
                }
            }
            
        }
    }
    
    func findUnprocessedEvents() -> [Event]{
        var unprocessedEvents = [Event]();
        do {
            let selectStmt = try database.prepare("SELECT * from events where processed = ?");
            for event in  try selectStmt.run(Int64(0)) {
               let unprocessedEvent = processSqlLiveEventData(event: event);
               unprocessedEvents.append(unprocessedEvent);
            }
        } catch {
           print("UnProcessed Event error ",error)
        }
        
        return unprocessedEvents;
    }
}
