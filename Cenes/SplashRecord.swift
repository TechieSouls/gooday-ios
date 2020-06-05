//
//  SplashRecord.swift
//  Cenes
//
//  Created by Cenes_Dev on 24/04/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class SplashRecord {
    
    var splashRecordId: Int32!;
    var splashImage: String!;
    var detail: String!;
    var enabled: Bool!;
    
    func loadSplashRecord(splashDict: NSDictionary) -> SplashRecord {
        
        var splashRecord = SplashRecord();
        
        splashRecord.splashRecordId = splashDict.value(forKey: "splashRecordId") as! Int32;
        splashRecord.splashImage = splashDict.value(forKey: "splashImage") as! String;
        splashRecord.detail = splashDict.value(forKey: "detail") as! String;
        splashRecord.enabled = splashDict.value(forKey: "enabled") as! Bool;
        
        return splashRecord;
    }
}
