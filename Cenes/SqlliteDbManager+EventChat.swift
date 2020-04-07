//
//  SqlliteDbManager+EventChat.swift
//  Cenes
//
//  Created by Cenes_Dev on 19/03/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite
extension SqlliteDbManager {

    func createTableEventChats() {
        do {
            let cenesUsers = Table("event_chats")
            let eventChatId = Expression<Int64>("event_chat_id")
            let senderId = Expression<Int64>("sender_id")
            let eventId = Expression<Int64>("event_id")
            let chat = Expression<String>("chat")
            let createdAt = Expression<Int64>("created_at")
            let chatStatus = Expression<String>("chat_status")
            let synced = Expression<Bool>("synced")

            try database.run(cenesUsers.create { t in
                t.column(eventChatId, defaultValue: 0)
                t.column(senderId, defaultValue: 0)
                t.column(eventId, defaultValue: 0)
                t.column(chat, defaultValue: "")
                t.column(createdAt, defaultValue: 0)
                t.column(chatStatus, defaultValue: "Read")
                t.column(synced, defaultValue: true)
            })
        } catch {
            print("Error in createTableEventChats : ", error)
        }
    }
    
    func saveEventChat(eventChat: EventChat) {
     
        do {
            let stmt = try database.prepare("INSERT into event_chats (event_chat_id, sender_id, event_id, chat, created_at, created_at, synced) VALUES (?, ?, ?, ?, ?, ?, ?)");
            
            try stmt.run(Int64(eventChat.eventChatId), Int64(eventChat.senderId), Int64(eventChat.eventId), eventChat.chat, Int64(eventChat.createdAt), eventChat.chatStatus);
            
        } catch {
            print("Error in saveEventChat : ", error);
        }
    }
    
    func findEventChatByEventId(eventId: Int32) -> [EventChat] {
        
        var eventChats = [EventChat]();
        do {
            let stmt = try database.prepare("SELECT * from event_chats where event_chat_id = ?");
            for eventChatsDb in try stmt.run(Int64(eventId)) {
                
                let eventChat = EventChat();
                eventChat.eventChatId = Int32(eventChatsDb[0] as! Int64);
                eventChat.senderId = Int32(eventChatsDb[1] as! Int64);
                eventChat.eventId = Int32(eventChatsDb[2] as! Int64);
                eventChat.chat = (eventChatsDb[3] as! String);
                eventChat.createdAt = (eventChatsDb[4] as! Int64);
                eventChat.chatStatus = (eventChatsDb[5] as! String);
                eventChat.synced = (eventChatsDb[6] as! Bool);

                eventChats.append(eventChat);
            }
        } catch {
            print("Error in findEventChatByEventId : ", error)
        }
        return eventChats;
    }
    
    func deleteEventChatByEventId(eventId: Int32) {
        do {
            let stmt = try database.prepare("DELETE from event_chats where event_id = ?");
            try stmt.run(Int64(eventId));
        } catch {
            print("Error in deleteEventChatByEventId : ", error);
        }
    }
}
