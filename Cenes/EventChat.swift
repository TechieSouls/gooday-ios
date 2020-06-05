//
//  EventChat.swift
//  Cenes
//
//  Created by Cenes_Dev on 10/03/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class EventChat {
    
    var eventChatId: Int32!;
    var chat: String!;
    var eventId: Int32!;
    var senderId: Int32!;
    var user: User!;
    var createdAt: Int64!
    var updateAt: Int64!
    var chatStatus: String!
    var synced: Bool!
    var chatType: String!
    var chatEdited: String!

    func populateEventChat(eventChatDict: NSDictionary) -> EventChat{
        
        let eventChat = EventChat();
        eventChat.eventChatId = (eventChatDict.value(forKey: "eventChatId") as! Int32);
        eventChat.chat = (eventChatDict.value(forKey: "chat") as! String);
        eventChat.eventId = (eventChatDict.value(forKey: "eventId") as! Int32);
        eventChat.senderId = (eventChatDict.value(forKey: "senderId") as! Int32);
        eventChat.createdAt = (eventChatDict.value(forKey: "createdAt") as! Int64);
        eventChat.updateAt = (eventChatDict.value(forKey: "updateAt") as! Int64);
        eventChat.chatStatus = (eventChatDict.value(forKey: "chatStatus") as! String);
        eventChat.chatType = (eventChatDict.value(forKey: "chatType") as! String);
        eventChat.chatEdited = (eventChatDict.value(forKey: "chatEdited") as! String);

        if let userDict = eventChatDict.value(forKey: "user") as? NSDictionary {
            eventChat.user = User().loadUserData(userDataDict: userDict);
        }
        return eventChat;

    }
    
    func populateEventChatFromArray(eventChatArray: NSArray) -> [EventChat]{
        
        var eventChatArr = [EventChat]();
        for eventChatItem in eventChatArray {
            let eventChatItemDict = eventChatItem as! NSDictionary;
            eventChatArr.append(populateEventChat(eventChatDict: eventChatItemDict));
        }
        return eventChatArr;
    }
}
class EventChatStatus {
    static let SENT: String = "Sent";
    static let READ: String = "Read";
}

class EventChatType {
    static let DESCRIPTION: String = "Description";
    static let CHAT: String = "Chat";
}

class EventChatEdited {
    
    static let YES: String = "Yes";
    static let NO: String = "No";
}

