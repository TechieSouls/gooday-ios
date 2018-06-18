//
//  Services.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/25/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import Foundation
import Alamofire
var imageFacebookURL :String?
class WebService
{
    
    var requestArray = NSMutableArray()
    
    func emailSignUp(email :String ,name :String ,password :String ,username :String,complete: @escaping(NSMutableDictionary)->Void )
    {
        let parameters: Parameters = [
            "authType": "email",
            "email": email,
            "name": name,
            "password": password,
        ]
        print( "Inside emailSignUp")
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        // Both calls are equivalent
    Alamofire.request("http://cenes.test2.redblink.net/api/users/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON
            { (response ) in
            switch response.result {
                case .success:
                print("emailSignUp Validation Successful")
                debugPrint(response.result.value ?? "no value")
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    let userId = json.object(forKey: "userId")
                    let token = json.object(forKey: "token")
                    setting.setValue(userId!, forKey: "userId")
                    setting.setValue(token!, forKey: "token")
                    
                    
                }else if json["errorCode"] as? Int == 103 {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = "Email Already Taken."
                    
                }else{
                    //Work to do
                }
                
                
                case .failure(let error):
                 print(error)
                 returnedDict["Error"] = true
                 returnedDict["ErrorMsg"] = error.localizedDescription
        }
        complete(returnedDict)
      }
        
    }
    func emailSignIn(email :String ,password :String ,complete: @escaping(NSMutableDictionary)->Void )
    {
        let parameters: Parameters = [
            "authType": "email",
            "email": email,
            "password": password,
        ]
        print( "Inside emailSignIn")
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        // Both calls are equivalent
        Alamofire.request("http://cenes.test2.redblink.net/auth/user/authenticate/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON
            { (response ) in
                switch response.result {
                case .success:
                    
                    
                    
                    
                    print("emailSignIn Validation Successful")
                    let json = response.result.value as! NSDictionary
                    
                    print(json)
                    
                    if json["errorCode"] as? Int == 0 {
                        
                        let userId = json.object(forKey: "userId")
                        let token = json.object(forKey: "token")
                        let name = json.object(forKey: "name")
                        if let photo = json.object(forKey:"photo") as? String {
                            setting.setValue(photo, forKey: "photo")
                        }
                        setting.setValue(userId!, forKey: "userId")
                        setting.setValue(name!, forKey: "name")
                        setting.setValue(token!, forKey: "token")
                        
                        
                    }else if json["errorCode"] as? Int == 100 {
                        returnedDict["Error"] = true
                        returnedDict["ErrorMsg"] = "Incorrect Email or Password."
                        
                    }else{
                        //Work to do
                    }
                    
                    
                case .failure(let error):
                    print(error)
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = error.localizedDescription
                }
            complete(returnedDict)
        }
        
    }
    func uploadProfilePic(image :UIImage?)
    {
        guard image != nil else { return }
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        let id = setting.integer(forKey: "userId")
        let token =  setting.string(forKey: "token")
        guard token != nil else { return }
        let Auth_header    = ["token" : token!]
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "mediaFile", fileName: "file.jpg", mimeType: "image/jpg")
            MultipartFormData.append( "\(id)".data(using: .utf8)!, withName: "userId")

        }, usingThreshold: UInt64.init(), to: "http://cenes.test2.redblink.net/api/profile/upload/", method: .post, headers:Auth_header) { (result) in
            switch result {
            case .success(let upload,_,_):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    print("Suceess:\(String(describing: response.result.value ))")
                    let json = response.result.value as! NSDictionary
                    let photo = json.object(forKey: "photo")
                    setting.set(photo!, forKey: "photo")
                
                }
                case .failure(let encodingError):
                print(encodingError)
            }
        }
        
      }

    func facebookSignUp(facebookAuthToken :String ,facebookID :String,complete: @escaping(NSMutableDictionary)->Void )
    {
        let parameters: Parameters = [
            "authType": "facebook",
            "facebookAuthToken": facebookAuthToken,
            "facebookID": facebookID,
        ]
        print( "Inside facebookSignUp")
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        print (parameters)
        // Both calls are equivalent
        Alamofire.request("http://cenes.test2.redblink.net/api/users/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { (response ) in
            switch response.result {
            case .success:
                
                
                print("emailSignIn Validation Successful")
                let json = response.result.value as! NSDictionary
                
                print(json)
                
                if json["errorCode"] as? Int == 0 {
                    
                    let userId = json.object(forKey: "userId")
                    let token = json.object(forKey: "token")
                    if let photo = json.object(forKey:"photo") as? String {
                        setting.setValue(photo, forKey: "photo")
                    }
                    setting.setValue(userId!, forKey: "userId")
                    setting.setValue(token!, forKey: "token")
                    
                    
                }else if json["errorCode"] as? Int == 100 {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = "Incorrect Email or Password."
                    
                }else{
                    //Work to do
                }
            case .failure(let error):
                print(error)
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            complete(returnedDict)
        }
    }
    func facebookSignIn(facebookAuthToken :String ,facebookID :String,complete: @escaping(Bool)->Void )
    {
        let parameters: Parameters = [
            "authType": "facebook",
            "facebookAuthToken": facebookAuthToken,
            "facebookID": facebookID,
            ]
        print( "Inside facebookSignIn")
        print (parameters)
        // Both calls are equivalent
        Alamofire.request("http://cenes.test2.redblink.net/auth/user/authenticate/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { (response ) in
            switch response.result {
            case .success:
                print( "facebookSignIn Validation Successful")
                let json = response.result.value as! NSDictionary
                let userId = json.object(forKey: "userId")
                let token = json.object(forKey: "token")
                let isNew = json.object(forKey: "isNew")
                print(json)
                print(userId!)
                setting.setValue(userId!, forKey: "userId")
                setting.setValue(token!, forKey: "token")
                setting.setValue(isNew!, forKey: "isNew")
            case .failure(let error):
                print(error)
                
            }
            complete(true)
        }
    }

    func facebookEvent(facebookAuthToken :String ,cenesToken : String ,facebookID :String,complete: @escaping(NSMutableDictionary)->Void)
    {
        print("facebookEvent")
        let Auth_header    = [ "token" : cenesToken ]
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        Alamofire.request("http://cenes.test2.redblink.net/api/facebook/events/\(facebookID)/\(facebookAuthToken)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON {  response in
            switch response.result {
            case .success:
            print("Validation Successful")
            debugPrint(response)
            case .failure(let error):
            print(error)
            returnedDict["Error"] = true
            returnedDict["ErrorMsg"] = error.localizedDescription
            }
            
            complete(returnedDict)
        }
        

    }
    
    func googleEvent(googleAuthToken :String,complete: @escaping(Bool)->Void)
    {
        print("googleEvent")
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("http://cenes.test2.redblink.net/api/google/events?access_token=\(googleAuthToken)&user_id=\(uid)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON {  response in
            switch response.result {
            case .success:
                print("Validation Successful")
                debugPrint(response)
                complete(true)
            case .failure(let error):
                print(error)
                complete(false)
            }
        }
        
    }
    
    
    func meTime(submitArray:[NSMutableDictionary])
    {
        print("me Time")
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let params:Parameters = [
            "user_id" :uid,
            "events" :
                submitArray,
            "timezone":"Asia/Kolkata"]
        
        
//        let params:Parameters = [
//            "user_id" : "1",
//            "events" :
//                [["day_of_week" : "Monday",
//                  "title" : "Office Time",
//                  "description":"Time to go office",
//                  "start_time":"09:00AM",
//                  "end_time":"06:30PM"],
//                 ["day_of_week" : "Monday",
//                  "title" : "Gym Time",
//                  "description":"Time to go Gym",
//                  "start_time":"07:00PM",
//                  "end_time":"08:00PM"],
//                 ["day_of_week" : "Monday",
//                  "title" : "Bed Time",
//                  "description":"Time to sleep",
//                  "start_time":"10:00PM",
//                  "end_time":"06:00AM"]],
//            "timezone":"Asia/Kolkata",
//            "do_not_disturb" : true]
        let token =  setting.string(forKey: "token")
        guard token != nil else { return }
        let Auth_header    = ["token" : token!]
        // Both calls are equivalent
        Alamofire.request("http://cenes.test2.redblink.net/api/user/metime", method: .post, parameters: params, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON{
            (response ) in
            switch response.result {
            case .success:
                print( "meTime Validation Successful")
                let json = response.result.value as! NSDictionary
                print(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func setPushToken()
    {
        print("me Time")
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
       
        let tokenPush = UserDefaults.standard.object(forKey: "tokenData") as? String
        if tokenPush != nil {
        let params:Parameters = [
            "userId" :uid,
            "deviceToken" :
            tokenPush,
            "deviceType":"ios"]
        
        let token =  setting.string(forKey: "token")
        guard token != nil else { return }
        let Auth_header    = ["token" : token!]
        // Both calls are equivalent
        Alamofire.request("http://cenes.test2.redblink.net/api/user/registerdevice", method: .post, parameters: params, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON{
            (response ) in
            switch response.result {
            case .success:
                print( "set token Successful")
                let json = response.result.value as! NSDictionary
                print(json)
            case .failure(let error):
                print(error)
            }
        }
        }
    }

    func holidayCalendar(calenderName:String,complete: @escaping(Bool)->Void)
    {
        print("holiday calendar Time")
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        
        
        let token =  setting.string(forKey: "token")
        guard token != nil else { return }
        let Auth_header    = ["token" : token!]
        // Both calls are equivalent
        
        let calendarName = calenderName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        
        Alamofire.request("http://cenes.test2.redblink.net/api/holiday/calendar/events?calendar_id=\(calendarName)&user_id=\(uid)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON{
            (response ) in
            switch response.result {
            case .success:
                print( "holiday Validation Successful")
                let json = response.result.value as! NSArray
                print(json)
            case .failure(let error):
                print(error)
            }
            complete(true)
        }
    }
    
    
    
    
    
    
    func profilePicFromFacebook(url:String,completion: @escaping (UIImage?) -> Void)
    {
             Alamofire.request(url, method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default).validate().responseData { response in
                if let data = response.result.value {
                   let image = UIImage(data: data)
                   completion(image)
                }
                else
                {
                   completion(nil)
                }
            }
    }
    
    
    func getHomeEvents(dateString :String ,timeZoneString : String ,complete: @escaping(NSMutableDictionary)->Void )
    {
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"

        print( "Inside HomeEvents")
        // Both calls are equivalent
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        Alamofire.request("http://cenes.test2.redblink.net/api/getEvents?user_id=\(uid)&date=\(dateString)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : NSDictionary!
            switch response.result {
            case .success:
                print( "home Events Successful")
                
                json = response.result.value as! NSDictionary
                
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                
                print(json)
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            
            complete(returnedDict)
        }
    }
    
    
    
    func getFriends(nameString :String ,complete: @escaping(NSMutableDictionary)->Void )
    {
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        print( "Inside Friend Invite")
        // Both calls are equivalent
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        
      let req =  Alamofire.request("http://cenes.test2.redblink.net/api/user/friends?user_id=\(uid)&search=\(searchSTr)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            //var json : NSDictionary!
            switch response.result {
            case .success:
                print( "Friends Events Successful")
                
                returnedDict["data"] = response.result.value as! NSArray
                
                
//                json = response.result.value as! NSDictionary
//                
//                
//                let json = response.result.value as! NSDictionary
//                
//                if json["errorCode"] as? Int == 0 {
//                    
//                    returnedDict["data"] = json["data"]
//                    
//                    
//                }else {
//                    returnedDict["Error"] = true
//                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
//                    
//                }
//                
//                
//                print(json)
                
            case .failure(let error):
                print(error)
                
                let errorX = error as NSError
                
                if errorX.code == -999 {
                        returnedDict["data"] = NSArray()
                }else{
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
                }
            }
            
            complete(returnedDict)
        }
        
        self.requestArray.add(req)
    }
    
    func getLocation(nameString :String ,complete: @escaping([String: Any])->Void ) {
        // Both calls are equivalent
        
        var returnedDict: [String: Any] = [:]
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let req =  Alamofire.request("https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58&query=\(searchSTr)", method: .get, parameters: nil, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : [String: Any] = [:]
            switch response.result {
            case .success:
                json = response.result.value as! [String: Any]
                returnedDict["data"] = json["results"]
            case .failure(let error):
                let errorX = error as NSError
                if errorX.code == -999 {
                    returnedDict["data"] = NSArray()
                }else{
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = error.localizedDescription
                }
            }
            complete(returnedDict)
        }
        self.requestArray.add(req)
    }
    
    
    func cancelAll(){
        
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
//            uploadData.forEach { $0.cancel() }
//            downloadData.forEach { $0.cancel() }
        }
//        var request : DataRequest!
//        
//        for i : Int in 0 ..< self.requestArray.count{
//            request = self.requestArray.object(at: i) as? Alamofire.Request as! DataRequest
//            request?.cancel()
//        }
    }

    func getPredictiveData(startTime :String, endTime:String ,friends:String,complete: @escaping(NSMutableDictionary)->Void )
    {
        
        print( "Inside Getting Predictive data")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        var urlString = ""
        
        if friends != "" {
             urlString = "http://cenes.test2.redblink.net/api/predictive/calendar?userId=\(uid)&start_time=\(startTime)&end_time=\(endTime)&friends=\(friends)"
        }else{
          urlString =   "http://cenes.test2.redblink.net/api/predictive/calendar?userId=\(uid)&start_time=\(startTime)&end_time=\(endTime)"
        }
        
        
        let req =  Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : NSArray!
            switch response.result {
            case .success:
                print( "Location Successful")
                
                returnedDict["data"] = response.result.value as! NSArray
                
                print(response.result.value)
                
            case .failure(let error):
                print(error)
                
                let errorX = error as NSError
                
                if errorX.code == -999 {
                    returnedDict["data"] = NSArray()
                }else{
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = error.localizedDescription
                }
            }
            
            complete(returnedDict)
        }
        
        self.requestArray.add(req)
    }
   
    
    func createGathering(uploadDict : [String : Any],complete: @escaping(NSMutableDictionary)->Void )
    {
        
        print( "Inside Getting Predictive data")
        // Both calls are equivalent
        
        
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let params : Parameters = uploadDict
        
        var returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        
        Alamofire.request("http://cenes.test2.redblink.net/api/event/create", method: .post , parameters: params, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            print("Got response \(response.result)")
            
            switch response.result {
            case .success:
                print( "create gathering Successful")
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                print(json)
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }

            complete(returnedDict)
            
        }
        
    }
    
    
    func getGatheringEvents(type: String,complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside Getting Gathering data")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""

        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("http://cenes.test2.redblink.net/api/user/gatherings?user_id=\(uid)&status=\(type)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : NSDictionary!
            switch response.result {
            case .success:
                print( "get gathering Successful")
                
                json = response.result.value as! NSDictionary
                
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                
                print(json)
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            
            
            complete(returnedDict)
        }

    }
    
    
    
    
    func uploadEventImage(image : UIImage? , complete: @escaping(NSMutableDictionary)->Void)
    {
        guard image != nil else { return }
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        let id = setting.integer(forKey: "userId")
        let token =  setting.string(forKey: "token")
        guard token != nil else { return }
        let Auth_header    = ["token" : token!]
        
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "mediaFile", fileName: "file.jpg", mimeType: "image/jpg")
            MultipartFormData.append( "\(id)".data(using: .utf8)!, withName: "userId")
            
        }, usingThreshold: UInt64.init(), to: "http://cenes.test2.redblink.net/api/event/upload", method: .post, headers:Auth_header) { (result) in
            switch result {
            case .success(let upload,_,_):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    print("Suceess:\(String(describing: response.result.value ))")
                    let json = response.result.value as! NSDictionary
                    
                    returnedDict["data"] = json
                     complete(returnedDict)
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = encodingError.localizedDescription
                 complete(returnedDict)
                
            }
           
        }
        
    }
    
    func syncDeviceCalendar(uploadDict : [String : Any],complete: @escaping(NSMutableDictionary)->Void )
    {
        
        print( "Inside Getting Device calendar data")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let params : Parameters = uploadDict
        
        
        Alamofire.request("http://cenes.test2.redblink.net/api/user/syncdevicecalendar", method: .post , parameters: params, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : NSDictionary!
            switch response.result {
            case .success:
                print( "device events call Successful")
                
                json = response.result.value as! NSDictionary
                
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                
                print(json)
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            
            
            complete(returnedDict)
        }
        
    }
    
    
    func addReminder(uploadDict : [String : Any],complete: @escaping(NSMutableDictionary)->Void )
    {
        
        print( "Inside Add REminder")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let params : Parameters = uploadDict
        
        
        Alamofire.request("http://cenes.test2.redblink.net/api/reminder/save", method: .post , parameters: params, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : NSDictionary!
            switch response.result {
            case .success:
                print( "device events call Successful")
                
                json = response.result.value as! NSDictionary
                
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                
                print(json)
                break
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
                break
            }
            
            
            complete(returnedDict)
        }
        
    }
    
    
    func getReminders(complete: @escaping([String: Any])->Void){
        
        var returnedDict: [String: Any] = [:]
        
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("http://cenes.test2.redblink.net/api/reminder/list?user_id=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            switch response.result {
            case .success:
                let json = response.result.value as! [String: Any]
                if json["errorCode"] as? Int == 0 {
                    returnedDict["data"] = json["data"]
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                }
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            complete(returnedDict)
        }
    }
    
    func getHolidays(complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside getting Holidays data")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("http://cenes.test2.redblink.net/api/events/holidays?user_id=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : NSDictionary!
            switch response.result {
            case .success:
                print("getting holidays Successful")
                
                json = response.result.value as! NSDictionary
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                print(json)
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            
            
            complete(returnedDict)
        }
        
    }
    
    func getNotifications(complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside getting Notifications data")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("http://cenes.test2.redblink.net/api/notification/byuser?userId=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : NSDictionary!
            switch response.result {
            case .success:
                print("getting holidays Successful")
                
                json = response.result.value as! NSDictionary
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                print(json)
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            
            
            complete(returnedDict)
        }
        
    }
    
    func getEventDetails(eventid:String,complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside getting Event details data")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("http://cenes.test2.redblink.net/api/event/\(eventid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : NSDictionary!
            switch response.result {
            case .success:
                print("getting holidays Successful")
                
                json = response.result.value as! NSDictionary
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                print(json)
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            
            
            complete(returnedDict)
        }
        
    }
    
    
    
    func deleteReminder(reminderId:String,complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside deleting reminder")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("http://cenes.test2.redblink.net/api/reminder/updateToFinish?reminder_id=\(reminderId)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            switch response.result {
            case .success:
                print("Deleting reminder Successful")
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                print(json)
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            
            
            complete(returnedDict)
        }
        
    }
    
    func deleteGathering(eventId:String,complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside deleting Gathering")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("http://cenes.test2.redblink.net/api/event/delete?event_id=\(eventId)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            switch response.result {
            case .success:
                print("Deleting gathering Successful")
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                print(json)
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            
            
            complete(returnedDict)
        }
        
    }
    
    func AcceptDeclineInvitation(eventMemberId:String,status:String,complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside Accept decilne status")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("http://cenes.test2.redblink.net/api/event/update?event_member_id=\(eventMemberId)&status=\(status)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            switch response.result {
            case .success:
                print("Accept/Decline Successful")
                
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"]
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
                
                print(json)
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
            }
            
            
            complete(returnedDict)
        }
        
    }
    
}
