//
//  CenesUserContactModel.swift
//  Deploy
//
//  Created by Cenes_Dev on 08/10/2019.
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
    
    func saveUserContacMOFromDictionary(cenesUserContact: NSDictionary, context: NSManagedObjectContext) -> CenesUserContactMO {
        
        let userContactId = cenesUserContact.value(forKey: "userContactId") as! Int32;
        var eventMemberAlreadyExists = false;
        let cenesUserContactMO = fetchUserContactsByUserContactId(context: context, userContactId: userContactId);
        
        if (cenesUserContactMO.userContactId == userContactId) {
            eventMemberAlreadyExists = true;
            return cenesUserContactMO;
        }
        if (eventMemberAlreadyExists == false) {
            
            let entity = NSEntityDescription.entity(forEntityName: "CenesUserContactMO", in: context)
            let userContactManagedObject = NSManagedObject(entity: entity!, insertInto: context) as! CenesUserContactMO
            
            userContactManagedObject.userContactId = cenesUserContact.value(forKey: "userContactId") as! Int32;
            if let userId = cenesUserContact.value(forKey: "userId") as? Int32 {
                userContactManagedObject.userId = userId;
            }
            userContactManagedObject.name = (cenesUserContact.value(forKey: "name") as! String);
            if let photo = cenesUserContact.value(forKey: "photo") as? String {
                userContactManagedObject.photo = photo;
            }
            if let friendId = cenesUserContact.value(forKey: "phone") as? Int32 {
                userContactManagedObject.friendId = friendId;
            }
            userContactManagedObject.phone = (cenesUserContact.value(forKey: "phone") as! String);
            userContactManagedObject.cenesMember = (cenesUserContact.value(forKey: "cenesMember") as! String);
            do {
                try context.save()
                return userContactManagedObject;
            } catch {
                print("Failed saving")
            }
        }
        let entity = NSEntityDescription.entity(forEntityName: "CenesUserContactMO", in: context)
        return  NSManagedObject(entity: entity!, insertInto: context) as! CenesUserContactMO
    }
    
    func fetchAllUserContacts(context: NSManagedObjectContext, user: User) -> [CenesUserContactMO] {
        
        var userContactsList = [CenesUserContactMO]();
        
        let entity = NSEntityDescription.entity(forEntityName: "CenesUserContactMO", in: context)
        var userContact = NSManagedObject(entity: entity!, insertInto: context) as! CenesUserContactMO
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "CenesUserContactMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "friendId != %i", user.userId)

        do {
            let cenesContacts = try context.fetch(fetchRequest) as! [CenesUserContactMO]
            for userContact in cenesContacts {
                if (userContact.name != nil) {
                    userContactsList.append(userContact);
                }
            }
            return userContactsList;
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return [CenesUserContactMO]();
    }

    
    func fetchUserContactsByUserContactId(context: NSManagedObjectContext, userContactId: Int32) -> CenesUserContactMO {
        
        let entity = NSEntityDescription.entity(forEntityName: "CenesUserContactMO", in: context)
        let userContact = NSManagedObject(entity: entity!, insertInto: context) as! CenesUserContactMO
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "CenesUserContactMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "userContactId == %i", userContactId)
        do {
            let userContacts = try context.fetch(fetchRequest) as! [CenesUserContactMO]
            if (userContacts.count > 0) {
                for userCon in userContacts {
                    if (userCon.name != nil) {
                        return userCon;
                    }
                }
                return userContacts[0];
            }
            return userContact;
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return userContact;
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
    
    func deleteAllCenesUserContactMO(context: NSManagedObjectContext) {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CenesUserContactMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

}
