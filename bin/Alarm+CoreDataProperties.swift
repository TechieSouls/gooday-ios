//
//  Alarm+CoreDataProperties.swift
//  
//
//  Created by Chinna Addepally on 10/24/17.
//
//

import Foundation
import CoreData


extension Alarm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Alarm> {
        return NSFetchRequest<Alarm>(entityName: "Alarm")
    }

    @NSManaged public var alarmID: Int16
    @NSManaged public var alarmName: String?
    @NSManaged public var enabled: Bool
    @NSManaged public var sound: String?
    @NSManaged public var weekdays: String?
    @NSManaged public var weekdaysName: String?

}
