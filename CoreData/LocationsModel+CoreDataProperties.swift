//
//  LocationsModel+CoreDataProperties.swift
//  Cenes
//
//  Created by Chinna Addepally on 11/5/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationsModel> {
        return NSFetchRequest<LocationsModel>(entityName: "LocationsModel")
    }

    @NSManaged public var formattedAddress: String?
    @NSManaged public var latitude: Double
    @NSManaged public var locationName: String?
    @NSManaged public var longitude: Double
    @NSManaged public var reminders: RemindersModel?

}
