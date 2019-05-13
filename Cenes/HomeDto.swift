//
//  HomeDto.swift
//  Deploy
//
//  Created by Cenes_Dev on 10/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class HomeDto {
    
    var headerTabsActive: String = HomeHeaderTabs.CalendarTab;
    var homeRowsVisibility = [HomeRows.TopDateRow: true, HomeRows.ThreeTabs: false, HomeRows.CalendarRow: false, HomeRows.TableRow: true];
    var calendarArrowPressed: Bool = false;
    
    //var invitationTabs = [HomeInvitationTabs.Accepted: true, HomeInvitationTabs.Pending: false, HomeInvitationTabs.Declined: false];
    var invitationTabs: String = HomeInvitationTabs.Accepted;
    
    var calendarData = [HomeData]();
    var acceptedGatherings = [HomeData]();
    var pendingGatherings = [HomeData]();
    var declinedGatherings = [HomeData]();
    var pageable = HomeDataPageNumbers();
    var timeStamp: Int = Int(Date().millisecondsSince1970);
    var calendarEventsData: CalendarEventsData = CalendarEventsData();
}

class HomeHeaderTabs {
    static let CalendarTab = "Calendar";
    static let InvitationTab = "Invitation";
}

class HomeRows {
    static let TopDateRow = "TopDateRow"
    static let ThreeTabs = "ThreeTabs"
    static let CalendarRow = "CalendarRow"
    static let TableRow = "TableRow"
}

class HomeRowsHeight {
    static let TopDateRowHeight: CGFloat = 50
    static let ThreeTabsRowHeight: CGFloat = 50
    static let CalendarRowHeight: CGFloat = 370
}

class HomeInvitationTabs {
    static let Accepted = "Accepted";
    static let Pending = "Pending";
    static let Declined = "Declined";
}

class HomeData {
    var monthName: String!;
    var sectionName: String!;
    var sectionObjects = [Event]();
}

class CalendarEventsData {
    
    var eventDates : [String] = [String]();
    var holidayDates : [String] = [String]();
}

class HomeDataPageNumbers {
    
    var acceptedGathetingPageNumber = 0;
    var acceptedGatheringOffset = 20;
    var totalAcceptedCounts = 0;
    
    var declinedGathetingPageNumber = 0;
    var declinedGatheringOffset = 20;
    var totalDeclinedCounts = 0;

    var pendingGathetingPageNumber = 0;
    var pendingGatheringOffset = 20;
    var totalPendingCounts = 0;

    var calendarDataPageNumber = 0;
    var calendarDataOffset = 20;
    var totalCalendarCounts = 0;

}
