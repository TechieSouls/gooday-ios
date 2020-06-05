//
//  Event.swift
//  Deploy
//
//  Created by Cenes_Dev on 27/02/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
class Event {
    
    var title: String!;
    var description: String!;
    var eventPicture: String!;
    var eventId: Int32!;
    var startTime: Int64 = Date().millisecondsSince1970
    var endTime: Int64 = Date().millisecondsSince1970
    var location: String!;
    var latitude: String!;
    var longitude: String!;
    var createdById: Int32!;
    var source: String? = "Cenes";
    var scheduleAs: String? = "Gathering";
    var thumbnail: String!;
    var isPredictiveOn: Bool = false;
    var isFullDay: Bool = false
    var placeId: String!;
    var predictiveData: String!;
    var sourceEventId: String!;
    var predictiveDataArr : NSMutableArray!
    var fullDayStartTime: String!;
    var key: String!;
    var isEditMode: Bool = false;
    var eventClickedFrom: String = EventClickedFrom.Home;
    var expired: Bool = false;
    var imageToUpload: UIImage!;
    var requestType = EventRequestType.NewEvent;
    var eventPictureBinary: Data = Data();
    var synced: Bool = true;
    var createdAt: Int64!;
    var updateAt: Int64!;
    var displayScreenAt: String = "Home";
    var processed: Int8 = 1;
    var eventMembers: [EventMember]!;
    
    func createdByUserId() -> Int32 {
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        if (loggedInUser.userId != nil) {
            return loggedInUser.userId;
        }
        
        return 0;
    }
    
    func loadEventData(eventDict: NSDictionary) -> Event {
        
        let event = Event();
        event.title = eventDict.value(forKey: "title") as? String;
        event.description = eventDict.value(forKey: "description") as? String;
        event.eventPicture = eventDict.value(forKey: "eventPicture") as? String;
        if (eventDict.value(forKey: "eventId") != nil) {
            event.eventId = eventDict.value(forKey: "eventId") as? Int32;
        } else if (eventDict.value(forKey: "id") != nil) {
            event.eventId = eventDict.value(forKey: "id") as? Int32;
        }
        event.startTime = eventDict.value(forKey: "startTime") as! Int64;
        event.endTime = eventDict.value(forKey: "endTime") as? Int64 ?? event.startTime;
        event.location = eventDict.value(forKey: "location") as? String;
        event.source = eventDict.value(forKey: "source") as? String ?? "Cenes";
        event.sourceEventId = eventDict.value(forKey: "sourceEventId") as? String ?? nil;
        event.latitude = eventDict.value(forKey: "latitude") as? String;
        event.longitude = eventDict.value(forKey: "longitude") as? String;
        event.scheduleAs = eventDict.value(forKey: "scheduleAs") as? String;
        event.createdById = eventDict.value(forKey: "createdById") as! Int32;
        event.thumbnail = eventDict.value(forKey: "thumbnail") as? String;
        event.isPredictiveOn = eventDict.value(forKey: "isPredictiveOn") != nil ? eventDict.value(forKey: "isPredictiveOn") as! Bool : false;
        event.isFullDay = eventDict.value(forKey: "isFullDay") as! Bool;
        event.placeId = eventDict.value(forKey: "placeId") as? String;
        event.predictiveData = eventDict.value(forKey: "predictiveData") as? String;
        event.fullDayStartTime = eventDict.value(forKey: "fullDayStartTime") as? String;
        event.key = eventDict.value(forKey: "key") as? String;
        event.expired = eventDict.value(forKey: "expired") != nil ? eventDict.value(forKey: "expired") as! Bool : false;
        event.createdAt = eventDict.value(forKey: "createdAt") as? Int64 ?? nil;
        event.updateAt = eventDict.value(forKey: "updateAt") as? Int64 ?? nil;

        if (eventDict.value(forKey: "eventMembers") != nil) {
             event.eventMembers = EventMember().loadEventMembers(eventMemberArray: eventDict.value(forKey: "eventMembers") as! NSArray)
        }
        if (eventDict.value(forKey: "members") != nil) {
            event.eventMembers = EventMember().loadEventMembers(eventMemberArray: eventDict.value(forKey: "members") as! NSArray)
        }
        return event;
    }
    
