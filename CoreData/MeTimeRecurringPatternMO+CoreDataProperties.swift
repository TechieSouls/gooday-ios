//
//  MeTimeRecurringPatternMO+CoreDataProperties.swift
//  Deploy
//
//  Created by Cenes_Dev on 18/10/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension MeTimeRecurringPatternMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeTimeRecurringPatternMO> {
        return NSFetchRequest<MeTimeRecurringPatternMO>(entityName: "MeTimeRecurringPatternMO")
    }

    @NSManaged public var recurringPatternId: Int32
    @NSManaged public var dayOfWeek: Int16
    @NSManaged public var dayOfWeekTimestamp: Int64
    @NSManaged public var slotsGeneratedUpto: Int64

}
