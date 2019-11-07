//
//  CenesUserMO+CoreDataProperties.swift
//  Cenes
//
//  Created by Cenes_Dev on 06/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension CenesUserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CenesUserMO> {
        return NSFetchRequest<CenesUserMO>(entityName: "CenesUserMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var userId: Int32

}