    func toDictionary(event: Event) -> [String: Any] {
        
        var eventJson: [String: Any] = [:];
        eventJson["title"] = event.title;
        eventJson["description"] = event.description;
        eventJson["eventPicture"] = event.eventPicture;
        eventJson["eventId"] = event.eventId;
        eventJson["createdById"] = event.createdById;
        eventJson["startTime"] = event.startTime;
        eventJson["endTime"] = event.endTime;
        eventJson["location"] = event.location;
        eventJson["scheduleAs"] = event.scheduleAs;
        eventJson["latitude"] = event.latitude;
        eventJson["longitude"] = event.longitude;
        eventJson["createdById"] = event.createdById;
        eventJson["source"] = event.source;
        eventJson["sourceEventId"] = event.sourceEventId;
        eventJson["thumbnail"] = event.thumbnail;
        eventJson["isPredictiveOn"] = event.isPredictiveOn;
        eventJson["isFullDay"] = event.isFullDay;
        eventJson["placeId"] = event.placeId;
        eventJson["predictiveData"] = event.predictiveData;
        eventJson["fullDayStartTime"] = event.fullDayStartTime;
        eventJson["key"] = event.key;
        if (event.eventMembers != nil) {
            var eveMembers: [[String: Any]] = [];
            for evenMem in event.eventMembers! as NSArray {
                eveMembers.append(EventMember().toDictionary(eventMember: evenMem as! EventMember));
            }
            eventJson["eventMembers"] = eveMembers;
        }
        return eventJson;
    }
    
    func copyDataToNewEventObject(event: Event) -> Event {
        var tempEvent = Event();
        
        tempEvent.title = event.title;
        tempEvent.description = event.description;
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
        return tempEvent;
    }
    
    func getLoggedInUserAsEventMember() -> EventMember {
        
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        let eventMember = EventMember();
        eventMember.userId = loggedInUser.userId;
        eventMember.user = loggedInUser;
        eventMember.name = loggedInUser.name;
        eventMember.cenesMember = "yes";
        eventMember.status = "Going";
        return eventMember;
    }
    
    func getLoggedInUserAsUserContact() -> UserContact {
        
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        
        let userContact = UserContact();
        userContact.userId = Int(loggedInUser.userId);
        userContact.user = loggedInUser;
        userContact.name = loggedInUser.name;
        userContact.friendId = Int(loggedInUser.userId);
        userContact.cenesMember = "yes";
        userContact.status = "Going";
        return userContact;
    }

    
    func getEventHostFromMembers() -> EventMember {
        
        var host: EventMember = EventMember();
        if (self.eventMembers != nil) {
            
            for eventMem in self.eventMembers {
                
                if (eventMem.userId != nil && eventMem.userId == self.createdById) {
                    host = eventMem;
                    return host;
                }
            }
        }
        
        return host;
    }
    
    func getEventMembersWithoutHost() -> [EventMember] {
        
        var eventMembersWithoutHost: [EventMember] = [EventMember]();
        if (self.eventMembers != nil) {
            for eventMem in self.eventMembers {
                
                if (eventMem.userId != nil && eventMem.userId != self.createdById) {
                    eventMembersWithoutHost.append(eventMem);
                }
            }
        }
        return eventMembersWithoutHost;
    }
    
    func getAcceptedEventMembersWithoutHost(loggedInUserId: Int32) -> [EventMember] {
        
        var acceptedMembers = [EventMember]();
        
        //Addding all event members without logged in user
        if (self.eventMembers != nil) {
            for eventMem in self.eventMembers {
                if (eventMem.userId != nil && eventMem.userId != self.createdById && eventMem.userId != loggedInUserId && eventMem.status == "Going") {
                    acceptedMembers.append(eventMem);
                }
            }
            
            //Adding Logged in event member at last
            for eventMem in self.eventMembers {
                if (eventMem.userId != nil && eventMem.userId != self.createdById && eventMem.userId == loggedInUserId && eventMem.status == "Going") {
                    acceptedMembers.append(eventMem);
                }
            }
        }
        return acceptedMembers;
    }
    
    
}

class EventSource {
    static let CENES = "Cenes";
    static let GOOGLE = "Google";
    static let OUTLOOK = "Outlook";
    static let APPLE = "Apple";
}


class EventRequestType {
    static let NewEvent = "NEW";
    static let EditEvent = "EDIT";
    static let ViewEvent = "VIEW";
}

class EventClickedFrom {
    static let Home = "HOME";
    static let Gathering = "GATHERING";
    static let Notification = "NOTIFICATION";
}


class EventScheduleAs {
    //Event,MeTime,Holiday,Gathering, Notification
    static let EVENT = "Event";
    static let METIME = "MeTime";
    static let HOLIDAY = "Holiday";
    static let GATHERING = "Gathering";
    static let NOTIFICATION = "Notification";
}


class EventDisplayScreen {
    static let HOME = "Home";
    static let ACCEPTED = "Accepted";
    static let PENDING = "Pending";
    static let DECLINED = "Declined";
}

class EventMemberStatus {
    static let GOING = "Going";
    static let PENDING = "Pending";
    static let NOTGOING = "NotGoing";
}
