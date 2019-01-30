//
//  ReminderData.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 8/2/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import Foundation
class ReminderData:NSObject
{
    var name:String
    var dateStr:String?
    init(name:String) {
        self.name = name
    }
}

var reminderDataDetail = [ReminderData]()

struct CalendarObjects {
    
    var sectionName : String!
    var sectionObjects : [CalendarData]!
    
}
struct CalendarData
{
    var title:String
    var subTitle :String?
    var image1:String?
    var image2:String?
    var image3:String?
    var dataType :String
    var time : String
    var eventImage : String?
    var eventId : String?
}


class CenesEvent : NSObject {
    var sectionName : String!
    var sectionObjects : [CenesCalendarData]!
}


class CenesCalendarData : NSObject {
    var title:String!
    var subTitle :String!
    var locationStr: String!
    var eventUsers = [CenesUser]()
    var dataType :String!
    var time : String!
    var startTimeMillisecond : NSNumber!
    var endTimeMillisecond : NSNumber!
    var eventImageURL : String!
    var eventImage : UIImage!
    var eventId : String!
    var scheduleAs : String!
    var dateValue : String!
    var senderName : String!
    var eventMemberId : String!
    var source : String!
    var endTime : String!
    var eventDescription : String!
    var locationModel : LocationModel!
    var isFullDay: Bool!
}
