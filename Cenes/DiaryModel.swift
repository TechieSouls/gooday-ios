//
//  DiaryModel.swift
//  Cenes
//
//  Created by Redblink on 15/11/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit

class DiaryModel: NSObject {
    var sectionName : String!
    var sectionObjects : [DiaryData]!
}


class DiaryData: NSObject {
    var title:String!
    var locationName :String!
    var eventUsers = [CenesUser]()
    var dataType :String!
    var diaryTimeString : String!
    var diaryTime : NSNumber!
    var eventImageURL : String!
    var eventImage : UIImage!
    var diaryId : String!
    var scheduleAs : String!
    var dateValue : String!
    var senderName : String!
    var createdById : String!
    var source : String!
    var endTime : String!
    var diaryDetail : String!
    var diaryPhotoModel = [PhotoModel]()
}

class PhotoModel : NSObject{
    var diaryPhotoUrl : String!
    var diaryPhoto : UIImage!
}
