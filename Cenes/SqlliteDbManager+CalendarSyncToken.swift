//
//  SqlliteDbManager+CalendarSyncToken.swift
//  Cenes
//
//  Created by Cenes_Dev on 08/04/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {

    func createTableCalendarSyncToken() {
        do {
            let calendarSyncToken = Table("calendar_sync_tokens")
            let refreshTokenId = Expression<Int64>("refresh_token_id")
            let userId = Expression<Int64>("user_id")
            let refreshToken = Expression<String>("refresh_token")
            let accountType = Expression<String>("account_type")
            let emailId = Expression<String>("email_id")

            try database.run(calendarSyncToken.create { t in
                t.column(refreshTokenId, defaultValue: 0)
                t.column(userId, defaultValue: 0)
                t.column(refreshToken, defaultValue: "")
                t.column(accountType, defaultValue: "")
                t.column(emailId, defaultValue: "")
            })
        } catch {
            print("Error in createTableCalendarSyncToken : ", error)
        }
    }

    func saveCalendarSyncToken(calendarSyncToken: CalendarSyncToken) {
     
        do {
            let cstInsertCommant = "INSERT into calendar_sync_tokens (refresh_token_id, user_id, refresh_token, account_type, email_id) VALUES (?, ?, ?, ?, ?)";
            let stmt = try database.prepare(cstInsertCommant);
            
            var refreshToken = "";
            if (calendarSyncToken.refreshToken != nil) {
                refreshToken = calendarSyncToken.refreshToken;
            }
            
            var accountType = "";
            if (calendarSyncToken.accountType != nil) {
                accountType = calendarSyncToken.accountType;
            }
            
            var emailId = "";
            if (calendarSyncToken.emailId != nil) {
                emailId = calendarSyncToken.emailId;
            }
            try stmt.run(Int64(calendarSyncToken.refreshTokenId), Int64(calendarSyncToken.userId), refreshToken,  accountType, emailId);
        } catch {
            print("Error in saveCalendarSyncToken : ", error);
        }
    }
    
    func findAllCalendarSyncToken() -> [CalendarSyncToken] {
        var calendarSyncTokens = [CalendarSyncToken]();
        do {
            
            let selectQuery = "SELECT * from calendar_sync_tokens";
            for calendarSyncTokenData in try database.prepare(selectQuery) {
                let calendarSyncToken = processSqlliteCalendarSyncTokenData(calendarSyncTokenData: calendarSyncTokenData);
                 calendarSyncTokens.append(calendarSyncToken);
            }
        } catch {
            print("Error in findAllCalendarSyncToken : ", error)
        }
        return calendarSyncTokens;
    }
    
    func findCalendarSyncTokenByAccountType(accountType: String) -> CalendarSyncToken {
     
        var calendarSyncToken: CalendarSyncToken!;
        do {
            
            let selectQuery = "SELECT * from calendar_sync_tokens where account_type = ?";
            let selectStmt = try database.prepare(selectQuery);
            for calendarSyncTokenData in try selectStmt.run(accountType) {
                calendarSyncToken = processSqlliteCalendarSyncTokenData(calendarSyncTokenData: calendarSyncTokenData);
                break;
            }
        } catch {
            print("Error in findAllCalendarSyncToken : ", error)
        }
        return calendarSyncToken;
    }
    
    func deleteCalendarSyncTokenByRefreshTokenId(refreshTokenId: Int32) {
        do {
            let deleteStmt = "DELETE from calendar_sync_tokens where refresh_token_id = ?";
            print(deleteStmt);
            let selectStmt = try database.prepare(deleteStmt);
            try selectStmt.run(Int64(refreshTokenId));
        } catch {
            print(error)
        }
    }
    
    func deleteAllCalendarSyncTokens() {
        do {
            let deleteStmt = "DELETE from calendar_sync_tokens";
            print(deleteStmt);
            let selectStmt = try database.prepare(deleteStmt);
            try selectStmt.run();
        } catch {
            print(error)
        }
    }

    
    func processSqlliteCalendarSyncTokenData(calendarSyncTokenData: Statement.Element) -> CalendarSyncToken {
        
        let calendarSyncToken = CalendarSyncToken();
        calendarSyncToken.refreshTokenId = Int32(calendarSyncTokenData[0] as! Int64);
        calendarSyncToken.userId = Int32(calendarSyncTokenData[1] as! Int64);
        calendarSyncToken.refreshToken = (calendarSyncTokenData[2] as! String);
        calendarSyncToken.accountType = (calendarSyncTokenData[3] as! String);
        calendarSyncToken.emailId = (calendarSyncTokenData[4] as! String);
        
        return calendarSyncToken;
    }
}
