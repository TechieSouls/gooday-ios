//
//  HomeManager.swift
//  Deploy
//
//  Created by Macbook on 18/12/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class HomeManager {
    
    var dataObjectArray = [HomeDto]()

    func parseResults(resultArray: NSArray) -> [HomeDto]{
        
        let dict = NSMutableDictionary()
        
        for i : Int in (0..<resultArray.count) {
            
            let outerDict = resultArray[i] as! NSDictionary
            
            let dataType = (outerDict.value(forKey: "type") != nil) ? outerDict.value(forKey: "type") as? String : nil
            if dataType == "Event" {
                let event = Event().loadEventData(eventDict: outerDict)
                
                let key = Util.getddMMMEEEE(timeStamp: event.startTime)
                
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
                    
                    let cenesEvent: HomeDto = HomeDto();
                    cenesEvent.sectionName = key;
                    cenesEvent.sectionObjects = array;
                    dataObjectArray.append(cenesEvent)
                    
                }
            }
        }
        
        return dataObjectArray;
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
            let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
            host!.name = loggedInUser.name;
            host!.photo = loggedInUser.photo;
            host!.userId = loggedInUser.userId;
        }
        return host!;
    }
}
