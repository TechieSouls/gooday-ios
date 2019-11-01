//
//  NotificationMO+CoreDataProperties.swift
//  Cenes
//
//  Created by Cenes_Dev on 14/10/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension NotificationMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NotificationMO> {
        return NSFetchRequest<NotificationMO>(entityName: "NotificationMO")
    }

    @NSManaged public var action: String?
    @NSManaged public var createdAt: Int64
    @NSManaged public var message: String?
    @NSManaged public var notificationId: Int32
    @NSManaged public var notificationTypeId: Int32
    @NSManaged public var notificationTypeStatus: String?
    @NSManaged public var readStatus: String?
    @NSManaged public var recepientId: Int32
    @NSManaged public var senderId: Int32
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var event: NotificationMO?
    @NSManaged public var user: CenesUserMO?

}
