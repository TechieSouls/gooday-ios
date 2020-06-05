//
//  SqlliteDbManager+SplashRecords.swift
//  Cenes
//
//  Created by Cenes_Dev on 29/04/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {

    func createTableSplashRecords() {
        do {
            let splashRecords = Table("splash_records")
            let splashRecordId = Expression<Int64>("splash_record_id")
            let splashImage = Expression<String>("splash_image")
            let detail = Expression<String>("detail")
            let enabled = Expression<Bool>("enabled")

            try database.run(splashRecords.create { t in
                t.column(splashRecordId, defaultValue: 0)
                t.column(splashImage, defaultValue: "")
                t.column(detail, defaultValue: "")
                t.column(enabled, defaultValue: true)
            })
        } catch {
            print("Error in createTableSplashRecords : ", error)
        }
    }
    
    func saveSplashRecords(splashRecord: SplashRecord) {
        do {
            let srInsertCommant = "INSERT into splash_records (splash_record_id, splash_image, detail, enabled) VALUES (?, ?, ?, ?)";
            let stmt = try database.prepare(srInsertCommant);
            
            var detail = "";
            if (splashRecord.detail != nil) {
                detail = splashRecord.detail;
            }
            try stmt.run(Int64(splashRecord.splashRecordId), splashRecord.splashImage, detail,  splashRecord.enabled);
        } catch {
            print("Error in saveCalendarSyncToken : ", error);
        }
    }
    
    func findSplashRecords() -> SplashRecord {
        var splashRecod = SplashRecord();
        do {
            
            let selectQuery = "SELECT * from splash_records limit 1";
            for splashRecordData in try database.prepare(selectQuery) {
                splashRecod = processSqlliteSplashRecordData(splashRecordData: splashRecordData);
                break;
            }
        } catch {
            print("Error in findAllCalendarSyncToken : ", error)
        }
        return splashRecod;
    }
    
    func deleteSplashRecords() {
        do {
            let deleteStmt = "DELETE from splash_records";
            print(deleteStmt);
            let selectStmt = try database.prepare(deleteStmt);
            try selectStmt.run();
        } catch {
            print(error)
        }
    }

    func processSqlliteSplashRecordData(splashRecordData: Statement.Element) -> SplashRecord {
        
        let splashRecord = SplashRecord();
        splashRecord.splashRecordId = Int32(splashRecordData[0] as! Int64);
        splashRecord.splashImage = (splashRecordData[1] as! String);
        splashRecord.detail = (splashRecordData[2] as! String);
        splashRecord.enabled = true;
        
        return splashRecord;
    }
}
