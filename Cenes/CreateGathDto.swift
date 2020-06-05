//
//  CreateGathDto.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class CreateGathDto {
    
    var timeMatchIconOn : Bool = false;
    var availableFriendsList: String = "";
    var createGatheringRowsOrder = [CreateGatheringRows.friendsCollectionRow, CreateGatheringRows.datePanelRow, CreateGatheringRows.predictiveInfoRow, CreateGatheringRows.predictiveCalendarRow,CreateGatheringRows.eventInfoPanelRow];
    
    var createGatheringRowsVisibility = [CreateGatheringRows.friendsCollectionRow: true, CreateGatheringRows.datePanelRow: true, CreateGatheringRows.predictiveInfoRow : false, CreateGatheringRows.predictiveCalendarRow: false, CreateGatheringRows.eventInfoPanelRow : true];
    
    var barSelected = [CreateGatheringBars.startBar: false, CreateGatheringBars.endBar: false, CreateGatheringBars.dateBar : false];
    
    var trackGatheringDataFilled = [CreateGatheringFields.titleField: false, CreateGatheringFields.startTimeField: false, CreateGatheringFields.endTimeField: false, CreateGatheringFields.dateField: false, CreateGatheringFields.locationField: false, CreateGatheringFields.messageField: false, CreateGatheringFields.imageField : false];
    
    var originalEventStartTime: Int64 = Date().millisecondsSince1970;
    var originalEventEndTime: Int64 = Date().millisecondsSince1970;

}

class CreateGatheringRows {
    static let friendsCollectionRow = "FriendCollection";
     static let predictiveInfoRow = "PredictiveInfo";
     static let datePanelRow = "DatePanel";
     static let eventInfoPanelRow = "EventInfo";
     static let predictiveCalendarRow = "PredictiveCalendar";
}

class CreateGatheringBars {
    static let startBar = "StartBar";
    static let endBar = "EndBar";
    static let dateBar = "DateBar";
}

class CreateGatheringFields {
    static let titleField = "Title";
    static let startTimeField = "StartTime";
    static let endTimeField = "EndTime";
    static let dateField = "Date";
    static let locationField = "Location";
    static let messageField = "Message";
    static let imageField = "Image";
}

class CreateGatheringPredictiveColors {
    static var PINKCOLOR = UIColor(red:0.98, green:0.45, blue:0.41, alpha:1);
    static var GREENCOLOR = UIColor(red:0.31, green:0.78, blue:0.47, alpha:1);
    static var REDCOLOR = UIColor(red:0.93, green:0.16, blue:0.22, alpha:1);
    static var LIMECOLOR = UIColor(red:0.98, green:0.85, blue:0.37, alpha:1);
    static var GRAYCOLOR = UIColor(red:0.86, green:0.87, blue:0.87, alpha:1);

}

class FSCalendarElements {
    var month: Int = 0;
    var year: Int = 0;
}
