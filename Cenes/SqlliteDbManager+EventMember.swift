//
//  SqlliteDbManager+EventMember.swift
//  Cenes
//
//  Created by Cenes_Dev on 22/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite
extension SqlliteDbManager {

    func createEventMemberTable() {
    
        do {
            let eventMembers = Table("event_members")
            let eventId = Expression<Int64>("event_id")
            let eventMemberId = Expression<Int64>("event_member_id")
            let name = Expression<String>("name")
            let cenesMember = Expression<String>("cenes_member")
            let userId = Expression<Int64>("user_id")
            let photo = Expression<String>("photo")
            let status = Expression<String>("status")
            let phone = Expression<String>("phone")
            let userContactId = Expression<Int64>("user_contact_id")

            try database.run(eventMembers.create { t in
                t.column(eventId, defaultValue: 0)
                t.column(eventMemberId, defaultValue: 0)
                t.column(name, defaultValue: "")
                t.column(cenesMember, defaultValue: "")
                t.column(userId, defaultValue: 0)
                t.column(photo, defaultValue: "")
                t.column(status, defaultValue: "")
                t.column(phone, defaultValue: "")
                t.column(userContactId, defaultValue: 0)

            })
            // CREATE TABLE "users" (
            //     "id" INTEGER PRIMARY KEY NOT NULL,
            //     "name" TEXT,
            //     "email" TEXT NOT NULL UNIQUE
            // )
        } catch {
            print("Create EventMember Table Error", error)
        }
    }
    
