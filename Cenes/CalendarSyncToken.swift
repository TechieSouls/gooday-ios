//
//  File.swift
//  Deploy
//
//  Created by Cenes_Dev on 15/05/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
class CalendarSyncToken {
    
    var refreshTokenId: Int32!
    var userId: Int32!
    var refreshToken: String!
    var accountType: String!
    var emailId: String!;
    
    func loadCalendarSyncToken(calendarSyncTokenDict: NSDictionary) -> CalendarSyncToken {
        
        let calendarSyncToken = CalendarSyncToken();
        calendarSyncToken.refreshTokenId = calendarSyncTokenDict.value(forKey: "refreshTokenId") as! Int32;
        calendarSyncToken.userId = calendarSyncTokenDict.value(forKey: "userId") as! Int32;
        calendarSyncToken.refreshToken = calendarSyncTokenDict.value(forKey: "refreshToken") as? String ?? nil;
        calendarSyncToken.accountType = calendarSyncTokenDict.value(forKey: "accountType") as! String;
        calendarSyncToken.emailId = calendarSyncTokenDict.value(forKey: "emailId") as? String ?? nil;
        
        return calendarSyncToken;
    }
    
    func loadCalendarSyncTokens(calendarSyncTokenArray: NSArray) -> [CalendarSyncToken] {
        
        var calendarSyncTokens = [CalendarSyncToken]();
        for calendarSyncToken in  calendarSyncTokenArray {
            let calendarSyncTokenDict = calendarSyncToken as! NSDictionary;
            calendarSyncTokens.append(loadCalendarSyncToken(calendarSyncTokenDict: calendarSyncTokenDict));
        }
        return calendarSyncTokens;
    }
}
