//
//  Alarm+CoreDataProperties.swift
//  Cenes
//
//  Created by Chinna Addepally on 11/18/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
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
    @NSManaged public var alarmTime: NSDate?
    @NSManaged public var enabled: Bool
    @NSManaged public var sound: String?
    @NSManaged public var weekdays: [Int]?
    @NSManaged public var weekdaysName: String?
}
