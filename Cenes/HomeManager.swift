//
//  HomeManager.swift
//  Deploy
//
//  Created by Macbook on 18/12/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

class HomeManager {
    
    var dataObjectArray = [HomeData]()

    func parseResultsForHomeEvents(homescreenDto: HomeDto, events: [Event]) -> HomeScreenDataHolder {
        
        let homescreenDto = homescreenDto;
        let homeScreenDataHolder = HomeScreenDataHolder();
        var totalEvents = homescreenDto.totalEventsList;
        
        var homeDataArrayToReturn = [HomeData]()
        
        let previousDate: Date = Date();
        var dataObjectArray = [HomeData]()
        
        let dict = NSMutableDictionary()
        
        //for i : Int in (0..<resultArray.count) {
        for event in events {
            //let outerDict = resultArray[i] as! NSDictionary
            
            //let dataType = (outerDict.value(forKey: "type") != nil) ? outerDict.value(forKey: "type") as? String : nil
            //if dataType == "Event" {
               // let event = Event().loadEventData(eventDict: outerDict.value(forKey: "event") as! NSDictionary)
                
            if (totalEvents.contains(event.eventId) || event.title == nil) {
                    continue;
                }
                totalEvents.append(event.eventId);
                let key = getMonthKeyForScrollIndex(startTime: Int(event.startTime));
                let keyWithYear = getMonthWithYearKeyForScrollIndex(startTime: Int(event.startTime));
                
                //let currentMonth
                if dict.value(forKey: key) != nil {
                    //var array = dict.value(forKey: key) as! [CenesCalendarData]!
                    var array = dict.value(forKey: key) as! [Event]
                    
                    var eventAlreadyExists = false;
                    for eventObj in array {
                        if (eventObj.source == "Outlook" || eventObj.source == "Apple" || eventObj.source == "Google") {
                            
                            if (eventObj.sourceEventId != nil && eventObj.sourceEventId == event.sourceEventId) {
                                eventAlreadyExists = true;
                                break;
                            }
                            
                        } else if (eventObj.eventId == event.eventId) {
                            eventAlreadyExists = true;
                            break;
                        }
                    }
                    if (eventAlreadyExists == false) {
                        array.append(event)
                        dict.setValue(array, forKey: key)
                        
                        for cenesEvent in dataObjectArray {
                            if (cenesEvent.sectionName == key) {
                                cenesEvent.sectionObjects = array
                            }
                        }
                    }
                } else {
                    var array = [Event]()
                    
                    let previousDateMonth = Calendar.current.component(.month, from: previousDate);
                    
                    let startTimeMonth = Calendar.current.component(.month, from: Date( milliseconds: Int(event.startTime)));
                    
                    array.append(event)
                    dict.setValue(array, forKey: key)
                    
                    let cenesEvent: HomeData = HomeData();
                    cenesEvent.year = Date(milliseconds: Int(event.startTime)).yyyy()
                    cenesEvent.month = Date(milliseconds: Int(event.startTime)).MMMM()
                    cenesEvent.sectionKeyInMillis = event.startTime
                    cenesEvent.sectionName = key;
                    cenesEvent.sectionNameWithYear = keyWithYear;
                    cenesEvent.sectionObjects = array;
                    dataObjectArray.append(cenesEvent)
                }
            //}
        }
        
        for homedata in dataObjectArray {
            
            homedata.sectionObjects = homedata.sectionObjects.sorted(by: { $0.startTime < $1.startTime })
        }
        
        if (dataObjectArray.count > 0) {
            
            var index = 0;
            for homeData in  dataObjectArray {
                
                //If its not the first record.. Then we will go down.
                if (index != 0) {
                    
                    //Fetch the previous home data in the data object array
                    //Lets say fetch the events for 12 July
                    let previousHomeData = dataObjectArray[index - 1];
                    var previousHomeDataArray = previousHomeData.sectionObjects;
                    
                    //Fetch the current home data in the data object array
                    //Lets say fetch the events for 14 July
                    let currentHomeData = dataObjectArray[index];
                    var currentHomeDataArray = currentHomeData.sectionObjects;
                    
                    //Now we will check if there is a month difference between prevous
                    //events and current events.
                    
                    //Lets get one event from previous dates.
                    let prevoiusDateEvent = previousHomeDataArray[0];
                    
                    //Lets get one event from current date
                    let currentDateEvent = currentHomeDataArray[0];
                    
                    //Let create date component from prevous date event
                    let previousDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(prevoiusDateEvent.startTime)));
                    
                    
                    //Lets create date components from current date event
                    let currentDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(currentDateEvent.startTime)));
                    
                    
                    print("Previous Month : ",previousDateComponent.month, "Current Month : ",currentDateComponent.month);
                    
