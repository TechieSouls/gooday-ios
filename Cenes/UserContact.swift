//
//  UserContact.swift
//  Deploy
//
//  Created by Macbook on 18/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class UserContact {
    
    var name: String!;
    var userContactId: Int!;
    var photo: String!
    var userId: Int!;
    var cenesMember: String!;
    var status: String!;
    var phone: String!;
    
    func loadUserContact(userContactDic: NSDictionary) -> UserContact {
        let userContact = UserContact();
        
        userContact.userContactId = userContactDic.value(forKey: "userContactId") as? Int;
        userContact.name = userContactDic.value(forKey: "name") as? String;
        userContact.cenesMember = userContactDic.value(forKey: "cenesMember") as? String;
        userContact.phone = userContactDic.value(forKey: "phone") as? String;
        
        if let user = userContactDic.value(forKey: "user") as? NSDictionary {
            
            if let photo = user.value(forKey: "photo") as? String {
                userContact.photo = photo;
            }
            userContact.userId = user.value(forKey: "userId") as! Int;
        }
        return userContact;
    }
    
    func loadUserContactList(userContactArray: NSArray) -> [UserContact] {
        
        var userContacts: [UserContact] = [];
        for userContactDict in userContactArray {
            
            let userContact: UserContact = self.loadUserContact(userContactDic: userContactDict as! NSDictionary);
            userContacts.append(userContact);
        }
        return userContacts;
    }
    
    func filtered(userContacts: [UserContact], predicate: String) -> [UserContact] {
    
        var userContactsToReturn: [UserContact] = [];
        for userContact in userContacts {
            
            if (userContact.name.starts(with: predicate)) {
                userContactsToReturn.append(userContact);
            }
        }
        return userContactsToReturn;
    }
    
}
