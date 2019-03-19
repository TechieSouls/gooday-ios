//
//  GatheringManager.swift
//  Deploy
//
//  Created by Macbook on 21/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class GatheringManager {
    
    func parseGatheringResults(resultArray: NSArray) -> [EventDto]{
        
        //var dataObjectArray = [CenesEvent]()
        var dataObjectArray = [EventDto]();
        let dict = NSMutableDictionary()
        
        for i : Int in (0..<resultArray.count) {
            
            
            let outerDict = resultArray[i] as! NSDictionary
            
            let keyNum = outerDict.value(forKey: "startTime") as! NSNumber
            var key = "\(keyNum)"
            
            let dateString = self.getDateString(timeStamp: key)
            
            let time = self.gethhmmAATimeStr(timeStamp: key)
            key = self.getddMMMEEEE(timeStamp: key)
            
            var event = Event().loadEventData(eventDict: outerDict)
            
            
            if dict.value(forKey: key) != nil {
                
                
                //var array = dict.value(forKey: key) as! [CenesCalendarData]!
                var array = dict.value(forKey: key) as! [Event]
                array.append(event)
                dict.setValue(array, forKey: key)
                
                for cenesEvent in dataObjectArray {
                    if (cenesEvent.sectionName == key) {
                        cenesEvent.sectionObjects = array
                    }
                }
            }else{
                var array = [Event]()
                array.append(event)
                dict.setValue(array, forKey: key)
                
                /*let cenesEvent = CenesEvent()
                 cenesEvent.sectionName = key
                 cenesEvent.sectionObjects = array*/
                var cenesEvent: EventDto = EventDto();
                cenesEvent.sectionName = key;
                cenesEvent.sectionObjects = array;
                dataObjectArray.append(cenesEvent)
                
            }
            
        }
        
        return dataObjectArray;
    }
    
    func gethhmmAATimeStr(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mma"
        let date = dateFormatter.string(from: dateFromServer as Date)
        
        return date
    }
    
    
    func getTimeFromTimestamp(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let date = dateFormatter.string(from: dateFromServer as Date)
        
        return date
    }
    
    
    func getDateString(timeStamp:String)-> String {
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        var dateString = dateFormatter.string(from: dateFromServer as Date)
        dateString += "\n"
        dateFormatter.dateFormat = "EEE"
        dateString += dateFormatter.string(from: dateFromServer as Date)
        return dateString
    }
    
    func getddMMMEEEE(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        //.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "dMMM"
        var date1Str = dateFormatter.string(from: dateFromServer as Date).uppercased()
        
        dateFormatter.dateFormat = "EEEE"
        let date2Str = dateFormatter.string(from: dateFromServer as Date).uppercased()
        return "\(date1Str) \(date2Str)";
    }
    
    func getDateFromTimestamp(timeStamp:String) -> String{
        let timeinterval : TimeInterval = Double(timeStamp)! / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        //.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.string(from: dateFromServer as Date).capitalized
        
        let dateobj = dateFormatter.date(from: date)
        
        
        dateFormatter.dateFormat = "EEEE, MMMM d"
        date = dateFormatter.string(from: dateFromServer as Date).capitalized
        if NSCalendar.current.isDateInToday(dateobj!) == true {
            date = "TODAY \(date)"
        }else if NSCalendar.current.isDateInTomorrow(dateobj!) == true{
            date = "TOMORROW \(date)"
        }
        return date
    }
    
    func getHost(event: Event) -> EventMember {
        var host: EventMember? = EventMember();
        if (event != nil && event.eventId != nil && event.eventMembers != nil) {
            for eventMem in (event.eventMembers)! {
                if (eventMem.userId != nil && eventMem.userId == event.createdById) {
                    host = eventMem;
                    host?.photo = eventMem.user.photo;
                    break;
                }
            }
        }
        
        if (host == nil) {
            var loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
            host!.name = loggedInUser.name;
            host!.photo = loggedInUser.photo;
            host!.userId = loggedInUser.userId;
        }
        return host!;
    }
}
