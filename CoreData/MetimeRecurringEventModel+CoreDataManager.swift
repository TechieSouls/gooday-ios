//
//  MetimeRecurringEventModel+CoreDataManager.swift
//  Cenes
//
//  Created by Cenes_Dev on 06/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class MetimeRecurringEventModel {
        
    func saveMetimeRecurringEventsMOFromNSArray(recurringEvents: NSArray) -> [MetimeRecurringEvent] {
        
        var recurringEventList = [MetimeRecurringEvent]();
        for recurringEvent in recurringEvents {
            recurringEventList.append(saveMetimeRecurringEventMOFromDictionary(metimeRecurringEventDict: recurringEvent as! NSDictionary));
        }
        return recurringEventList;
    }
    
    func saveMetimeRecurringEventMOFromDictionary(metimeRecurringEventDict: NSDictionary) -> MetimeRecurringEvent {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        var metimeRecurringEvent = MetimeRecurringEvent();
        
        let metimeRecurringEventMO = MetimeRecurringEventMO(context: context);
        
        metimeRecurringEventMO.recurringEventId = metimeRecurringEventDict.value(forKey: "recurringEventId") as! Int32;
        metimeRecurringEventMO.title = (metimeRecurringEventDict.value(forKey: "title") as! String);
        metimeRecurringEventMO.createdById = metimeRecurringEventDict.value(forKey: "createdById") as! Int32;
        if let startTime = metimeRecurringEventDict.value(forKey: "startTime") as? Int64 {
            metimeRecurringEventMO.startTime = startTime;
        }
        if let endTime = metimeRecurringEventDict.value(forKey: "endTime") as? Int64 {
            metimeRecurringEventMO.endTime = endTime;
        }
        if let timezone = metimeRecurringEventDict.value(forKey: "timezone") as? String {
            metimeRecurringEventMO.timezone = timezone;
        }
        if let status = metimeRecurringEventDict.value(forKey: "status") as? String {
            metimeRecurringEventMO.status = status;
        }
        if let source = metimeRecurringEventDict.value(forKey: "source") as? String {
            metimeRecurringEventMO.source = source;
        }
        if let processed = metimeRecurringEventDict.value(forKey: "processed") as? Int {
            metimeRecurringEventMO.processed = Int16(processed);
        }
        if let photo = metimeRecurringEventDict.value(forKey: "photo") as? String {
            metimeRecurringEventMO.photo = photo;
        }
        
        do {
            
            if let metimeRecurringPatterns = metimeRecurringEventDict.value(forKey: "recurringPatterns") as? NSArray {
                
                if (metimeRecurringPatterns.count > 0) {
                    
                    for metimeRecurringPattern in metimeRecurringPatterns {
                        
                        let metimeRecurringPatternDict = metimeRecurringPattern as! NSDictionary;
                        let meTimeRecurringPatternsMO = MetimeRecurringPatternModel().populateRecurringManagedObjectFromDictionary(metimeRecurringPatternDict: metimeRecurringPatternDict)
                        metimeRecurringEventMO.addToPatterns(meTimeRecurringPatternsMO);
                        
                    }

                }

            }
            try context.save();
            print(findAllMetimeRecurringEvents().count)
            metimeRecurringEvent = populateMetimeRecurringEventFromManagedObject(metimeRecurringEventMO: metimeRecurringEventMO);
            return metimeRecurringEvent;
        } catch {
            print(error, " in saveMetimeRecurringEventMOFromDictionary")
        }
        
        return metimeRecurringEvent;
    }
    
    func saveMeTimeRecurringEventFromManagedObject(metimeRecurringEventMO: MetimeRecurringEventMO) -> MetimeRecurringEventMO {
        
        let context: NSManagedObjectContext = metimeRecurringEventMO.managedObjectContext!;
        do {
            try context.save();
            return metimeRecurringEventMO;
        } catch {
            print(error);
        }
        return MetimeRecurringEventMO(context: context);
    }
    
    func findAllMetimeRecurringEvents() -> [MetimeRecurringEvent] {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        var metimeRecurringEventList = [MetimeRecurringEvent]();
        var metimeRecurringEventMOList = [MetimeRecurringEventMO]();
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<MetimeRecurringEventMO> = MetimeRecurringEventMO.fetchRequest();
        
        // Create Entity Description
        //let entityDescription = NSEntityDescription.entity(forEntityName: "MetimeRecurringEventMO", in: context)
        
        // Configure Fetch Request
        //fetchRequest.entity = entityDescription

        do {
            let metimeRecurringEventMOs = try context.fetch(fetchRequest) as! [MetimeRecurringEventMO]
            for metimeRecurringEventMO in metimeRecurringEventMOs {
                print(metimeRecurringEventMO.description)
                if (metimeRecurringEventMO.title != nil) {
                    metimeRecurringEventMOList.append(metimeRecurringEventMO);
                }
            }
            
            for metimeRecurringEventMO in metimeRecurringEventMOList {
                
                let meTimeRecurringEvent = populateMetimeRecurringEventFromManagedObject(metimeRecurringEventMO: metimeRecurringEventMO);
                metimeRecurringEventList.append(meTimeRecurringEvent);
            }
            return metimeRecurringEventList;
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return metimeRecurringEventList;
    }

    func findMeTimeRecurringEventByRecurringEventId(recurringEventId: Int32) -> MetimeRecurringEventMO {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "MetimeRecurringEventMO", in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "recurringEventId == %i", recurringEventId)

        do {
            let metimeRecurringEventMOs = try context.fetch(fetchRequest) as! [MetimeRecurringEventMO]
            for metimeRecurringEventMO in metimeRecurringEventMOs {
                if (metimeRecurringEventMO.title != nil) {
                    return metimeRecurringEventMO;
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return MetimeRecurringEventMO(context: context);
    }
        
    func deleteAllRecurringEvent() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MetimeRecurringEventMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest);
            try context.save();
        } catch {
            print ("There was an error in deleteAllRecurringEvent")
        }
    }
    
    func deleteMetimeEventByMetimeRecurringId(recurringEventId: Int32) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MetimeRecurringEventMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        deleteFetch.predicate = NSPredicate(format: "recurringEventId == %i", recurringEventId)

        do {
            try context.execute(deleteRequest)
            try context.save()

        } catch {
            print ("There was an error in deleteAllRecurringEvent")
        }
    }

    
    func convertToDictionaryFromManagedObject(metimeRecurringEventMO: MetimeRecurringEventMO) -> [String: Any] {
        
        var metimeRecurringEventDict = [String: Any]();
        metimeRecurringEventDict["userId"] = metimeRecurringEventMO.createdById;
        if (metimeRecurringEventMO.recurringEventId != 0) {
            metimeRecurringEventDict["recurringEventId"] = metimeRecurringEventMO.recurringEventId;
        }
        metimeRecurringEventDict["timezone"] = TimeZone.current.identifier;

        var metimeRecurringPatternList = [[String: Any]]();
        for metimeRecurringPattern in metimeRecurringEventMO.patterns! {
            let metimeRecurringPatternMO = metimeRecurringPattern as! MeTimeRecurringPatternMO;
            metimeRecurringPatternList.append(MetimeRecurringPatternModel().convertMetimeRecurringPatternMOToDictionary(metimeRecurringEventMO: metimeRecurringEventMO, meTimeRecurringPatternMO: metimeRecurringPatternMO));
        }
        metimeRecurringEventDict["events"] = metimeRecurringPatternList;
        return metimeRecurringEventDict;
    }
    
    func populateMetimeRecurringEventFromManagedObject(metimeRecurringEventMO: MetimeRecurringEventMO) -> MetimeRecurringEvent {
        
        let metimeRecurringEvent  = MetimeRecurringEvent();
        metimeRecurringEvent.createdById = metimeRecurringEventMO.createdById;
        metimeRecurringEvent.title = metimeRecurringEventMO.title;
        metimeRecurringEvent.startTime = metimeRecurringEventMO.startTime;
        metimeRecurringEvent.endTime = metimeRecurringEventMO.endTime;
        metimeRecurringEvent.photo = metimeRecurringEventMO.photo;
        metimeRecurringEvent.processed = Int(metimeRecurringEventMO.processed);
        metimeRecurringEvent.recurringEventId = metimeRecurringEventMO.recurringEventId;
        metimeRecurringEvent.source = metimeRecurringEventMO.source;
        metimeRecurringEvent.status = metimeRecurringEventMO.status;
        
        if let metimeRecurringPattersNsset = metimeRecurringEventMO.patterns {
            metimeRecurringEvent.patterns = [MeTimeRecurringPattern]();
            for metimeRecurringPattern in metimeRecurringPattersNsset {
                
                let metimeRecurringPatternMO = metimeRecurringPattern as! MeTimeRecurringPatternMO;
                
                let meTimerecurringPattern = MeTimeRecurringPattern();
                meTimerecurringPattern.dayOfWeek = Int(metimeRecurringPatternMO.dayOfWeek);
                meTimerecurringPattern.dayOfWeekTimestamp = metimeRecurringPatternMO.dayOfWeekTimestamp;
                meTimerecurringPattern.recurringPatternId = metimeRecurringPatternMO.recurringPatternId;
                meTimerecurringPattern.slotsGeneratedUpto = metimeRecurringPatternMO.slotsGeneratedUpto;
                meTimerecurringPattern.slotsGeneratedUpto = metimeRecurringPatternMO.slotsGeneratedUpto;
                metimeRecurringEvent.patterns.append(meTimerecurringPattern);
                
            }
        }
        return metimeRecurringEvent;
    }
    
    func updatePhoto(recurringEventId: Int32, photoUrl: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "MetimeRecurringEventMO", in: context)

        fetchRequest.entity = entityDescription
        fetchRequest.predicate = NSPredicate(format: "recurringEventId == %i", recurringEventId)

        do {
            let metimeRecurringEventMOs = try context.fetch(fetchRequest) as! [MetimeRecurringEventMO]
            let metimeRecurringEventMO = metimeRecurringEventMOs[0];
            metimeRecurringEventMO.photo = photoUrl;
            
        } catch {
            print ("There was an error in deleteAllRecurringEvent")
        }

    }
}
