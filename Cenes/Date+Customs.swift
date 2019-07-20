//
//  Date+Customs.swift
//  Deploy
//
//  Created by Macbook on 20/12/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

extension Date {
    public var clampedDate: Date {
        let referenceTimeInterval = self.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(1*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
    }
    
    func toMillis() -> Int64! {
        let referenceTimeInterval = self.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(1*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Int64(timeRoundedToInterval)
    }
    
    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000 ))
    }
    
    func yyyy() -> String? { //2019
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func MMMM() -> String? { //August
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func dMMM() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dMMM"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    
    func EMMMd() -> String? { //Sat Jun 16
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMMM d"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func EMMMMdyyyy() -> String? { //Sat Jun 16 2015
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMMM d yyyy"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func MMMMsyyyy() -> String? { //June 2016
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func hmma() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }
    
    func yyyyMMdd() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
         return formatter.string(from: self)
    }
    
    func yyyyhfMMhfdd() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    
    }
    
    var currentTimeZoneDate: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return formatter.string(from: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func getDateStingInSecMinHourDayMonYear() -> String {
        
        let currentMilliSeconds = Date().millisecondsSince1970;
        
        let pastDateInMillis = self.millisecondsSince1970;
        
        let millisDifference = currentMilliSeconds - pastDateInMillis;
        
        let currentDateCal = Calendar.current;
        let currentYear = currentDateCal.component(.year, from: Date());
        let pastyear = currentDateCal.component(.year, from: self);
        let yearDiff = currentYear - pastyear;

        let currentMon = currentDateCal.component(.month, from: Date());
        let pastMon = currentDateCal.component(.month, from: self);
        let monthDiff = currentMon - pastMon;
        
        let daysDiff = millisDifference/(1000*60*60*24);
        
        let hoursDiff = millisDifference/(1000*60*60);
        
        let minutesDiff = millisDifference/(1000*60);
        
        let secondsDiff = millisDifference/(1000);
        
        if (yearDiff > -1 && yearDiff != 0) {
            return "\(String(yearDiff))y";
        } else if (monthDiff > -1 && monthDiff != 0 && monthDiff <= 12) {
            return "\(String(monthDiff))mo";
        } else if (daysDiff != 0 && daysDiff <= 31) {
            return "\(String(daysDiff))d";
        } else if (hoursDiff != 0) {
            return "\(String(hoursDiff))h";
        } else if (minutesDiff != 0) {
            return "\(String(minutesDiff))m";
        } else if (secondsDiff != 0) {
            return "\(String(secondsDiff))s";
        }
        return String("0s");
    }
    
    func startOfMonth() -> Date {
        
        var dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: self);
        dateComponents.day = 1;
        dateComponents.hour = 0;
        dateComponents.minute = 0;
        dateComponents.second = 0;
        dateComponents.nanosecond = 0;
        return Calendar.current.date(from: dateComponents)!;
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
