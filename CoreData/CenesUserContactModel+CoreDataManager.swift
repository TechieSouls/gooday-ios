//
//  CenesUserContactModel+CoreDataManager.swift
//  Cenes
//
//  Created by Cenes_Dev on 06/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class CenesUserContactModel {
    
    func parseUserContactFromDict(userContactDict: NSDictionary) -> CenesUserContactMO {
        
        let cenesUserContactMO = CenesUserContactMO();
        cenesUserContactMO.name = (userContactDict.value(forKey: "name") as! String);
        cenesUserContactMO.phone = (userContactDict.value(forKey: "phone") as! String);
        cenesUserContactMO.userContactId = userContactDict.value(forKey: "userContactId") as! Int32;
        cenesUserContactMO.userId = userContactDict.value(forKey: "userId") as! Int32;
        cenesUserContactMO.friendId = userContactDict.value(forKey: "friendId") as! Int32;

        return cenesUserContactMO;
    }
    
    func saveUserContacMOFromDictionary(cenesUserContact: NSDictionary) -> UserContact {
        
        let userContactId = cenesUserContact.value(forKey: "userContactId") as! Int32;
        var eventMemberAlreadyExists = false;
        
        let cenesUserContactBO = fetchUserContactsByUserContactId(userContactId: userContactId);
        
        if (cenesUserContactBO.userContactId != nil && cenesUserContactBO.userContactId == userContactId) {
            eventMemberAlreadyExists = true;
            return cenesUserContactBO;
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        if (eventMemberAlreadyExists == false) {
            
            let userContactManagedObject = CenesUserContactMO(context: context);
            
            userContactManagedObject.userContactId = cenesUserContact.value(forKey: "userContactId") as! Int32;
            
            if let userId = cenesUserContact.value(forKey: "userId") as? Int32 {
                userContactManagedObject.userId = userId;
            }
            userContactManagedObject.name = (cenesUserContact.value(forKey: "name") as! String);
            
            if let photo = cenesUserContact.value(forKey: "photo") as? String {
                userContactManagedObject.photo = photo;
            }
            if let friendId = cenesUserContact.value(forKey: "friendId") as? Int32 {
                userContactManagedObject.friendId = friendId;
            }
            userContactManagedObject.phone = (cenesUserContact.value(forKey: "phone") as! String);
            
            userContactManagedObject.cenesMember = String(cenesUserContact.value(forKey: "cenesMember") as! String);
            
            if let user = cenesUserContact.value(forKey: "user") as? NSDictionary {
                userContactManagedObject.user = CenesUserModel().saveCenesUserModel(cenesUserDict: user);
            }
            
            do {
                try context.save()
                return copyCenesUserContactMOtoUserContactBO(cenesUserContactMO: userContactManagedObject);
            } catch {
                print("Failed saving")
            }
        }
        return  UserContact();
    }
    
    func fetchAllUserContacts(user: User) -> [UserContact] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        var userContacts = [UserContact]();
        var userContactsList = [CenesUserContactMO]();
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<CenesUserContactMO> = CenesUserContactMO.fetchRequest();
        fetchRequest.predicate = NSPredicate(format: "friendId != %i", user.userId)

        do {
            let cenesContactsMO = try context.fetch(fetchRequest) 
            for userContactMO in cenesContactsMO {
                if (userContactMO.name != nil) {
                    userContactsList.append(userContactMO);
                }
            }
            
            for cenesContact in userContactsList {
                userContacts.append(copyCenesUserContactMOtoUserContactBO(cenesUserContactMO: cenesContact));
            }
            return userContacts;
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return userContacts;
    }

    
    func fetchUserContactsByUserContactId(userContactId: Int32) -> UserContact {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<CenesUserContactMO> = CenesUserContactMO.fetchRequest();
        
        // Configure Fetch Request
        fetchRequest.predicate = NSPredicate(format: "userContactId == %i", userContactId)
        do {
            let userContacts = try context.fetch(fetchRequest) 
            if (userContacts.count > 0) {
                for userCon in userContacts {
                    if (userCon.name != nil) {
                        return copyCenesUserContactMOtoUserContactBO(cenesUserContactMO: userCon);
                    }
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return UserContact();
    }
    
    func loadUserContactsMO(eventMemberArray: NSArray) -> [UserContact] {
        
        let user = User().loadUserDataFromUserDefaults(userDataDict: setting);
        var cenesUserContacts = [UserContact]();
        
        for cenesUserContactDict in eventMemberArray {
            
            let userContact = CenesUserContactModel().saveUserContacMOFromDictionary(cenesUserContact: cenesUserContactDict as! NSDictionary);
            if (userContact.friendId != nil && userContact.friendId != 0 && userContact.friendId == user.userId) {
                continue;
            }
            cenesUserContacts.append(userContact);
        }
        return cenesUserContacts;
    }


    
    func loggedInUserAsEventMember(context: NSManagedObjectContext, user: User) -> CenesUserContactMO {
        
        let entity = NSEntityDescription.entity(forEntityName: "CenesUserContactMO", in: context)
        let userContact = NSManagedObject(entity: entity!, insertInto: context) as! CenesUserContactMO

        userContact.name = user.name;
        userContact.userId = user.userId;
        userContact.friendId = user.userId;
        userContact.user = CenesUserModel().loggedInUserAsCenesUser(user: user, context: context);
        userContact.cenesMember = "yes";
        userContact.status = "Going";
        
        return userContact;

    }
    
    func deleteAllCenesUserContactMO() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CenesUserContactMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
        } catch {
            print ("There was an error")
        }
    }

    func copyCenesUserContactMOtoUserContactBO(cenesUserContactMO: CenesUserContactMO) -> UserContact {
        
        let userContact = UserContact();
        userContact.cenesMember = cenesUserContactMO.cenesMember;
        userContact.friendId = Int(cenesUserContactMO.friendId);
        userContact.name = cenesUserContactMO.name;
        userContact.phone = cenesUserContactMO.phone;
        userContact.photo = cenesUserContactMO.photo;
        userContact.status = cenesUserContactMO.status;
        userContact.userContactId = Int(cenesUserContactMO.userContactId);
        userContact.userId = Int(cenesUserContactMO.userId);
        
        if let cenesUserMO = cenesUserContactMO.user {
            userContact.user = CenesUserModel().copyManagedObjectToBO(cenesUserMO: cenesUserMO);
        }
        
        return userContact;
    }
}