                    if (previousDateComponent.month != currentDateComponent.month) {
                        
                        let monthSeparatorTitle = Date(milliseconds: Int(currentDateEvent.startTime)).MMMMsyyyy()!;
                        if (!homescreenDto.monthSeparatorList.contains(monthSeparatorTitle)) {
                            homescreenDto.monthSeparatorList.append(monthSeparatorTitle);

                            let monthEvent = Event();
                            monthEvent.title = monthSeparatorTitle;
                            monthEvent.scheduleAs = "MonthSeparator";
                            
                            monthEvent.startTime = currentDateEvent.startTime;
                            
                            var monthSeaparatorArra = [Event]();
                            monthSeaparatorArra.append(monthEvent);
                            
                            let cenesEvent: HomeData = HomeData();
                            cenesEvent.year = Date(milliseconds: Int(currentDateEvent.startTime)).yyyy()
                            cenesEvent.month = Date(milliseconds: Int(currentDateEvent.startTime)).MMMM()
                            cenesEvent.sectionKeyInMillis = currentDateEvent.startTime
                            
                            let newStartDate = Calendar.current.date(byAdding: .second, value: -1, to: Date(milliseconds: Int(monthEvent.startTime)))!;
                            
                            cenesEvent.sectionName = Date(milliseconds: Int(newStartDate.millisecondsSince1970)).MMMMsyyyy()!;
                            cenesEvent.sectionNameWithYear = Date(milliseconds: Int(currentDateEvent.startTime)).MMMMsyyyy()!;
                            cenesEvent.sectionObjects = monthSeaparatorArra;
                            
                            homeDataArrayToReturn.append(cenesEvent);
                            
                            homescreenDto.monthTrackerForDataLoad.append("\(currentDateComponent.month!)-\(currentDateComponent.year!)");
                            
                            let monthScrollDto = MonthScrollDto();
                            monthScrollDto.indexKey = currentHomeData.sectionName;
                            monthScrollDto.year = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(dataObjectArray[index].sectionObjects[0].startTime))).year!;
                            
                            homescreenDto.timeStamp = Int(dataObjectArray[index].sectionObjects[0].startTime);
                            
