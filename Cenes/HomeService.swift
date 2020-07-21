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
    
    let get_month_wise_events: String = "api/getEventsMonthWise/v3";
    let get_home_events: String = "api/getEvents/android/v2";
    let get_past_home_events: String = "api/getPastEvents/v2";
    let get_home_calendar_events: String = "api/homeCalendarEvents/v2";
    let get_delete_event: String = "api/event/delete";
    let get_refresh_google_sync: String = "api/google/refreshEvents";
    let get_outlook_google_sync: String = "api/outlook/refreshEvents";

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
    
    func getHomeEvents(queryStr :String ,token : String ,complete: @escaping(NSDictionary)->Void ) {
        
        let url = "\(apiUrl)\(get_home_events)?\(queryStr)"
        print("API : \(url)")
        
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response)
        });
    }
    
    func getMonthWiseEvents(queryStr :String ,token : String ,complete: @escaping(NSDictionary)->Void ) {
        
        let url = "\(apiUrl)\(get_month_wise_events)?\(queryStr)"
        print("API : \(url)")
        
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response)
        });
    }
    
    func getHomeCalendarEvents(queryStr :String ,token : String ,complete: @escaping(NSDictionary)->Void ) {
        
        let url = "\(apiUrl)\(get_home_calendar_events)?\(queryStr)"
        print("API : \(url)")
        
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response)
        });
    }
    
    func getHomePastEvents(queryStr :String ,token : String ,complete: @escaping(NSDictionary)->Void ) {
        
        let url = "\(apiUrl)\(get_past_home_events)?\(queryStr)"
        print("API : \(url)")
        
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response)
        });
    }
    
    func removeEventFromList(queryStr :String ,token : String ,complete: @escaping(NSDictionary)->Void ) {
       
        let url = "\(apiUrl)\(get_delete_event)?\(queryStr)";
        
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response);
        });
    }
    
    func getSyncGoogleCalendar(queryStr :String ,token : String ,complete: @escaping(NSDictionary)->Void ) {
        
        let url = "\(apiUrl)\(get_refresh_google_sync)?\(queryStr)"
        print("API : \(url)")
        
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response)
        });
    }
    
    func getSyncOutlookCalendar(queryStr :String ,token : String ,complete: @escaping(NSDictionary)->Void ) {
        
        let url = "\(apiUrl)\(get_outlook_google_sync)?\(queryStr)"
        print("API : \(url)")
        
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response)
        });
    }
}
