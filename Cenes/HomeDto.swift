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
    
    var pastEvents = [HomeData]();
    var calendarData = [HomeData]();
    var acceptedGatherings = [HomeData]();
    var pendingGatherings = [HomeData]();
    var declinedGatherings = [HomeData]();
    var pageable = HomeDataPageNumbers();
    var timeStamp: Int = Int(Date().millisecondsSince1970);
    var timestampForInvitationTabs: Int = Int(Date().millisecondsSince1970);
    var calendarEventsData: CalendarEventsData = CalendarEventsData();
    var allCalendarTabEvents = [Event]();
    var allPastEvents = [Event]();

    //This is needed for scrolling home screen to desired index.
    //So we will store the month scroll details in it.
    var scrollToMonthStartSectionAtHomeButton = [MonthScrollDto]();
    var scrollToSectionSectionAtHomeButtonIndexNumber: Int = 0;
    
    var monthScrollIndex: [String: MonthScrollDto] = [String: MonthScrollDto]();
    var monthTrackerForDataLoad = [String]();
    
    //This is to hold the title for home screen.
    //Whenever user scrolls page, we will change the title based on the month
    //At which he is at present.
    var topHeaderDateIndex = [String: MonthScrollDto]();
    
    var pageableMonthTimestamp: Int = 0; //This is needed to track which moth is there in calendar scroll
    var pageableMonthToAdd: Int = 0;    //This is needed to add 1 to cuttent month
    var totalEventsList = [Int32]();   //This is needed to mark the total events
    var timestampForTopHeader: Int = Int(Date().millisecondsSince1970);

    var currentMonthStartDateTimeStamp: Int = Int(Date().startOfMonth().millisecondsSince1970);
    
    //This is needed to keep track of month Separaotors added
    //So thet ther wont be multiple separators in same month.
    //When you scroll down to get next 20 events, There may be chance same month events
    //are fetched and month separator can be added again.
    var monthSeparatorList = [String]();
    var fsCalendarCurrentDateTimestamp: Int = Int(Date().millisecondsSince1970); //This is needed to track fscalendar scroll
    var startTimeStampToFetchPageableData: Int = Int(Date().millisecondsSince1970); //This is needed to track fscalendar scroll

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
    var year: String!;
    var month: String!;
    var sectionKeyInMillis: Int64!;
    var sectionName: String!;
    var sectionNameWithYear: String!;
    var sectionObjects = [Event]();
}

class HomeScreenDataHolder {
    var homeDataList: [HomeData]!;
    var eventIdList: [Int32]!;
    var homescreenDto: HomeDto!;
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
    var calendarDataOffset = 30;
    var totalCalendarCounts: Int = 0;

}

class MonthScrollDto {
    
    var indexKey : String = "";
    var month: Int = 0;
    var year: Int = 0;
    var timestamp: Int = 0;
}

class HomeScrollType {
    static var PAGESCROLL: String = "PageScroll";
    static var CALENDARSCROLL: String = "CalendarScroll";

}
