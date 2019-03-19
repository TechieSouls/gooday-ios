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
    
    let get_mark_notification_as_read = "/api/notification/markReadByUserIdAndNotifyId"; //userId,notificationTypeId
    
    var requestArray = NSMutableArray()
    
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
