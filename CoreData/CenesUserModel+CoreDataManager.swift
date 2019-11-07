//
//  CenesUserModel+CoreDataManager.swift
//  Cenes
//
//  Created by Cenes_Dev on 06/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class CenesUserModel {
    
    func saveCenesUserModel(cenesUserDict: NSDictionary) -> CenesUserMO {
        
        var userAlreadyExists = false;
        if let userId = cenesUserDict.value(forKey: "userId") as? Int32 {
            
            let cenesUserMo = fetchOfflineCenesUserByUserId(cenesUserId: userId);
            if (cenesUserMo.userId == userId) {
                userAlreadyExists = true;
                return updateCenesUserManagedObjectObjectFromDictionary(cenesUserDict: cenesUserDict);
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        if (userAlreadyExists == false) {
            
            let entity = NSEntityDescription.entity(forEntityName: "CenesUserMO", in: context)
            let entityModel = NSManagedObject(entity: entity!, insertInto: context) as! CenesUserMO

            if let userId = cenesUserDict.value(forKey: "userId") as? Int32 {
                entityModel.userId = Int32(userId);
            }
            
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
    
    func updateCenesUserManagedObjectObjectFromDictionary(cenesUserDict: NSDictionary) -> CenesUserMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "CenesUserMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "userId == %i", cenesUserDict.value(forKey: "userId") as! Int32);
        do {
            let cenesUserMos = try context.fetch(fetchRequest) as! [CenesUserMO];
            if (cenesUserMos.count > 0) {
                
                let cenesUserMo = cenesUserMos[0];
                
                if let userId = cenesUserDict.value(forKey: "userId") as? Int32 {
                    cenesUserMo.userId = Int32(userId);
                }
               
               //This condition is necessary if user deletes his account and he will not be available inside any event
               if let name = cenesUserDict.value(forKey: "name") as? String {
                   cenesUserMo.name = name;
               }
               if let photo = cenesUserDict.value(forKey: "photo") as? String {
                   cenesUserMo.photo = photo;
               }
               do {
                try context.save();
                   return cenesUserMo
               } catch {
                   print(error);
                   print("Failed saving CenesUserMO, func :  saveCenesUserModel")
               }
                return cenesUserMo;
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return CenesUserMO(context: context);
    }

    func fetchOfflineCenesUserByUserId(cenesUserId: Int32) -> CenesUserMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

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
    
    func deleteCenesUserModelByUserId(cenesUserId: Int32) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;
        
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
    
    func copyManagedObjectToBO(cenesUserMO: CenesUserMO) -> User {
        
        let cenesUser = User();
        cenesUser.name = cenesUserMO.name;
        cenesUser.photo = cenesUserMO.photo
        cenesUser.userId = cenesUserMO.userId;
        
        return cenesUser;
    }
    
    func copyBOToCenesUser(user: User) -> CenesUserMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let cenesUserMO = CenesUserMO(context: context);
        cenesUserMO.name = user.name;
        cenesUserMO.photo = user.photo
        cenesUserMO.userId = user.userId;
        
        return cenesUserMO;
    }

}
