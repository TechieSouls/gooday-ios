//
//  CenesUserModel+CoreDataManager.swift
//  Deploy
//
//  Created by Cenes_Dev on 04/10/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class CenesUserModel {
    
    func saveCenesUserModel(cenesUserDict: NSDictionary) -> CenesUserMO {
        
        var userAlreadyExists = false;
        let cenesUserMo = fetchOfflineCenesUserByUserId(cenesUserId: cenesUserDict.value(forKey: "userId") as! Int32);
        
        if (cenesUserMo.userId == cenesUserDict.value(forKey: "userId") as! Int32) {
            userAlreadyExists = true;
            return cenesUserMo;
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        if (userAlreadyExists == false) {
            
            let entity = NSEntityDescription.entity(forEntityName: "CenesUserMO", in: context)
            let entityModel = NSManagedObject(entity: entity!, insertInto: context) as! CenesUserMO

            entityModel.userId = Int32(cenesUserDict.value(forKey: "userId") as! Int64);
            
            //This condition is necessary if user deletes his account and he will not be available inside any event
            if let name = cenesUserDict.value(forKey: "name") as? String {
                entityModel.name = name;
            }
            if let photo = cenesUserDict.value(forKey: "photo") as? String {
                entityModel.photo = photo;
            }
            do {
                try context.save()
                return entityModel
            } catch {
                print(error);
                print("Failed saving CenesUserMO, func :  saveCenesUserModel")
            }
        }
        
        //let entity = NSEntityDescription.entity(forEntityName: "CenesUserMO", in: context)
        //let entityModel = NSManagedObject(entity: entity!, insertInto: context) as! CenesUserMO
        return CenesUserMO(context: context);
    }

    func fetchOfflineCenesUserByUserId(cenesUserId: Int32) -> CenesUserMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let entity = NSEntityDescription.entity(forEntityName: "CenesUserMO", in: context)
        let entityModel = NSManagedObject(entity: entity!, insertInto: context) as! CenesUserMO
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "CenesUserMO", in: context)

        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "userId == %i", cenesUserId)
        do {
            let cenesUsers =  try context.fetch(fetchRequest) as! [CenesUserMO]
            for cenesUser in cenesUsers {
                if (cenesUser.name != nil) {
                    return cenesUser;
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return CenesUserMO(context: context);
    }
    
    func deleteCenesUserModelByUserId(context: NSManagedObjectContext, cenesUserId: Int32) {
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CenesUserMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        deleteFetch.predicate = NSPredicate(format: "userId == %i", cenesUserId);
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func deleteAllCenesUserModel() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CenesUserMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }

    func loggedInUserAsCenesUser(user: User, context: NSManagedObjectContext) -> CenesUserMO {
        
        let entityModel = CenesUserMO(context: context);
        entityModel.userId = user.userId;
        entityModel.name =  user.name;
        entityModel.photo = user.photo;
        return entityModel;

    }
}
