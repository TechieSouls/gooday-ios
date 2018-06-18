//
//  RemindersModel+CoreDataProperties.swift
//  Cenes
//
//  Created by Chinna Addepally on 11/5/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension RemindersModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RemindersModel> {
        return NSFetchRequest<RemindersModel>(entityName: "RemindersModel")
    }

    @NSManaged public var category: String?
    @NSManaged public var createdByID: Int32
    @NSManaged public var reminderID: Int32
    @NSManaged public var reminderLocalID: Int32
    @NSManaged public var reminderTime: NSDate?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var friends: NSSet?
    @NSManaged public var location: LocationsModel?

}

// MARK: Generated accessors for friends
extension RemindersModel {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: FriendsModel)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: FriendsModel)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}
