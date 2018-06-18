//
//  ReminderModel.swift
//  Cenes
//
//  Created by Chinna Addepally on 10/27/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class ReminderModel: NSObject {
    var category: String!
    var location: String!
    var status: String!
    var title: String!
    var createdByID: NSNumber!
    var reminderID: NSNumber!
    var reminderMembers:[String]! = []
    var reminderTime: NSNumber!
    var friends: [CenesUser] = []
}
