//
//  EventCategory.swift
//  Cenes
//
//  Created by Cenes_Dev on 02/07/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
 
class EventCategory {
    
    var eventCategoryId: Int64!;
    var name: String!;
    var shortCode: String!;
    
    func loadDataFromNSDict(eventCategoriesDict: NSDictionary) -> EventCategory {
        
        var eventCategory = EventCategory();
        eventCategory.eventCategoryId = eventCategoriesDict.value(forKey: "eventCategoryId") as! Int64;
        eventCategory.name = eventCategoriesDict.value(forKey: "name") as! String;
        eventCategory.shortCode = eventCategoriesDict.value(forKey: "shortCode") as! String;
        return eventCategory;
    }
    
    func loadDataFromNSArray(eventCategoriesArr: NSArray) -> [EventCategory] {
        
        var eventCategories = [EventCategory]();
        for eventCategoryTmp in eventCategoriesArr {
            let eventCategoryDict = eventCategoryTmp as! NSDictionary;
            eventCategories.append(loadDataFromNSDict(eventCategoriesDict: eventCategoryDict));
        }
        return eventCategories;
    }
}
