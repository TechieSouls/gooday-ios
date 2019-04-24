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
    
    var createGatheringRowsOrder = [CreateGatheringRows.friendsCollectionRow, CreateGatheringRows.datePanelRow, CreateGatheringRows.predictiveInfoRow, CreateGatheringRows.predictiveCalendarRow,CreateGatheringRows.eventInfoPanelRow];
    
    var createGatheringRowsVisibility = [CreateGatheringRows.friendsCollectionRow: true, CreateGatheringRows.datePanelRow: true, CreateGatheringRows.predictiveInfoRow : false, CreateGatheringRows.predictiveCalendarRow: false, CreateGatheringRows.eventInfoPanelRow : true];
    
    var barSelected = [CreateGatheringBars.startBar: false, CreateGatheringBars.endBar: false, CreateGatheringBars.dateBar : false];
    
    var trackGatheringDataFilled = [CreateGatheringFields.titleField: false, CreateGatheringFields.startTimeField: false, CreateGatheringFields.endTimeField: false, CreateGatheringFields.locationField: false, CreateGatheringFields.messageField: false, CreateGatheringFields.imageField : false];
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
