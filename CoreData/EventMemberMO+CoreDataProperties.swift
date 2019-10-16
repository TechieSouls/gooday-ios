//
//  EventMemberMO+CoreDataProperties.swift
//  Deploy
//
//  Created by Cenes_Dev on 11/10/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension EventMemberMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventMemberMO> {
        return NSFetchRequest<EventMemberMO>(entityName: "EventMemberMO")
    }

    @NSManaged public var alreadyInvited: Bool
    @NSManaged public var cenesMember: String?
    @NSManaged public var eventMemberId: Int32
    @NSManaged public var name: String?
    @NSManaged public var owner: Bool
    @NSManaged public var phone: String?
    @NSManaged public var photo: String?
    @NSManaged public var status: String?
    @NSManaged public var userContactId: Int32
    @NSManaged public var userId: Int32
    @NSManaged public var user: CenesUserMO?
    @NSManaged public var userContact: CenesUserContactMO?

}
