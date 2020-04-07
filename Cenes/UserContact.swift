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
    var cenesName: String!;
    var userContactId: Int!;
    var photo: String!
    var userId: Int!;
    var friendId: Int!;
    var cenesMember: String!;
    var status: String!;
    var phone: String!;
    var user: User!;
    var eventMemberId: Int32!; //This is needed when editing post and adding new guests
    
    func loadUserContact(userContactDic: NSDictionary) -> UserContact {
        let userContact = UserContact();
        
        userContact.userContactId = userContactDic.value(forKey: "userContactId") as? Int;
        userContact.name = userContactDic.value(forKey: "name") as? String;
        userContact.cenesMember = userContactDic.value(forKey: "cenesMember") as? String;
        userContact.phone = userContactDic.value(forKey: "phone") as? String;
        userContact.friendId = userContactDic.value(forKey: "friendId") as? Int; //This is the actual cenes id of user

        if let user = userContactDic.value(forKey: "user") as? NSDictionary {
            
            userContact.cenesName = user.value(forKey: "name") as! String;
            if let photo = user.value(forKey: "photo") as? String {
                userContact.photo = photo;
            }
            
            userContact.userId = user.value(forKey: "userId") as! Int;
            userContact.user = User().loadUserData(userDataDict: user);
        }
        return userContact;
    }
    
    func loadUserContactList(userContactArray: NSArray) -> [UserContact] {
        let user = User().loadUserDataFromUserDefaults(userDataDict: setting);

        var phonenNumberDuplicacyChecker = [String]();
        var userContacts: [UserContact] = [];
        for userContactDict in userContactArray {
            
            let userContact: UserContact = self.loadUserContact(userContactDic: userContactDict as! NSDictionary);
            
            //Removing own user from list.
            if (userContact.friendId != nil && userContact.friendId != 0 && userContact.friendId == user.userId) {
                continue;
            }
            if (phonenNumberDuplicacyChecker.contains(userContact.phone)) {
                continue;
            }
            
            phonenNumberDuplicacyChecker.append(userContact.phone);
            userContacts.append(userContact);
        }
        return userContacts;
    }
    
    func filtered(userContacts: [UserContact], predicate: String) -> [UserContact] {
    
        var userContactsToReturn: [UserContact] = [];
        for userContact in userContacts {
            
            if (userContact.user != nil && userContact.cenesName.lowercased().starts(with: predicate.lowercased())) {
                userContactsToReturn.append(userContact);
            } else if (userContact.name != nil && userContact.name.lowercased().starts(with: predicate.lowercased())) {
                userContactsToReturn.append(userContact);
            }
        }
        return userContactsToReturn;
    }
    
    func filteredByCenesName(userContacts: [UserContact], predicate: String) -> [UserContact] {
    
        var userContactsToReturn: [UserContact] = [];
        for userContact in userContacts {
            
            if (userContact.cenesName != nil && userContact.cenesName.lowercased().starts(with: predicate.lowercased())) {
                userContactsToReturn.append(userContact);
            }
        }
        return userContactsToReturn;
    }
    
}
