//
//  FriendsModel+CoreDataProperties.swift
//  Cenes
//
//  Created by Chinna Addepally on 11/5/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension FriendsModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendsModel> {
        return NSFetchRequest<FriendsModel>(entityName: "FriendsModel")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var photoUrl: String?
    @NSManaged public var userID: Int32
    @NSManaged public var userName: String?
    @NSManaged public var reminders: RemindersModel?

}
