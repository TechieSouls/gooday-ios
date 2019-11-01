//
//  MetimeRecurringEventMO+CoreDataProperties.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/10/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension MetimeRecurringEventMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MetimeRecurringEventMO> {
        return NSFetchRequest<MetimeRecurringEventMO>(entityName: "MetimeRecurringEventMO")
    }

    @NSManaged public var createdById: Int32
    @NSManaged public var endTime: Int64
    @NSManaged public var photo: String?
    @NSManaged public var photoBInary: Data?
    @NSManaged public var processed: Int16
    @NSManaged public var recurringEventId: Int32
    @NSManaged public var source: String?
    @NSManaged public var startTime: Int64
    @NSManaged public var status: String?
    @NSManaged public var timezone: String?
    @NSManaged public var title: String?
    @NSManaged public var patterns: NSSet?

}

// MARK: Generated accessors for patterns
extension MetimeRecurringEventMO {

    @objc(addPatternsObject:)
    @NSManaged public func addToPatterns(_ value: MeTimeRecurringPatternMO)

    @objc(removePatternsObject:)
    @NSManaged public func removeFromPatterns(_ value: MeTimeRecurringPatternMO)

    @objc(addPatterns:)
    @NSManaged public func addToPatterns(_ values: NSSet)

    @objc(removePatterns:)
    @NSManaged public func removeFromPatterns(_ values: NSSet)

}
