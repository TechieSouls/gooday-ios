//
//  MeTimeManager.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class MeTimeManager {
    
    func dayKeyAndNameMap(dayKey: Int) ->  String {
        var dayKeyNameMap: [Int : String] = [:];
        
        dayKeyNameMap[1] = "SUN";
        dayKeyNameMap[2] = "MON";
        dayKeyNameMap[3] = "TUE";
        dayKeyNameMap[4] = "WED";
        dayKeyNameMap[5] = "THUR";
        dayKeyNameMap[6] = "FRI";
        dayKeyNameMap[7] = "SAT";
        
        return dayKeyNameMap[dayKey]!;
    }
    
    func dayNameAndKeyMap(dayName: String) ->  Int {
        var dayKeyNameMap: [String : Int] = [:];
        
        dayKeyNameMap["Sunday"] = 1;
        dayKeyNameMap["Monday"] = 2;
        dayKeyNameMap["Tuesday"] = 3;
        dayKeyNameMap["Wednesday"] = 4;
        dayKeyNameMap["Thursday"] = 5;
        dayKeyNameMap["Friday"] = 6;
        dayKeyNameMap["Saturday"] = 7;
        
        return dayKeyNameMap[dayName]!;
    }
    
    func getDaysStr(recurringPatterns: [MeTimeRecurringPattern]) -> String {
        
        var recurringPatternsSorted = recurringPatterns;
        recurringPatternsSorted.sort(by: sorterForFileIDASC);
        var patternStr: String = "";
        
        patternStr = getCountinousDaysStr(recurringPatterns: recurringPatternsSorted);
        
        if (patternStr == "" && recurringPatternsSorted.count > 0) {
            for pattern in recurringPatternsSorted {
                let dayOfweek = Calendar.current.component(.weekday, from: Date(milliseconds: Int(pattern
                    .dayOfWeekTimestamp)));
                patternStr = "\(patternStr)\(dayKeyAndNameMap(dayKey: dayOfweek)),"
            }
            patternStr = String(patternStr.prefix(patternStr.count-1));
        }
        
        return patternStr;
    }
    
    func getCountinousDaysStr(recurringPatterns: [MeTimeRecurringPattern]) -> String {
        var daysStr: String = "";
        
        let sevenDays = ["1234567": "SUN-SAT", "123456": "SUN-FRI", "234567": "MON-SAT", "12345" : "SUN-THUR", "23456": "MON-FRI", "34567" : "TUE-SAT"] ;
        
        var daysIntStr: String = "";
        for pattern in recurringPatterns {
            daysIntStr = "\(daysIntStr)\(String(pattern.dayOfWeek))"
        }
        
        if (sevenDays.index(forKey: daysIntStr) != nil) {
            daysStr = sevenDays[daysIntStr]!;
        }
        return daysStr;
    }
    
    func sorterForFileIDASC(this:MeTimeRecurringPattern, that:MeTimeRecurringPattern) -> Bool {
        return this.dayOfWeek < that.dayOfWeek
    }
    
    func getTwoDigitInitialsOfTitle(title: String) -> String {
        
        let noImageLblArr = title.split(separator: " ")
        
        let index = noImageLblArr[0].index(noImageLblArr[0].startIndex, offsetBy: 1)
        
        var noImageLbl = String(noImageLblArr[0][..<index])
        if (noImageLblArr.count > 1) {
            let index = noImageLblArr[1].index(noImageLblArr[1].startIndex, offsetBy: 1)
            
            noImageLbl = "\(noImageLbl)\(noImageLblArr[1][..<index])"
        }
        
        return noImageLbl;
    }
    
    func validateMeTimeSave(meTimeRecurringEvent: MetimeRecurringEvent) -> String {
        
        var message: String = "";
        
        if (meTimeRecurringEvent.title == nil) {
            message = "Please Enter Title.";
        } else if (meTimeRecurringEvent.startTime == nil) {
            message = "Please select Start Time.";
        } else if (meTimeRecurringEvent.endTime == nil) {
            message = "Please select End Time.";
        } else if (meTimeRecurringEvent.patterns.count == 0) {
            message = "Please choose from Days.";
        }
        
        return message;
    }
}