                            let compos = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: homescreenDto.timeStamp));
                            
                            homescreenDto.monthScrollIndex["\(compos.month!)-\(compos.year!)"] = monthScrollDto;
                            
                            monthScrollDto.timestamp = Int(Date(milliseconds: homescreenDto.timeStamp).startOfMonth().millisecondsSince1970);
                            homescreenDto.topHeaderDateIndex[HomeManager().getMonthWithYearKeyForScrollIndex(startTime: homescreenDto.timeStamp)] = monthScrollDto;
                        }
                        //homescreenDto.scrollToMonthStartSectionAtHomeButton.append(monthScrollDto);
                    }
                } else {
                    
                    
                    //if (totalEvents.count > 20) {
                    
                    let monthSeparatorTitle = Date(milliseconds: Int(homeData.sectionKeyInMillis)).MMMMsyyyy()!;
                    
                    if (!homescreenDto.monthSeparatorList.contains(monthSeparatorTitle)) {
                        
                        
                        homescreenDto.monthSeparatorList.append(monthSeparatorTitle);
                        
                        let currentDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(homeData.sectionKeyInMillis)));
                        
                        //Creating new Event Managed Object
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext;

                        let monthEvent = Event();
                        monthEvent.title = monthSeparatorTitle;
                            monthEvent.scheduleAs = "MonthSeparator";
                        
                        monthEvent.startTime = homeData.sectionKeyInMillis;
                        
                        var monthSeaparatorArra = [Event]();
                        monthSeaparatorArra.append(monthEvent);
                        
                        let cenesEvent: HomeData = HomeData();
                        cenesEvent.year = Date(milliseconds: Int(homeData.sectionKeyInMillis)).yyyy()
                        cenesEvent.month = Date(milliseconds: Int(homeData.sectionKeyInMillis)).MMMM()
                        cenesEvent.sectionKeyInMillis = homeData.sectionKeyInMillis
                        
                        let newStartDate = Calendar.current.date(byAdding: .second, value: -1, to: Date(milliseconds: Int(monthEvent.startTime)))!;
                        
                        cenesEvent.sectionName = Date(milliseconds: Int(newStartDate.millisecondsSince1970)).MMMMsyyyy()!;
                        cenesEvent.sectionNameWithYear = Date(milliseconds: Int(homeData.sectionKeyInMillis)).MMMMsyyyy()!;
                        cenesEvent.sectionObjects = monthSeaparatorArra;
                        
                        homeDataArrayToReturn.append(cenesEvent);
                        homescreenDto.monthTrackerForDataLoad.append("\(currentDateComponent.month!)-\(currentDateComponent.year!)");
                        
                        let monthScrollDto = MonthScrollDto();
                        monthScrollDto.indexKey = homeData.sectionName;
                        monthScrollDto.year = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(homeData.sectionObjects[0].startTime))).year!;
                        
                        homescreenDto.timeStamp = Int(homeData.sectionObjects[0].startTime);
                        
                        let compos = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: homescreenDto.timeStamp));
                        
                        homescreenDto.monthScrollIndex["\(compos.month!)-\(compos.year!)"] = monthScrollDto;
                        
                        monthScrollDto.timestamp = Int(Date(milliseconds: homescreenDto.timeStamp).startOfMonth().millisecondsSince1970);
                        homescreenDto.topHeaderDateIndex[HomeManager().getMonthWithYearKeyForScrollIndex(startTime: homescreenDto.timeStamp)] = monthScrollDto;
                    }
                    
                    //We will keep only one record and that is for current months starting event
                    if (homescreenDto.scrollToMonthStartSectionAtHomeButton.count == 0) {
                        
                        let monthScrollDto = MonthScrollDto();
                        monthScrollDto.indexKey = getMonthKeyForScrollIndex(startTime: Int(homeData.sectionObjects[0].startTime));
                        monthScrollDto.year = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(homeData.sectionObjects[0].startTime))).year!;
                        monthScrollDto.timestamp = Int(homeData.sectionObjects[0].startTime);
                        
                        homescreenDto.scrollToMonthStartSectionAtHomeButton.append(monthScrollDto);
                    }
                    //}
                }
                
                homeDataArrayToReturn.append(homeData);
                index = index + 1;
            }
            
        }
        
        homescreenDto.totalEventsList = totalEvents;
        homeDataArrayToReturn = homeDataArrayToReturn.sorted(by: { $0.sectionKeyInMillis < $1.sectionKeyInMillis })

        homeScreenDataHolder.homescreenDto = homescreenDto;
        homeScreenDataHolder.homeDataList = homeDataArrayToReturn;
        
        
        return homeScreenDataHolder;
    }
    
    func parseResults(resultArray: NSArray) -> [HomeData]{
        
        var homeDataArrayToReturn = [HomeData]()

        let previousDate: Date = Date();
        var months: [String] = [String]();
        var dataObjectArray = [HomeData]()

        let dict = NSMutableDictionary()
        
        for i : Int in (0..<resultArray.count) {
            
            let outerDict = resultArray[i] as! NSDictionary
            
            let dataType = (outerDict.value(forKey: "type") != nil) ? outerDict.value(forKey: "type") as? String : nil
            if dataType == "Event" {
                let event = Event().loadEventData(eventDict: outerDict.value(forKey: "event") as! NSDictionary)
        
                let key = getMonthKeyForScrollIndex(startTime: Int(event.startTime));
                let keyWithYear = getMonthWithYearKeyForScrollIndex(startTime: Int(event.startTime));
                
                //let currentMonth
                
                if dict.value(forKey: key) != nil {
                    //var array = dict.value(forKey: key) as! [CenesCalendarData]!
                    var array = dict.value(forKey: key) as! [Event]
                    
                    var eventAlreadyExists = false;
                    for eventObj in array {
                        if (eventObj.eventId == event.eventId) {
                            eventAlreadyExists = true;
                            break;
                        }
                    }
                    if (eventAlreadyExists == false) {
                        array.append(event)
                        dict.setValue(array, forKey: key)
                        
                        for cenesEvent in dataObjectArray {
                            if (cenesEvent.sectionName == key) {
                                cenesEvent.sectionObjects = array
                            }
                        }
                    }
                } else {
                    var array = [Event]()

                    let previousDateMonth = Calendar.current.component(.month, from: previousDate);
                    
                    let startTimeMonth = Calendar.current.component(.month, from: Date( milliseconds: Int(event.startTime)));
                    
                    array.append(event)
                    dict.setValue(array, forKey: key)
                    
                    let cenesEvent: HomeData = HomeData();
                    cenesEvent.year = Date(milliseconds: Int(event.startTime)).yyyy()
                    cenesEvent.month = Date(milliseconds: Int(event.startTime)).MMMM()
                    cenesEvent.sectionKeyInMillis = event.startTime
                    cenesEvent.sectionName = key;
                    cenesEvent.sectionNameWithYear = keyWithYear;
                    cenesEvent.sectionObjects = array;
                    dataObjectArray.append(cenesEvent)
                }
            }
        }

        for homedata in dataObjectArray {
            
            homedata.sectionObjects = homedata.sectionObjects.sorted(by: { $0.startTime < $1.startTime })
        }
        
        if (dataObjectArray.count > 0) {
            
            var index = 0;
            for homeData in  dataObjectArray {
                
                if (index != 0) {
                  
                    //Fetch the previous home data in the data object array
                    //Lets say fetch the events for 12 July
                    let previousHomeData = dataObjectArray[index - 1];
                    var previousHomeDataArray = previousHomeData.sectionObjects;

                    //Fetch the current home data in the data object array
                    //Lets say fetch the events for 14 July
                    let currentHomeData = dataObjectArray[index];
                    var currentHomeDataArray = currentHomeData.sectionObjects;
                    
                    //Now we will check if there is a month difference between prevous
                    //events and current events.
                    
                    //Lets get one event from previous dates.
                    let prevoiusDateEvent = previousHomeDataArray[0];
                    
                    //Lets get one event from current date
                    let currentDateEvent = currentHomeDataArray[0];
                    
                    //Let create date component from prevous date event
                    let previousDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(prevoiusDateEvent.startTime)));
                    
                    
                    //Lets create date components from current date event
                    let currentDateComponent = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(currentDateEvent.startTime)));

                    
                    print("Previous Month : ",previousDateComponent.month, "Current Month : ",currentDateComponent.month);
                    
                    if (previousDateComponent.month != currentDateComponent.month) {
                        
                        let monthEvent = Event();
                        monthEvent.title = Date(milliseconds: Int(currentDateEvent.startTime)).MMMMsyyyy()!;
                        monthEvent.scheduleAs = "MonthSeparator";
                        
                        monthEvent.startTime = currentDateEvent.startTime;
                        
                        var monthSeaparatorArra = [Event]();
                        monthSeaparatorArra.append(monthEvent);
                        
                        let cenesEvent: HomeData = HomeData();
                        cenesEvent.year = Date(milliseconds: Int(currentDateEvent.startTime)).yyyy()
                        cenesEvent.month = Date(milliseconds: Int(currentDateEvent.startTime)).MMMM()
                        cenesEvent.sectionKeyInMillis = currentDateEvent.startTime
                        
                        let newStartDate = Calendar.current.date(byAdding: .second, value: -1, to: Date(milliseconds: Int(monthEvent.startTime)))!;
                        
                        cenesEvent.sectionName = Date(milliseconds: Int(newStartDate.millisecondsSince1970)).MMMMsyyyy()!;
                        cenesEvent.sectionNameWithYear = Date(milliseconds: Int(currentDateEvent.startTime)).MMMMsyyyy()!;
                        cenesEvent.sectionObjects = monthSeaparatorArra;
                        
                        homeDataArrayToReturn.append(cenesEvent);
                    }
                }
                
                homeDataArrayToReturn.append(homeData);
                index = index + 1;
            }
            
        }
        
        return homeDataArrayToReturn;
    }
    
    
    func parseInvitationResults(resultArray: NSArray) -> [HomeData]{
        
        let dict = NSMutableDictionary()
        
        for i : Int in (0..<resultArray.count) {
            
            let outerDict = resultArray[i] as! NSDictionary
            
            let event = Event().loadEventData(eventDict: outerDict)
            if (event.eventId == 0 || event.title == nil || event.scheduleAs != "Gathering") {
                continue;
            }
            var key: String = Date(milliseconds: Int(event.startTime)).EMMMd()!;
            let keyWithYear = getMonthWithYearKeyForScrollIndex(startTime: Int(event.startTime));

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
                cenesEvent.year = Date(milliseconds: Int(event.startTime)).yyyy()
                cenesEvent.month = Date(milliseconds: Int(event.startTime)).MMMM()
                cenesEvent.sectionKeyInMillis = event.startTime
                cenesEvent.sectionNameWithYear = keyWithYear;
                cenesEvent.sectionObjects = array;

                cenesEvent.sectionObjects = array;
                dataObjectArray.append(cenesEvent)
            }
        }
        
        return dataObjectArray;
    }
    
    
    func parseInvitationResultsForEventManagedObject(eventBOs: [Event]) -> [HomeData]{
        
        let dict = NSMutableDictionary()
        
        for eventBO in eventBOs {

            if (eventBO.scheduleAs != "Gathering") {
                continue;
            }
            var key: String = Date(milliseconds: Int(eventBO.startTime)).EMMMd()!;
            let keyWithYear = getMonthWithYearKeyForScrollIndex(startTime: Int(eventBO.startTime));

            let components =  Calendar.current.dateComponents(in: TimeZone.current, from: Date())
            let componentStart = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(eventBO.startTime)) )
            if(components.day == componentStart.day && components.month == componentStart.month && components.year == componentStart.year){
                key = "Today";
            }else if((components.day!+1) == componentStart.day && components.month == componentStart.month && components.year == componentStart.year){
                key = "Tomorrow " + key;
            }
                if dict.value(forKey: key) != nil {
                    //var array = dict.value(forKey: key) as! [CenesCalendarData]!
                    var array = dict.value(forKey: key) as! [Event]
                    array.append(eventBO)
                    dict.setValue(array, forKey: key)
                    
                    for cenesEvent in dataObjectArray {
                        if (cenesEvent.sectionName == key) {
                            cenesEvent.sectionObjects = array
                        }
                    }
                } else {
                    var array = [Event]()
                    array.append(eventBO)
                    dict.setValue(array, forKey: key)
                    
                    let cenesEvent: HomeData = HomeData();
                    cenesEvent.sectionName = key;
                    cenesEvent.year = Date(milliseconds: Int(eventBO.startTime)).yyyy()
                    cenesEvent.month = Date(milliseconds: Int(eventBO.startTime)).MMMM()
                    cenesEvent.sectionKeyInMillis = eventBO.startTime
                    cenesEvent.sectionNameWithYear = keyWithYear;
                    cenesEvent.sectionObjects = array;

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
            
            var sameKeyAlreadyExists = false;
            
                for currListObj in currentListTemp {
                    
                    if (currListObj.sectionName == futObj.sectionName) {
                        sameKeyAlreadyExists = true;
                        
                        
                        var currListObjSectionObjs = currListObj.sectionObjects
                        
                        for futSecObj in futObj.sectionObjects {
                            
                            var secObjAlreadyExists = false;
                            
                            for currSecObj in currListObjSectionObjs {
                                
                                if (currSecObj.eventId == futSecObj.eventId) {
                                    secObjAlreadyExists = true;
                                    break;
                                }
                            }
                            
                            if (secObjAlreadyExists == false) {
                                currListObjSectionObjs.append(futSecObj);
                            }
                        }
                        
                        currListObj.sectionObjects = currListObjSectionObjs;
                    }
                }
            
                if (sameKeyAlreadyExists == false) {
                    currentListTemp.append(futObj);
                }
        } //Logic to handle events with same ids.
        
        currentListTemp = currentListTemp.sorted(by: { $0.sectionKeyInMillis < $1.sectionKeyInMillis })
        
        
        for homedata in currentListTemp {
            
            homedata.sectionObjects = homedata.sectionObjects.sorted(by: { $0.startTime < $1.startTime })
        }
        return currentListTemp;
    }
    
    
    func mergePreviousDataAtTop(currentList: [HomeData], previous: [HomeData]) -> [HomeData] {
        
        var previousTemp = previous;
        
        for futObj in currentList {
            previousTemp.append(futObj);
        }
        
        previousTemp = previousTemp.sorted(by: { $0.sectionKeyInMillis < $1.sectionKeyInMillis })

        for homedata in previousTemp {
            
            homedata.sectionObjects = homedata.sectionObjects.sorted(by: { $0.startTime < $1.startTime })
        }
        return previousTemp;
    }
    
    func getMonthKeyForScrollIndex(startTime: Int) -> String {
        var key = Date(milliseconds: Int(startTime)).EMMMd()!;
        let components =  Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        let componentStart = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(startTime)) )
        
        if (componentStart.year != components.year) {
            key = (Date(milliseconds: startTime).EMMMMdyyyy()!);
        }
        if(components.day == componentStart.day && components.month == componentStart.month && components.year == componentStart.year){
            key = "Today " + key;
        }else if((components.day!+1) == componentStart.day && components.month == componentStart.month && components.year == componentStart.year){
            key = "Tomorrow " + key;
        }
        return key;
    }
    
    func getMonthWithYearKeyForScrollIndex(startTime: Int) -> String {
        let key = Date(milliseconds: Int(startTime)).EMMMMdyyyy()!;
        let components =  Calendar.current.dateComponents(in: TimeZone.current, from: Date())
        let componentStart = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(startTime)) );
        return key;
    }
    
    func getScrollIndexFromMonthKey(homeDataList: [HomeData], key: MonthScrollDto) -> Int {
        
        var scrollToIIndex = 0;
        for homeData in homeDataList {
            if (homeData.sectionName == key.indexKey) {
                var year: Int = 0
                if (homeData.sectionObjects[0].scheduleAs != "MonthSeparator") {
                    
                    year = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(homeData.sectionObjects[0].startTime))).year!;
                }
                if (year == key.year) {
                    break;
                }
            }
            scrollToIIndex = scrollToIIndex + 1;
        }
        return scrollToIIndex;
    }
    
    
    func getScrollIndexForTodaysEvent(homeDataList: [HomeData], key: MonthScrollDto) -> [String: Int] {
        
        var scrollIndexDict = [String: Int]();
        var scrollToIIndex = 0;
        for homeData in homeDataList {
            if (homeData.sectionName == key.indexKey) {
                
                /*var rowIndexInSection = 0;
                for desiredSectionIndexEvent in homeData.sectionObjects {
                    let currentTimeStamp = Date().millisecondsSince1970;
                    let startTimestamp = desiredSectionIndexEvent.startTime;
                    let endTimestamp = desiredSectionIndexEvent.endTime;
                
                    if (currentTimeStamp < endTimestamp) {
                        scrollIndexDict["rowIndex"] = rowIndexInSection;
                        break;
                    }
                    
                    rowIndexInSection = rowIndexInSection +  1;
                }*/
                var rowIndex = 0;
                for sectionObjectItem in homeData.sectionObjects {
                    if (sectionObjectItem.startTime == key.timestamp) {
                        scrollIndexDict["rowIndex"] = rowIndex;
                        break;
                    }
                    rowIndex = rowIndex + 1;
                }
                
                let year: Int = Calendar.current.dateComponents(in: TimeZone.current, from: Date(milliseconds: Int(homeData.sectionObjects[0].startTime))).year!;
                
                if (year == key.year) {
                    break;
                }
            }
            scrollToIIndex = scrollToIIndex + 1;
        }
        
        
        
        
        if (scrollIndexDict["rowIndex"] == nil) {
            scrollIndexDict["rowIndex"] = 0;
        }
        scrollIndexDict["sectionIndex"] = scrollToIIndex;
        return scrollIndexDict;
    }
    
    func populateTotalEventIds(eventIdList: [Int32], resultArray: NSArray) -> [Int32]{
        
        var eventIdList = eventIdList;
        for i : Int in (0..<resultArray.count) {
            
            let outerDict = resultArray[i] as! NSDictionary
            
            let dataType = (outerDict.value(forKey: "type") != nil) ? outerDict.value(forKey: "type") as? String : nil
            if dataType == "Event" {
                let event = Event().loadEventData(eventDict: outerDict.value(forKey: "event") as! NSDictionary)
                
                if (!eventIdList.contains(event.eventId)) {
                    eventIdList.append(event.eventId);
                }
            }
        }
        
        return eventIdList;
    }
    
    func populateOfflineData(events: [Event]) {
    
        for event in events {
            
            EventModel().saveEventModel(event: event);
            
        }
    }
}
