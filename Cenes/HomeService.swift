//
//  HomeService.swift
//  Deploy
//
//  Created by Macbook on 28/10/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire

class HomeService {
    
    var requestArray = NSMutableArray()
    
    func refreshGoogleEvents(complete: @escaping(NSMutableDictionary)->Void ) {
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        print( "Syncing Google Events")
        // Both calls are equivalent
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        let req =  Alamofire.request("\(apiUrl)api/google/refreshEvents?userId=\(uid)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            complete(returnedDict)
        }
        
        self.requestArray.add(req)
    }
    
    func refreshOutlookEvents(complete: @escaping(NSMutableDictionary)->Void ) {
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        print( "Syncing Outlook Events")
        // Both calls are equivalent
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        let req =  Alamofire.request("\(apiUrl)api/outlook/refreshevents?userId=\(uid)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            complete(returnedDict)
        }
        
        self.requestArray.add(req)
    }
}
