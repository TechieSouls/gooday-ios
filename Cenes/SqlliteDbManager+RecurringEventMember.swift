//
//  SqlliteDbManager+RecurringEventMember.swift
//  Cenes
//
//  Created by Cenes_Dev on 08/05/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {

    func createTableRecurringEventMember() {
        do {
            let recurringEventMembers = Table("recurring_event_members")
            let recurringEventMemberId = Expression<Int64>("recurring_event_member_id")
            let recurringEventId = Expression<Int64>("recurring_event_id")
            let userId = Expression<Int64>("user_id")

            try database.run(recurringEventMembers.create { t in
                t.column(recurringEventMemberId, defaultValue: 0)
                t.column(recurringEventId, defaultValue: 0)
                t.column(userId, defaultValue: 0)
            });
        } catch {
            print("Error in createTableRecurringEventMember : ", error)
        }
    }
 
    func saveRecurringEventMember(recurringEventMember: RecurringEventMember) {
        do {
            let srInsertCommant = "INSERT into recurring_event_members (recurring_event_member_id, recurring_event_id, user_id) VALUES (?, ?, ?)";
            let stmt = try database.prepare(srInsertCommant);
            
            try stmt.run(Int64(recurringEventMember.recurringEventMemberId), Int64(recurringEventMember.recurringEventId), Int64(recurringEventMember.userId));
            
            if (recurringEventMember.user != nil) {
                saveCenesUser(cenesUser: recurringEventMember.user);
            }
            if (recurringEventMember.userContact != nil) {
                saveCenesContact(cenesContact: recurringEventMember.userContact);
            }
        } catch {
            print("Error in saveRecurringEventMember : ", error);
        }
    }
    
    func findRecurringEventMembersByRecurringEventId(recurringEventId: Int32) -> [RecurringEventMember] {
        var recurringEventMembers = [RecurringEventMember]();
        do {
            
            let selectQuery = "SELECT * from recurring_event_members where recurring_event_id = ?";
            let selectStmt = try database.prepare(selectQuery);
            for recurringEventMemberData in try selectStmt.run(Int64(recurringEventId)) {
                let recurringEventMember = processSqlliteRecurringEventMemberData(recurringEventMemberData: recurringEventMemberData);
                
                let user = findCenesUserByUserId(userId: recurringEventMember.userId);
                recurringEventMember.user = user;
                
                let userContact = findCenesUserContactByUserId(userId: recurringEventMember.userId);
                recurringEventMember.userContact = userContact;
                
                recurringEventMembers.append(recurringEventMember);
            }
        } catch {
            print("Error in findRecurringEventMembersByRecurringEventId : ", error)
        }
        return recurringEventMembers;
    }
    
    func deleteRecurringEventMembersByRecurringEventId(recurringEventId: Int32) {
        do {
            let deleteStmt = "DELETE from recurring_event_members where recurring_event_member_id = ?";
            print(deleteStmt);
            let selectStmt = try database.prepare(deleteStmt);
            try selectStmt.run(Int64(recurringEventId));
        } catch {
            print("Error in deleteRecurringEventMembersByRecurringEventId : ", error)
        }
    }
    
    func deleteAllRecurringEventMembers() {
        do {
            let deleteStmt = "DELETE from recurring_event_members";
            print(deleteStmt);
            try database.run(deleteStmt);
        } catch {
            print("Error in deleteAllRecurringEventMembers : ", error)
        }
    }
    
    func processSqlliteRecurringEventMemberData(recurringEventMemberData: Statement.Element) -> RecurringEventMember{
        
        let recurringEventMember = RecurringEventMember();
        recurringEventMember.recurringEventMemberId = Int32(recurringEventMemberData[0] as! Int64);
        recurringEventMember.recurringEventId = Int32(recurringEventMemberData[1] as! Int64);
        recurringEventMember.userId = Int32(recurringEventMemberData[2] as! Int64);
        return recurringEventMember;
    }

}
