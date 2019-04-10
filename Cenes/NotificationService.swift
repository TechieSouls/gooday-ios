//
//  NotificationService.swift
//  Deploy
//
//  Created by Cenes_Dev on 11/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire

class NotificationService {
    
    let get_mark_notification_as_read = "/api/notification//api/notification/markReadByUserIdAndNotifyId"; //userId,notificationTypeId
    
    let mark_notification_as_read = "/api/notification/markReadByNotificationId"; //notification Id
    
    let get_pageable_notifications = "/api/notification/byuserpageable"; //userId, pageNumber, offset
    
    let get_notification_counts = "/api/notification/counts"; //userId
    
    let get_badge_counts = "/api/notification/getBadgeCounts"; //User Id

    var requestArray = NSMutableArray()
    
    func getPageableNotifications(queryStr: String,token : String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(get_pageable_notifications)?\(queryStr)";
        print("API Url : \(url)")
        
        HttpService().getMethod(url: url, token: token, complete: { (response ) in
            complete(response);
        });
    };
    
    func markNotificationReadByNotificationId(queryStr: String,token : String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(mark_notification_as_read)?\(queryStr)";
        print("API Url : \(url)")
        
        HttpService().getMethod(url: url, token: token, complete: { (response ) in
            complete(response);
        });
    };
    
    func findNotificationCounts(queryStr: String,token : String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(get_notification_counts)?\(queryStr)";
        print("API Url : \(url)")
        
        HttpService().getMethod(url: url, token: token, complete: { (response ) in
            complete(response);
        });
    };
    
    func findNotificationBadgeCounts(queryStr: String,token : String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(get_badge_counts)?\(queryStr)";
        print("API Url : \(url)")
        
        HttpService().getMethod(url: url, token: token, complete: { (response ) in
            complete(response);
        });
    };
    
    func markNotificationAsRead(queryStr: String, complete: @escaping(NSMutableDictionary)->Void) {
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let url = "\(apiUrl)\(get_mark_notification_as_read)?\(queryStr)";
        print("API Url : \(url)")
        let req = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:Auth_header).validate(statusCode: 200..<300).responseJSON{
            (response ) in
            
            print(response);
            let json = response.result.value as! NSDictionary
            
            //returnedDict["data"] = json.value(forKey: "data")
            returnedDict["success"] = json.value(forKey: "success")
            
            complete(returnedDict)
            
        }
        self.requestArray.add(req)
    }
}
