//
//  GatheringManager.swift
//  Deploy
//
//  Created by Macbook on 21/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class GatheringManager {
    
    func parseGatheringResults(resultArray: NSArray) -> [CenesEvent]{
        
        var dataObjectArray = [CenesEvent]()
        let dict = NSMutableDictionary()
        
        for i : Int in (0..<resultArray.count) {
            
            
            let outerDict = resultArray[i] as! NSDictionary
            
            let keyNum = outerDict.value(forKey: "startTime") as! NSNumber
            var key = "\(keyNum)"
            
            let dateString = self.getDateString(timeStamp: key)
            
            let time = self.gethhmmAATimeStr(timeStamp: key)
            key = self.getddMMMEEEE(timeStamp: key)
            
            
            
            let title = (outerDict.value(forKey: "title") != nil) ? outerDict.value(forKey: "title") as? String : nil
            
            let location = (outerDict.value(forKey: "location") != nil) ? outerDict.value(forKey: "location") as? String : nil
            
            
            
            
            
            let  eventPicture = (outerDict.value(forKey: "eventPicture") != nil) ? outerDict.value(forKey: "eventPicture") as? String : nil
            
            
            let  description = (outerDict.value(forKey: "description") != nil) ? outerDict.value(forKey: "description") as? String : nil
            
            
            
            
            
            let  e_id = (outerDict.value(forKey: "eventId") != nil) ? outerDict.value(forKey: "eventId") as? NSNumber : nil
            let event_id = "\(e_id!)"
            
            
            
            let eventMembers = (outerDict.value(forKey: "eventMembers") != nil) ? outerDict.value(forKey: "eventMembers") as? NSArray : nil
            
            let senderName = outerDict.value(forKey: "sender") as? String
            
            let cenesEventObject : CenesCalendarData = CenesCalendarData()
            
            cenesEventObject.title = title
            cenesEventObject.locationStr = location
            cenesEventObject.eventImageURL = eventPicture
            cenesEventObject.eventId = event_id
            cenesEventObject.time = time
            cenesEventObject.eventDescription = description
            
            
            let startTime = outerDict.value(forKey: "startTime") as? NSNumber
            let endTime = outerDict.value(forKey: "endTime") as? NSNumber
            
            cenesEventObject.startTimeMillisecond = startTime
            cenesEventObject.endTimeMillisecond = endTime
            
            
            cenesEventObject.dateValue = dateString
            cenesEventObject.senderName = senderName
            
            let members = outerDict.value(forKey: "eventMembers") as! NSArray
            let MyId = setting.value(forKey: "userId") as! NSNumber
            for eMember in members{
                let eventMember = eMember as! [String : Any]
                let uId = eventMember["userId"] as? NSNumber
                if MyId == uId {
                    cenesEventObject.eventMemberId = "\(eventMember["eventMemberId"] as! NSNumber)"
                    break
                }
            }
            
            if location != nil && location != "" {
                let locationModel = LocationModel()
                locationModel.locationName = location
                
                
                let longString = outerDict.value(forKey: "longitude") as? String
                if longString != nil && longString != "" {
                    let long = Float(longString!)
                    let longitude = NSNumber(value:long!)
                    locationModel.longitude = longitude
                }
                
                
                let latString = outerDict.value(forKey: "latitude") as? String
                if latString != nil && latString != "" {
                    let lat = Float(latString!)
                    let latitude = NSNumber(value:lat!)
                    locationModel.latitude = latitude
                }
                cenesEventObject.locationModel = locationModel
            }
            
            
            let friendDict = eventMembers as! [NSDictionary]
            
            for userDict in friendDict {
                let cenesUser = CenesUser()
                cenesUser.name = userDict.value(forKey: "name") as? String
                cenesUser.photoUrl = userDict.value(forKey: "picture") as? String
                
                let uid =  userDict.value(forKey: "userId") as? NSNumber
                if uid != nil{
                    cenesUser.userId = "\((uid)!)"
                }
                
                if let isOwner = userDict.value(forKey: "owner") as? Bool {
                    cenesUser.isOwner = isOwner
                }
                cenesUser.userName = userDict.value(forKey: "username") as? String
                cenesEventObject.eventUsers.append(cenesUser)
            }
            
            
            
            
            if dict.value(forKey: key) != nil {
                
                
                var array = dict.value(forKey: key) as! [CenesCalendarData]!
                array?.append(cenesEventObject)
                dict.setValue(array, forKey: key)
                
                
                if let cenesEvent = dataObjectArray.first(where: { $0.sectionName == key}){
                    print(cenesEvent.sectionName)
                    cenesEvent.sectionObjects = array
                }
            }else{
                var array = [CenesCalendarData]()
                array.append(cenesEventObject)
                dict.setValue(array, forKey: key)
                
                let cenesEvent = CenesEvent()
                cenesEvent.sectionName = key
                cenesEvent.sectionObjects = array
                
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
}
