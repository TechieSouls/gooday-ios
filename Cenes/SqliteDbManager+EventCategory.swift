//
//  SqliteDbManager+EventCategory.swift
//  Cenes
//
//  Created by Cenes_Dev on 02/07/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {

    func createTableEventCategory() {
        do {
            let eventCategories = Table("event_categories")
            let eventCategoryId = Expression<Int64>("event_category_id")
            let name = Expression<String?>("name")
            let shortCode = Expression<String?>("short_code")

            try database.run(eventCategories.create { t in
                t.column(eventCategoryId, defaultValue: 0)
                t.column(name, defaultValue: "")
                t.column(shortCode, defaultValue: "")
            })
        } catch {
            print("Create eventCategories Table Error", error)
        }
    }
    
    func saveEventCategories(eventCategory: EventCategory) {
        
        do {
            let stmt = try database.prepare("INSERT into event_categories (event_category_id, name, short_code) VALUES (?, ?, ?)");
            
            try stmt.run(eventCategory.eventCategoryId, eventCategory.name, eventCategory.shortCode);
            
        } catch {
            print("Error in saveEventCategories : ", error)
        }
    }
    
    func findAllEventCategories() -> [EventCategory] {
        
        var eventCategories = [EventCategory]();
        do {
            for eventCategoryDB in try database.prepare("SELECT * from event_categories") {
                let eventCategory = EventCategory();
                eventCategory.eventCategoryId = (eventCategoryDB[0] as! Int64);
                eventCategory.name = eventCategoryDB[1] as? String;
                eventCategory.shortCode = eventCategoryDB[2] as? String;
                eventCategories.append(eventCategory);
            }
        } catch {
            print("Error in findAllEventCategories : ", error)
        }
        return eventCategories;
    }

    func findEventCategoryByEventCategoryId(eventCategoryId: Int32) -> EventCategory {
        
        let eventCategory = EventCategory();
        do {
            let stmt = try database.prepare("SELECT * from event_categories where event_category_id = ?");
            for eventCategoryDB in try stmt.run(Int64(eventCategoryId)) {
                eventCategory.eventCategoryId = (eventCategoryDB[0] as! Int64);
                eventCategory.name = eventCategoryDB[1] as? String;
                eventCategory.shortCode = eventCategoryDB[2] as? String;
            }
        } catch {
            print("Error in findEventCategoryByEventCategoryId : ", error)
        }
        return eventCategory;
    }

    
    func deleteAllEventCategories() {
        
        do {
            let stmt = try database.prepare("delete from event_categories");
            try stmt.run();

        } catch {
            print("Error in deleteAllEventCategories : ", error)
        }
    }
}

