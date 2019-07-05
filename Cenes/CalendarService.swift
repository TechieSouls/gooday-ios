//
//  CalendarService.swift
//  Deploy
//
//  Created by Macbook on 01/11/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI
class CalendarService {
    
    func fetchDeviceCalendar(complete: @escaping(NSMutableDictionary)->Void ) {
        let eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        var params : [String:Any] = [:];
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let calendar = Calendar.current
                
                var datecomponent = DateComponents()
                datecomponent.day = 30
                var endDate = calendar.date(byAdding: datecomponent, to: Date())
                
                let calendars = eventStore.calendars(for: .event)
                
                var newCalendar = [EKCalendar]()
                
                for calendar in calendars {
                    if calendar.title == "Work" || calendar.title == "Home"{
                        //      newCalendar.append(calendar)
                    }
                    newCalendar.append(calendar)
                }
                
                let predicate = eventStore.predicateForEvents(withStart: Date(), end: endDate!, calendars: newCalendar)
                
                let userid = setting.value(forKey: "userId") as! NSNumber
                let uid = "\(userid)"
                let eventArray = eventStore.events(matching: predicate)
                
                print(eventArray.description)

                if eventArray.count > 0 {
                    
                    
                    var arrayDict = [NSMutableDictionary]()
                    
                    for event  in eventArray {
                        
                        let event = event as EKEvent
                        
                        if (event.isAllDay) {
                            continue;
                        }
                        
                        let title = event.title
                        
                        let location = event.location
                        
                        var description = ""
                        if let desc = event.notes{
                            description = desc
                        }
                        
                        let startTime = "\(event.startDate.millisecondsSince1970)"
                        let endTime = "\(event.endDate.millisecondsSince1970)"
                        arrayDict.append(["title":title!,"description":description,"location":location!,"source":"Apple","createdById":uid,"timezone":TimeZone.current,"scheduleAs":"Event","startTime":startTime,"endTime":endTime])
                        
                    }
                    params = ["data":arrayDict]
                    if (params.count > 0) {
                        print(params)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            WebService().syncDeviceCalendar(uploadDict: params, complete: { (returnedDict) in
                                //self.showToast(message: "Device Synced..!");
                                let returnedDict = NSMutableDictionary();
                                returnedDict["success"] = true;
                                complete(returnedDict);
                            });
                        }
                        
                    }
                }
            }

        }
    }
}
