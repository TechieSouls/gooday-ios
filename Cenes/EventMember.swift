//
//  EventMember.swift
//  Deploy
//
//  Created by Cenes_Dev on 27/02/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
class EventMember {
    
    var eventMemberId: Int32!;
    var eventId: Int32!;
    var userId: Int32!;
    var userContactId: Int32!;
    var name: String!;
    var phone: String!;
    var source: String!;
    var sourceEmail: String!;
    var status: String!;
    var sourceId: String!;
    var owner: Bool!;
    var alreadyInvited: Bool!
    var cenesMember: String!;
    var photo: String!;
    var user: User!;
    
    func loadEventMemberData(eventMemberDict: NSDictionary) -> EventMember {
        let eventMember = EventMember();
        
        eventMember.eventMemberId = eventMemberDict.value(forKey: "eventMemberId") as? Int32;
        eventMember.eventId = eventMemberDict.value(forKey: "eventId") as? Int32;
        eventMember.source = eventMemberDict.value(forKey: "source") as? String;
        eventMember.sourceEmail = eventMemberDict.value(forKey: "sourceEmail") as? String;
        eventMember.sourceId = eventMemberDict.value(forKey: "sourceId") as? String;
        eventMember.cenesMember = eventMemberDict.value(forKey: "cenesMember") as? String;
        eventMember.name = eventMemberDict.value(forKey: "name") as? String;
        eventMember.status = eventMemberDict.value(forKey: "status") as? String;
        eventMember.userId = eventMemberDict.value(forKey: "userId") as? Int32;
        eventMember.userContactId = eventMemberDict.value(forKey: "userContactId") as? Int32;
        eventMember.owner = eventMemberDict.value(forKey: "owner") as? Bool;
        eventMember.alreadyInvited = eventMemberDict.value(forKey: "alreadyInvited") as? Bool;
        
        if let user = eventMemberDict.value(forKey: "user") as? NSDictionary {
            eventMember.user = User().loadUserData(userDataDict: user);
        }
        
        
        return eventMember;
    }
    
    func loadUserContactData(eventMemberDict: NSDictionary) -> EventMember {
        let eventMember = EventMember();
        
        eventMember.eventMemberId = eventMemberDict.value(forKey: "eventMemberId") as? Int32;
        eventMember.eventId = eventMemberDict.value(forKey: "eventId") as? Int32;
        eventMember.source = eventMemberDict.value(forKey: "source") as? String;
        eventMember.sourceEmail = eventMemberDict.value(forKey: "sourceEmail") as? String;
        eventMember.sourceId = eventMemberDict.value(forKey: "sourceId") as? String;
        eventMember.cenesMember = eventMemberDict.value(forKey: "cenesMember") as? String;
        eventMember.name = eventMemberDict.value(forKey: "name") as? String;
        eventMember.status = eventMemberDict.value(forKey: "status") as? String;
        eventMember.userId = eventMemberDict.value(forKey: "friendId") as? Int32;
        eventMember.userContactId = eventMemberDict.value(forKey: "userContactId") as? Int32;
        eventMember.owner = eventMemberDict.value(forKey: "owner") as? Bool;
        
        if let user = eventMemberDict.value(forKey: "user") as? NSDictionary {
            eventMember.user = User().loadUserData(userDataDict: user);
        }
        
        
        return eventMember;
    }
    
    func loadEventMembers(eventMemberArray: NSArray) -> [EventMember] {
        
        var eventMembers = [EventMember]();
        
        for eventMemberDict in eventMemberArray {
            eventMembers.append(self.loadEventMemberData(eventMemberDict: eventMemberDict as! NSDictionary));
        }
        return eventMembers;
        
    }
    
    func loadUserContacts(eventMemberArray: NSArray) -> [EventMember] {
        
        var eventMembers = [EventMember]();
        
        for eventMemberDict in eventMemberArray {
            eventMembers.append(self.loadUserContactData(eventMemberDict: eventMemberDict as! NSDictionary));
        }
        return eventMembers;
        
    }
    
    func toDictionary(eventMember: EventMember) -> [String: Any] {
        
        var eventMemberJson: [String: Any] = [:];
        
        eventMemberJson["eventId"] = eventMember.eventId;
        eventMemberJson["eventMemberId"] = eventMember.eventMemberId;
        eventMemberJson["name"] = eventMember.name;
        eventMemberJson["userContactId"] = eventMember.userContactId;
        eventMemberJson["userId"] = eventMember.userId;
        eventMemberJson["status"] = eventMember.status;
        
        return eventMemberJson;
    }
    
    func filtered(eventMembers: [EventMember], predicate: String) -> [EventMember] {
        
        var userContactsToReturn: [EventMember] = [];
        for eventMember in eventMembers {
            
            if (eventMember.name.starts(with: predicate)) {
                userContactsToReturn.append(eventMember);
            }
        }
        return userContactsToReturn;
    }
}
