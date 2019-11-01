//
//  EventMO+CoreDataProperties.swift
//  Deploy
//
//  Created by Cenes_Dev on 29/08/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension EventMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventMO> {
        return NSFetchRequest<EventMO>(entityName: "EventMO")
    }

    @NSManaged public var createdById: Int32
    @NSManaged public var desc: String?
    @NSManaged public var endTime: Int64
    @NSManaged public var eventId: Int32
    @NSManaged public var eventPicture: String?
    @NSManaged public var eventSource: String?
    @NSManaged public var expired: Bool
    @NSManaged public var isFullDay: Bool
    @NSManaged public var key: String?
    @NSManaged public var latitude: String?
    @NSManaged public var location: String?
    @NSManaged public var longitude: String?
    @NSManaged public var scheduleAs: String?
    @NSManaged public var startTime: Int64
    @NSManaged public var thumbnail: String?
    @NSManaged public var title: String?
    @NSManaged public var eventMembers: NSSet?

}

// MARK: Generated accessors for eventMembers
extension EventMO {

    @objc(addEventMembersObject:)
    @NSManaged public func addToEventMembers(_ value: EventMO)

    @objc(removeEventMembersObject:)
    @NSManaged public func removeFromEventMembers(_ value: EventMO)

    @objc(addEventMembers:)
    @NSManaged public func addToEventMembers(_ values: NSSet)

    @objc(removeEventMembers:)
    @NSManaged public func removeFromEventMembers(_ values: NSSet)

}