    func saveEventMembers(eventMember: EventMember) {
    
        if (eventMember.eventMemberId == nil) {
            eventMember.eventMemberId = Int32(truncatingIfNeeded: Date().millisecondsSince1970);
        }
        let eventMemberFromDatabase = findEventMembersByEventMemberId(eventMemberId: eventMember.eventMemberId);
        if (eventMemberFromDatabase.eventMemberId == nil || eventMemberFromDatabase.eventMemberId == 0) {
            
                do {
                    let stmt = try database.prepare("INSERT INTO event_members (event_id, event_member_id, name, cenes_member, user_id, photo, status, phone, user_contact_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
                    
                    var name = "";
                    if (eventMember.name != nil) {
                        name = eventMember.name;
                    }
                    var cenesMember = "";
                    if (eventMember.cenesMember != nil) {
                        cenesMember = eventMember.cenesMember;
                    }
                    var userId: Int64 = 0;
                    if (eventMember.userId != nil) {
                        userId = Int64(eventMember.userId);
                    }
                    var photo = "";
                    if (eventMember.photo != nil) {
                        photo = eventMember.photo;
                    }
                    var status = "";
                    if (eventMember.status != nil) {
                        status = eventMember.status;
                    }
                    var phone = "";
                    if (eventMember.phone != nil) {
                        phone = eventMember.phone;
                    }
                    var userContactId: Int64 = 0;
                    if (eventMember.userContactId != nil) {
                        userContactId = Int64(eventMember.userContactId);
                    }
                    if (eventMember.eventId != nil) {
                        
                        try stmt.run(Int64(eventMember.eventId), Int64(eventMember.eventMemberId), name, cenesMember, userId, photo, status, phone, userContactId);

                    }
                    
                    //Saving/Updating Cenes User
                    if (eventMember.user != nil) {
                        saveCenesUser(cenesUser: eventMember.user);
                    }
                    
                    //Saving/Updating Cenes Contact
                    if (eventMember.userContact != nil && eventMember.userContact.userContactId != nil  ) {
                        saveCenesContact(cenesContact: eventMember.userContact);
                    }
                    
                } catch {
                    print("Error in saveEventMembers :", error);
                }
        }
    }
    
    
    func saveEventMemberWhenNoInternet(eventMember: EventMember) {
                
        do {
            let stmt = try database.prepare("INSERT INTO event_members (event_id, event_member_id, name, cenes_member, user_id, photo, status, phone, user_contact_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
            
            eventMember.status = "Going"
            eventMember.eventMemberId = eventMember.eventId;
            eventMember.cenesMember = "yes";
            var name = "";
            if (eventMember.name != nil) {
                name = eventMember.name;
            }
            
            var userId: Int64 = 0;
            if (eventMember.userId != nil) {
                userId = Int64(eventMember.userId);
            }
            var photo = "";
            if (eventMember.photo != nil) {
                photo = eventMember.photo;
            }
            var status = "";
            if (eventMember.status != nil) {
                status = eventMember.status;
            }
            var phone = "";
            if (eventMember.phone != nil) {
                phone = eventMember.phone;
            }
            var userContactId: Int64 = 0;
            if (eventMember.userContactId != nil) {
                userContactId = Int64(eventMember.userContactId);
            }
            if (eventMember.eventId != nil) {
                
                try stmt.run(Int64(eventMember.eventId), Int64(eventMember.eventMemberId), name, eventMember.cenesMember, userId, photo, status, phone, userContactId);

            }
        } catch {
            print("Error in saveEventMembers :", error);
        }
    }
    func findEventMembersByEventId(eventId: Int32) -> [EventMember] {
        
        var eventMembers = [EventMember]();
        do {
            let selectStmt = try database.prepare("SELECT * from event_members where event_id = ?");
            for eventMember in  try selectStmt.run(Int64(eventId)) {
                
                let eventMemberDb = EventMember();
                eventMemberDb.eventId = Int32(eventMember[0] as! Int64);
                eventMemberDb.eventMemberId = Int32(eventMember[1] as! Int64);
                eventMemberDb.name = eventMember[2] as? String;
                eventMemberDb.cenesMember = eventMember[3] as? String;
                eventMemberDb.userId = Int32(eventMember[4] as! Int64);
                eventMemberDb.photo = eventMember[5] as? String;
                eventMemberDb.status = eventMember[6] as? String;
                eventMemberDb.phone = eventMember[7] as? String;
                eventMemberDb.userContactId = Int32(eventMember[8] as! Int64);

                if (eventMemberDb.userId != nil && eventMemberDb.userId != 0) {
                    let cenesUser = findCenesUserByUserId(userId: eventMemberDb.userId);
                    if (cenesUser.userId != nil && cenesUser.userId != 0) {
                        eventMemberDb.user = cenesUser;
                    }
                }
                
                if (eventMemberDb.userContactId != nil && eventMemberDb.userContactId != 0) {
                    let cenesContact = findCenesUserContactByUserContactId(userContactId: eventMemberDb.userContactId);
                    if (cenesContact.userContactId != nil && cenesContact.userContactId != 0) {
                        eventMemberDb.userContact = cenesContact;
                    }
                }
                eventMembers.append(eventMemberDb);

            }
        } catch {
            print("Error in findEventMembersByEventId : ", error)
        }
        
        return eventMembers;
    }
    
    func findEventMembersByEventMemberId(eventMemberId: Int32) -> EventMember {
        
        let eventMemberDb = EventMember();
        do {
            let selectStmt = try database.prepare("SELECT * from event_members where event_member_id = ?");
            for eventMember in  try selectStmt.run(Int64(eventMemberId)) {
                
                eventMemberDb.eventId = Int32(eventMember[0] as! Int64);
                eventMemberDb.eventMemberId = Int32(eventMember[1] as! Int64);
                eventMemberDb.name = eventMember[2] as? String;
                eventMemberDb.cenesMember = eventMember[3] as? String;
                eventMemberDb.userId = Int32(eventMember[4] as! Int64);
                eventMemberDb.photo = eventMember[5] as? String;
                eventMemberDb.status = eventMember[6] as? String;
                eventMemberDb.phone = eventMember[7] as? String;
                eventMemberDb.userContactId = Int32(eventMember[8] as! Int64);

                if (eventMemberDb.userId != nil && eventMemberDb.userId != 0) {
                    let cenesUser = findCenesUserByUserId(userId: eventMemberDb.userId);
                    if (cenesUser.userId != nil && cenesUser.userId != 0) {
                        eventMemberDb.user = cenesUser;
                    }
                }
            }
        } catch {
            print("Error in findEventMembersByEventId : ", error)
        }
        
        return eventMemberDb;
    }

    func updateEventMemberStatusByUserId(eventMemberStatus: String, userId: Int32) {
        do {
            let updateEventMemberStatutsQuery = "UPDATE event_members set status = ? where user_id = ?";
            let updateStmt = try database.prepare(updateEventMemberStatutsQuery);
            try updateStmt.run(eventMemberStatus, Int64(userId));
        } catch {
            print(error)
        }
    }

    func deleteEventMembersByEventId(eventId: Int32) {
        do {
            let selectStmt = try database.prepare("DELETE from event_members where event_id = ?");
            try selectStmt.run(Int64(eventId));
        } catch {
            print(error)
        }
    }
    
    func deleteAllEventMembers() {
        do {
            let selectStmt = try database.prepare("DELETE from event_members");
            try selectStmt.run();
            
            deleteAllUserContacts();
        } catch {
            print(error)
        }
    }
}
