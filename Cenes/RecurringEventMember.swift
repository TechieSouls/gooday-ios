//
//  RecurringEventMember.swift
//  Cenes
//
//  Created by Cenes_Dev on 01/05/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class RecurringEventMember {
        
    var recurringEventMemberId: Int32!;
    var recurringEventId: Int32!;
    var userId: Int32!;
    var user: User!;
    var userContact: UserContact!;

    func loadRecurringEventMember(recurringEventMemberDict: NSDictionary) -> RecurringEventMember {
        
        let recurringEventMember = RecurringEventMember();
        recurringEventMember.recurringEventMemberId = recurringEventMemberDict.value(forKey: "recurringEventMemberId") as! Int32;
        recurringEventMember.recurringEventId = recurringEventMemberDict.value(forKey: "recurringEventId") as! Int32;
        recurringEventMember.userId = recurringEventMemberDict.value(forKey: "userId") as! Int32;

        if let userContactDict = recurringEventMemberDict.value(forKey: "userContact") as? NSDictionary {
            recurringEventMember.userContact = UserContact().loadUserContact(userContactDic: userContactDict);
        }

        if let userDict = recurringEventMemberDict.value(forKey: "user") as? NSDictionary {
            recurringEventMember.user = User().loadUserData(userDataDict: userDict);
        }
        return recurringEventMember;
    }

    func loadRecurringEventMemberFromNSArray(recurringEventMemberArr: NSArray) -> [RecurringEventMember] {
        
        var recurringEventMembers = [RecurringEventMember]();
        for recurringEventMemberTmp in recurringEventMemberArr {
            let recurringEventMemberDict = recurringEventMemberTmp as! NSDictionary;
            recurringEventMembers.append(loadRecurringEventMember(recurringEventMemberDict: recurringEventMemberDict));
        }
        return recurringEventMembers;
    }
    
    func toDictionary() -> [String: Any] {
        var recurringEventDict = [String: Any]();
        recurringEventDict["recurringEventMemberId"] = self.recurringEventMemberId;
        recurringEventDict["recurringEventId"] = self.recurringEventId;
        recurringEventDict["userId"] = self.userId;
        return recurringEventDict;
    }
}
