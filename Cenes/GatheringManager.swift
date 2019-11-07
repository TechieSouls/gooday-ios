//
//  GatheringManager.swift
//  Deploy
//
//  Created by Macbook on 21/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreData

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
            
            //var event = Event().loadEventData(eventDict: outerDict)
            
            var event = Event();
            var eventMO = EventModel().saveEventModelByEventDictnory(eventDict: outerDict);
            event = EventModel().copyDataToEventBo(eventMo: eventMO);
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
    
    func parseFriendsListResults(friendList: [UserContact]) -> [FriendListDto] {
        
        var nonAlphabeticFriends = [UserContact]();
        var dataObjectArray = [FriendListDto]();
        var friendListMapDto = [String: FriendListDto]();
        for userContact in friendList {
            
            var nameInitial = "";
            if (userContact.user != nil && userContact.user!.name != nil) {
                nameInitial = userContact.user!.name!.prefix(1).uppercased();
                print(nameInitial)
            } else if (userContact.name != nil) {
                nameInitial = userContact.name!.prefix(1).uppercased();
                print(nameInitial)
            }
            var friendListDtoTemp = FriendListDto();
            
            if (!InviteFriendsDto().alphabetStrip.contains(nameInitial.uppercased())) {
                nonAlphabeticFriends.append(userContact);
            } else {
                if (friendListMapDto.index(forKey: nameInitial) != nil) {
                    friendListDtoTemp = friendListMapDto[nameInitial]!;
                }
                
                friendListDtoTemp.sectionName = nameInitial;
                var members = friendListDtoTemp.sectionObjects;
                members.append(userContact);
                friendListDtoTemp.sectionObjects = members;
                
                friendListMapDto[nameInitial] = friendListDtoTemp;
            }
        }
        
        for (k,value) in Array(friendListMapDto).sorted(by: {$0.0 < $1.0}) {
            dataObjectArray.append(value);
        }
        
        if (nonAlphabeticFriends.count > 0) {
            var nonAlphabeticFriendDto = FriendListDto();
            nonAlphabeticFriendDto.sectionName = "#";
            nonAlphabeticFriendDto.sectionObjects = nonAlphabeticFriends;
            dataObjectArray.append(nonAlphabeticFriendDto);
        }
        return dataObjectArray;
    }
    
    func getCenesContacts(friendList: [UserContact]) -> [FriendListDto] {
        
        var cenesMembers = [UserContact]();
        for cenesContact in friendList {
            
            if (cenesContact.user != nil || cenesContact.cenesMember == "yes") {
                cenesMembers.append(cenesContact);

            }
        }
        
        var nonAlphabeticFriends = [UserContact]();
        var dataObjectArray = [FriendListDto]();
        var friendListMapDto = [String: FriendListDto]();
        for userContact in cenesMembers {
            
            var nameInitial = "";
            if (userContact.user != nil && userContact.user!.name != nil) {
                nameInitial = userContact.user!.name!.prefix(1).uppercased();
                print(nameInitial)
            } else if (userContact.name != nil) {
                nameInitial = userContact.name!.prefix(1).uppercased();
                print(nameInitial)
            }
            var friendListDtoTemp = FriendListDto();
            
            if (!InviteFriendsDto().alphabetStrip.contains(nameInitial.uppercased())) {
                nonAlphabeticFriends.append(userContact);
            } else {
                if (friendListMapDto.index(forKey: nameInitial) != nil) {
                    friendListDtoTemp = friendListMapDto[nameInitial]!;
                }
                
                friendListDtoTemp.sectionName = nameInitial;
                var members = friendListDtoTemp.sectionObjects;
                members.append(userContact);
                friendListDtoTemp.sectionObjects = members;
                
                friendListMapDto[nameInitial] = friendListDtoTemp;
            }
        }
        
        for (k,value) in Array(friendListMapDto).sorted(by: {$0.0 < $1.0}) {
            dataObjectArray.append(value);
        }
        
        if (nonAlphabeticFriends.count > 0) {
            var nonAlphabeticFriendDto = FriendListDto();
            nonAlphabeticFriendDto.sectionName = "#";
            nonAlphabeticFriendDto.sectionObjects = nonAlphabeticFriends;
            dataObjectArray.append(nonAlphabeticFriendDto);
        }
        return dataObjectArray;
    }
    
    func getCenesContactsMO(friendList: [CenesUserContactMO]) -> [CenesUserContactMO] {
        
        var cenesMembers = [CenesUserContactMO]();
        for eventMember in friendList {
            
            if eventMember.cenesMember == "yes" {
                print(eventMember.description);
                cenesMembers.append(eventMember);
            }
        }
        return cenesMembers;
    }
    
    func allFieldsFilled(createGathDto: CreateGathDto) -> Bool {
        
        var allFiledFilled: Bool = true;
        for (_, value) in createGathDto.trackGatheringDataFilled {
            if (value == false) {
                allFiledFilled = false;
                break;
            }
        }
        return allFiledFilled;
    }
    
    
    func makeAllFieldsFilled(createGathDto: CreateGathDto) -> Void {
        
        var allFiledFilled: Bool = true;
        for (key, value) in createGathDto.trackGatheringDataFilled {
            createGathDto.trackGatheringDataFilled[key] = true;
        }
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
    
    func getCurrentMonthDatesWithColor(selectedDate: Date) -> [String: UIColor] {
    
        var currentMonthDates:[String: UIColor] = [String: UIColor]();
    
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd";
        
        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate);
        let startDateOfMonth = Calendar.current.date(from: components);
        
        var endDateComponents = DateComponents();
        endDateComponents.month = 1;
        endDateComponents.day = -1;
        let endDateOfMonth = Calendar.current.date(byAdding: endDateComponents, to: startDateOfMonth!);
        
        var startIndex: Int = Calendar.current.dateComponents(in: TimeZone.current, from: startDateOfMonth!).day!
        
        var endIndex: Int = Calendar.current.dateComponents(in: TimeZone.current, from: endDateOfMonth!).day!

        
        var variabkeDate = startDateOfMonth;
        while startIndex <= endIndex {
            
            currentMonthDates[dateFormatter.string(from: variabkeDate!)] = CreateGatheringPredictiveColors.GRAYCOLOR

            var endDateComponents = DateComponents();
            endDateComponents.day = 1;
            variabkeDate = Calendar.current.date(byAdding: endDateComponents, to: variabkeDate!);
            startIndex = startIndex+1
        }
        
        return currentMonthDates;
    }
    
    func fetchEventDictionaryFromEventManagedObject(eventMO: EventMO) -> [String: Any] {
        
        var eventJson: [String: Any] = [:];
        eventJson["title"] = eventMO.title;
        eventJson["description"] = eventMO.desc;
        eventJson["eventPicture"] = eventMO.eventPicture;
        if (eventMO.eventId != 0) {
            eventJson["eventId"] = eventMO.eventId;
        }
        eventJson["createdById"] = eventMO.createdById;
        eventJson["startTime"] = eventMO.startTime;
        eventJson["endTime"] = eventMO.endTime;
        eventJson["location"] = eventMO.location;
        eventJson["scheduleAs"] = eventMO.scheduleAs;
        eventJson["latitude"] = eventMO.latitude;
        eventJson["longitude"] = eventMO.longitude;
        eventJson["createdById"] = eventMO.createdById;
        eventJson["source"] = eventMO.source;
        eventJson["sourceEventId"] = eventMO.sourceEventId;
        eventJson["thumbnail"] = eventMO.thumbnail;
        eventJson["isPredictiveOn"] = eventMO.isPredictiveOn;
        eventJson["isFullDay"] = eventMO.isFullDay;
        eventJson["placeId"] = eventMO.placeId;
        eventJson["predictiveData"] = eventMO.predictiveData;
        eventJson["fullDayStartTime"] = eventMO.fullDayStartTime;
        eventJson["key"] = eventMO.key;
        if (eventMO.eventMembers != nil && eventMO.eventMembers!.count > 0) {
            var eveMembers: [[String: Any]] = [];
            for evenMem in eventMO.eventMembers! {
                
                let evenMemMO = evenMem as! EventMemberMO;
                eveMembers.append(fetchEventMemberDictionaryFromEventMemberManagedObject(eventMO: eventMO, eventMemberMO: evenMemMO));
            }
            eventJson["eventMembers"] = eveMembers;
        }
        return eventJson;

    }
    
    func fetchEventMemberDictionaryFromEventMemberManagedObject(eventMO: EventMO, eventMemberMO: EventMemberMO) -> [String: Any] {
        
        var eventMemberJson: [String: Any] = [:];
        
        if (eventMO.eventId != 0) {
            eventMemberJson["eventId"] = eventMO.eventId;
        }
        if (eventMemberMO.eventMemberId != 0) {
            eventMemberJson["eventMemberId"] = eventMemberMO.eventMemberId;
        }
        eventMemberJson["name"] = eventMemberMO.name;
        eventMemberJson["userContactId"] = eventMemberMO.userContactId;
        
        if (eventMemberMO.userId != 0) {
            eventMemberJson["userId"] = eventMemberMO.userId;
        }
        
        if (eventMemberMO.status != nil) {
            eventMemberJson["status"] = eventMemberMO.status;
        }
        return eventMemberJson;

    }
}
