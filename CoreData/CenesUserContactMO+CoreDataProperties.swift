//
//  CenesUserContactMO+CoreDataProperties.swift
//  Deploy
//
//  Created by Cenes_Dev on 17/10/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension CenesUserContactMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CenesUserContactMO> {
        return NSFetchRequest<CenesUserContactMO>(entityName: "CenesUserContactMO")
    }

    @NSManaged public var cenesMember: String?
    @NSManaged public var friendId: Int32
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var photo: String?
    @NSManaged public var status: String?
    @NSManaged public var userContactId: Int32
    @NSManaged public var userId: Int32
    @NSManaged public var user: CenesUserMO?

}
