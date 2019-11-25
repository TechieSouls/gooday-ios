//
//  SqlliteDbManager+CenesContact.swift
//  Cenes
//
//  Created by Cenes_Dev on 24/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {

    func createTableCenesContact() {
        
        do {
            let cenesUsers = Table("cenes_contacts")
            let userContactId = Expression<Int64>("user_contact_id")
            let name = Expression<String?>("name")
            let userId = Expression<Int64>("user_id")
            let friendId = Expression<Int64>("friend_id")
            let phone = Expression<String>("phone")
            let cenesMember = Expression<String>("cenes_member")
            let status = Expression<String>("status")
            let eventMemberId = Expression<Int64>("event_member_id")

            try database.run(cenesUsers.create { t in
                t.column(userContactId, defaultValue: 0)
                t.column(name, defaultValue: "")
                t.column(userId, defaultValue: 0)
                t.column(friendId, defaultValue: 0)
                t.column(phone, defaultValue: "")
                t.column(cenesMember, defaultValue: "")
                t.column(status, defaultValue: "")
                t.column(eventMemberId, defaultValue: 0)
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

    func saveCenesContact(cenesContact: UserContact) {
        
        let cenesUserContactDb = findCenesUserContactByUserContactId(userContactId: Int32(cenesContact.userContactId));
        if (cenesUserContactDb.userContactId == nil) {
            do {
                let stmt = try database.prepare("INSERT into cenes_contacts (user_contact_id, name, user_id, friend_id, phone, cenes_member, status, event_member_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
                
                var name = "";
                if (cenesContact.name != nil) {
                    name = cenesContact.name;
                }
                var userId = 0;
                if (cenesContact.userId != nil) {
                    userId = cenesContact.userId;
                }
                var friendId = 0;
                if (cenesContact.friendId != nil) {
                    friendId = cenesContact.friendId;
                }
                var cenesMember = "";
                if (cenesContact.cenesMember != nil) {
                    cenesMember = cenesContact.cenesMember;
                }
                var status = "";
                if (cenesContact.status != nil) {
                    status = cenesContact.status;
                }
                var phone = "";
                if (cenesContact.phone != nil) {
                    phone = cenesContact.phone;
                }
                var eventMemberId = 0;
                if (cenesContact.eventMemberId != nil) {
                    eventMemberId = Int(cenesContact.eventMemberId);
                }
                try stmt.run(Int64(cenesContact.userContactId), name, userId, friendId, phone, cenesMember, status, eventMemberId);
                
            } catch {
                print("Error in saveCenesUser : ", error)
            }
        } else {
            //updateCenesUserByUserId(cenesUser: cenesUser);
        }
    }

    func findCenesUserContactByUserContactId(userContactId: Int32) -> UserContact {
        
        let cenesUserContact = UserContact();

        do {
            let stmt = try database.prepare("SELECT * from cenes_contacts where user_contact_id = ?");
            for cenesUserContactDb in try stmt.run(Int64(userContactId)) {
                    
                cenesUserContact.userContactId = Int(cenesUserContactDb[0] as! Int64);
                cenesUserContact.name = cenesUserContactDb[1] as? String;
                cenesUserContact.userId = Int(cenesUserContactDb[2] as! Int64);
                cenesUserContact.friendId = Int(cenesUserContactDb[3] as! Int64);
                cenesUserContact.phone = cenesUserContactDb[4] as? String;
                cenesUserContact.cenesMember = cenesUserContactDb[5] as? String;
                cenesUserContact.status = cenesUserContactDb[6] as? String;
                cenesUserContact.eventMemberId = Int32(cenesUserContactDb[7] as! Int64);

            }
        } catch {
            print("Error in saveCenesUser : ", error)
        }
        return cenesUserContact;
    }

    func deleteCenesUserByUserContactId(userContactId: Int) {
        do {
            let stmt = try database.prepare("DELETE from cenes_contacts where user_contact_id = ?");
            try stmt.run(Int64(userContactId));
        } catch {
            print("Error in saveCenesUser : ", error)
        }
    }

    func deleteAllUserContacts() {
        do {
            let deleteStmt = try database.prepare("DELETE from cenes_contacts");
            try deleteStmt.run();
        } catch {
            print(error)
        }
    }
}
