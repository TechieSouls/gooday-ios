//
//  HomeManager.swift
//  Deploy
//
//  Created by Macbook on 18/12/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class HomeManager {
    
    var dataObjectArray = [HomeData]()

    func parseResults(resultArray: NSArray) -> [HomeData]{
        
        var months: [String] = [String]();
        var dataObjectArray = [HomeData]()

        let dict = NSMutableDictionary()
        
        for i : Int in (0..<resultArray.count) {
            
            let outerDict = resultArray[i] as! NSDictionary
            
            let dataType = (outerDict.value(forKey: "type") != nil) ? outerDict.value(forKey: "type") as? String : nil
            if dataType == "Event" {
                let event = Event().loadEventData(eventDict: outerDict)
                
                var key = Date(milliseconds: Int(event.startTime)).EMMMd()!;
                let components =  Calendar.current.dateComponents(in: TimeZone.current, from: Date())
                let componentStart = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(event.startTime)) )
                if(components.day == componentStart.day && components.month == componentStart.month && components.year == componentStart.year){
                    key = "Today";
                }else if((components.day!+1) == componentStart.day && components.month == componentStart.month && components.year == componentStart.year){
                    key = "Tomorrow " + key;
                }
                
                let newMonth = Date(milliseconds: Int(event.startTime)).MMMMsyyyy();
                
                //let currentMonth
                
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
                } else {
                    var array = [Event]()
                    array.append(event)
                    dict.setValue(array, forKey: key)
                    
                    let cenesEvent: HomeData = HomeData();
                    cenesEvent.sectionName = key;
                    cenesEvent.sectionObjects = array;
                    dataObjectArray.append(cenesEvent)
                    
                }
            }
        }
        
        for homedata in dataObjectArray {
            
            homedata.sectionObjects = homedata.sectionObjects.sorted(by: { $0.startTime < $1.startTime })
        }
        
        return dataObjectArray;
    }
    
    
    func parseInvitationResults(resultArray: NSArray) -> [HomeData]{
        
        let dict = NSMutableDictionary()
        
        for i : Int in (0..<resultArray.count) {
            
            let outerDict = resultArray[i] as! NSDictionary
            
            
            let event = Event().loadEventData(eventDict: outerDict)
            var key: String = Date(milliseconds: Int(event.startTime)).EMMMd()!;
            let components =  Calendar.current.dateComponents(in: TimeZone.current, from: Date())
            let componentStart = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(event.startTime)) )
            if(components.day == componentStart.day && components.month == componentStart.month && components.year == componentStart.year){
                key = "Today";
            }else if((components.day!+1) == componentStart.day && components.month == componentStart.month && components.year == componentStart.year){
                key = "Tomorrow " + key;
            }
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
                } else {
                    var array = [Event]()
                    array.append(event)
                    dict.setValue(array, forKey: key)
                    
                    let cenesEvent: HomeData = HomeData();
                    cenesEvent.sectionName = key;
                    cenesEvent.sectionObjects = array;
                    dataObjectArray.append(cenesEvent)
                    
                }
        }
        
        return dataObjectArray;
    }
    
    func getHost(event: Event) -> EventMember {
        var host: EventMember? = EventMember();
        if (event.eventId != nil && event.eventMembers != nil) {
            for eventMem in (event.eventMembers)! {
                if (eventMem.userId != nil && eventMem.userId == event.createdById) {
                    host = eventMem;
                    host?.photo = eventMem.user.photo;
                    break;
                }
            }
        }
        
        if (host == nil) {
            let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
            host!.name = loggedInUser.name;
            host!.photo = loggedInUser.photo;
            host!.userId = loggedInUser.userId;
        }
        return host!;
    }
    
    func mergeCurrentAndFutureList(currentList: [HomeData], futureList: [HomeData]) -> [HomeData] {
        
        var currentListTemp = currentList;
        
        for futObj in futureList {
            currentListTemp.append(futObj);
        }
        
        for homedata in currentListTemp {
            
            homedata.sectionObjects = homedata.sectionObjects.sorted(by: { $0.startTime < $1.startTime })
        }
        return currentListTemp;
    }
    
}
