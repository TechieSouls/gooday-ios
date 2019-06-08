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

// Live Server
//let apiUrl = "http://ec2-18-216-7-227.us-east-2.compute.amazonaws.com/"

let apiUrl = "https://deploy.cenesgroup.com/"
//let apiUrl = "http://192.168.1.100:8181/"
//let apiUrl = "http://localhost:8181/"
//let apiUrl = "http://172.20.10.2:8181/";


class WebService
{
    
    var requestArray = NSMutableArray()
    
    func emailSignIn(email :String ,password :String,complete: @escaping(NSMutableDictionary)->Void )
    {
        let parameters: Parameters = [
            "authType": "email",
            "email": email,
            "password": password
        ]
        print( "Inside emailSignIn")
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        // Both calls are equivalent
        Alamofire.request("\(apiUrl)auth/user/authenticate/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON
            { (response ) in
                switch response.result {
                case .success:
                    
                    print("emailSignIn Validation Successful")
                    let json = response.result.value as! NSDictionary
                    
                    print(json)
                    
                    if json["errorCode"] as? Int == 0 {
                        
                        let userId = json.object(forKey: "userId")
                        let token = json.object(forKey: "token")
                        let email = json.object(forKey: "email")
                        let name = json.object(forKey: "name")
                        
                        
                        if let photo = json.object(forKey:"photo") as? String {
                            setting.setValue(photo, forKey: "photo")
                        }
                        if let genderUser = json.object(forKey:"gender") as? String {
                            setting.setValue(genderUser, forKey: "gender")
                        }
                        
                        setting.setValue(userId!, forKey: "userId")
                        setting.setValue(name!, forKey: "name")
                        setting.setValue(email!, forKey: "email")
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
    func uploadProfilePic(image :UIImage?, complete: @escaping(NSMutableDictionary)->Void)
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

        }, usingThreshold: UInt64.init(), to: "\(apiUrl)api/profile/upload/", method: .post, headers:Auth_header) { (result) in
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
        Alamofire.request("\(apiUrl)api/users/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { (response ) in
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
                    if let genderUser = json.object(forKey:"gender") as? String {
                        setting.setValue(genderUser, forKey: "gender")
                    }
                    let name = json.object(forKey: "name")
                    setting.setValue(userId!, forKey: "userId")
                    setting.setValue(token!, forKey: "token")
                    if let email = json.object(forKey:"email") as? String {
                         setting.setValue(email, forKey: "email")
                    }
                    
                    setting.setValue(name,forKey:"name")
                    returnedDict["data"] = json
                    
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
        Alamofire.request("\(apiUrl)auth/user/authenticate/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { (response ) in
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
    
    
    
    func resetPassword(email :String ,complete: @escaping(NSMutableDictionary)->Void)
    {
       
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        // Both calls are equivalent
        Alamofire.request("\(apiUrl)auth/forgetPassword?email=\(email)", method: .get, parameters: nil, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { (response ) in
            switch response.result {
            case .success:
                print( "reset Password Successful")
                
                let dict = response.result.value as! NSDictionary
                if dict["success"] as! Bool == true {
                    
                }else{
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = dict["errorDetail"] as! String
                }
                complete(returnedDict)
                
            case .failure(let error):
                print(error)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = error.localizedDescription
                complete(returnedDict)
            }
            
            
        }
    }
    
    
    
    func facebookEvent(facebookAuthToken :String ,cenesToken : String ,facebookID :String,complete: @escaping(NSMutableDictionary)->Void)
    {
        print("facebookEvent")
        let Auth_header    = [ "token" : cenesToken ]
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        Alamofire.request("\(apiUrl)api/facebook/events/\(facebookID)/\(facebookAuthToken)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON {  response in
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
    
    func googleEvent(googleAuthToken :String,serverAuthCode :String, complete: @escaping(Bool)->Void)
    {
        print("googleEvent")
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let queryStr :String = "access_token=\(googleAuthToken)&serverAuthCode=\(serverAuthCode)&user_id=\(uid)"
        Alamofire.request("\(apiUrl)api/google/events?\(queryStr)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON {  response in
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
    
    func outlookEvent(outlookAuthToken :String, refreshToken :String, complete: @escaping(Bool)->Void)
    {
        print("outlookEvent")
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let outlookAuthToken = outlookAuthToken.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("\(apiUrl)api/iosoutlook/events?access_token=\(outlookAuthToken)&user_id=\(uid)&refreshToken=\(refreshToken)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON {  response in
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
    
    func meTime(submitArray:[NSMutableDictionary],complete: @escaping(Bool)->Void)
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
        Alamofire.request("\(apiUrl)api/user/metime", method: .post, parameters: params, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON{
            (response ) in
            switch response.result {
            case .success:
                print( "meTime Validation Successful")
                let json = response.result.value as! NSDictionary
                print(json)
                complete(true)
                break
            case .failure(let error):
                print(error)
                complete(false)
                break
            }
        }
    }
    
    
    
    
    func setPushToken() {
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
        Alamofire.request("\(apiUrl)api/user/registerdevice", method: .post, parameters: params, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON{
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
        
        
        Alamofire.request("\(apiUrl)api/holiday/calendar/events?calendar_id=\(calendarName)&user_id=\(uid)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON{
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
                   completion(#imageLiteral(resourceName: "profile icon"))
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
        
        Alamofire.request("\(apiUrl)api/getEvents?user_id=\(uid)&date=\(dateString)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
        //Alamofire.request("\(apiUrl)api/getEvents?user_id=8&date=\(dateString)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
        
        
      let req =  Alamofire.request("\(apiUrl)api/user/friends?user_id=\(uid)&search=\(searchSTr)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
        
        let req =  Alamofire.request("https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58&input=\(searchSTr)", method: .get, parameters: nil, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : [String: Any] = [:]
            switch response.result {
            case .success:
                json = response.result.value as! [String: Any]
                returnedDict["data"] = json["predictions"]
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
    
    func getGatheringEvents(type: String,complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside Getting Gathering data")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""

        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("\(apiUrl)api/user/gatherings?user_id=\(uid)&status=\(type)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
    
    func getDiaries(complete: @escaping([String: Any])->Void){
        print( "Inside Getting Diaries")
        // Both calls are equivalent
        
        var returnedDict: [String: Any] = [:]
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("\(apiUrl)api/diary/list?userId=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            switch response.result {
            case .success:
                print( "get Diary Successful")
                
                
                let json = response.result.value as! [String:Any]
                
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
    
    func uploadDiaryImage(image : UIImage? , complete: @escaping(NSMutableDictionary)->Void)
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
            
        }, usingThreshold: UInt64.init(), to: "\(apiUrl)api/diary/upload", method: .post, headers:Auth_header) { (result) in
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
        
        
        Alamofire.request("\(apiUrl)api/user/syncdevicecalendar", method: .post , parameters: params, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
        
        
        Alamofire.request("\(apiUrl)api/reminder/save", method: .post , parameters: params, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
        print("\(apiUrl)api/reminder/list")
        
        Alamofire.request("\(apiUrl)api/reminder/list?user_id=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
        
        Alamofire.request("\(apiUrl)api/events/holidays?user_id=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
        
        Alamofire.request("\(apiUrl)api/notification/byuser?userId=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
    
    func getNotificationsRead( complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside getting Notifications read data")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]

        Alamofire.request("\(apiUrl)api/notification/markReadByUserIdAndNotifyId?userId=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
    
    
    
    func getNotificationsCounter(complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside getting Notifications data")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("\(apiUrl)api/notification/unreadbyuser?userId=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
        
        Alamofire.request("\(apiUrl)api/event/\(eventid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : NSDictionary!
            switch response.result {
            case .success:
                print("getting event details Successful")
                
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
    
    func removeReminder(reminderID: String, complete: @escaping([String: Any])-> Void) {
        var returnedDict: [String: Any] = [:]
        
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        let Auth_header = [ "token" : setting.value(forKey: "token") as! String ]

        Alamofire.request("\(apiUrl)api/reminder/delete?reminderId=\(reminderID)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            switch response.result {
            case .success:
                print("Deleting reminder Successful")
                
                let json = response.result.value as! [String: Any]
                
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
    
    func updateReminderInviteStatus(memeberID: String, inviteStatus: String, complete: @escaping([String: Any])->Void) {
        var responseDict: [String: Any] = [:]
        responseDict["Error"] = false
        responseDict["ErrorMsg"] = ""
        
        let auth_Header = [ "token" : setting.value(forKey: "token") as! String ]

//        /api/reminder/updateReminderMemberStatus?reminderMemberId=&status=Accept/Declined
        Alamofire.request("\(apiUrl)api/reminder/updateReminderMemberStatus?reminderMemberId=\(memeberID)&status=\(inviteStatus)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: auth_Header).validate(statusCode: 200..<300).responseJSON { (response ) in
            switch response.result {
            case .success:
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    responseDict["data"] = json["data"]
                }else {
                    responseDict["Error"] = true
                    responseDict["ErrorMsg"] = json["errorDetail"] as? String
                }
                
                print(json)
                break
            case .failure(let error):
                print(error)
                responseDict["Error"] = true
                responseDict["ErrorMsg"] = error.localizedDescription
                break
            }
            complete(responseDict)
        }
    }
    
    func acceptReminderInvite(reminderId: String, complete: @escaping([String: Any])->Void) {
        var responseDict: [String: Any] = [:]
        responseDict["Error"] = false
        responseDict["ErrorMsg"] = ""
        
        let auth_Header = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("\(apiUrl)api/reminder/fetch?reminderId=\(reminderId)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: auth_Header).validate(statusCode: 200..<300).responseJSON { (response ) in
            switch response.result {
            case .success:
                let json = response.result.value as! NSDictionary
                
                if json["errorCode"] as? Int == 0 {
                    responseDict["data"] = json["data"]
                }else {
                    responseDict["Error"] = true
                    responseDict["ErrorMsg"] = json["errorDetail"] as? String
                }
                
                print(json)
                break
            case .failure(let error):
                print(error)
                responseDict["Error"] = true
                responseDict["ErrorMsg"] = error.localizedDescription
                break
            }
            complete(responseDict)
        }
    }
    
    
    func deleteDiary(diaryId:String,complete: @escaping(NSMutableDictionary)->Void){
        print( "Inside deleting Diary")
        // Both calls are equivalent
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("\(apiUrl)api/diary/delete?diaryId=\(diaryId)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            switch response.result {
            case .success:
                print("Deleting Diary Successful")
                
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
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        Alamofire.request("\(apiUrl)api/reminder/updateToFinish?reminder_id=\(reminderId)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
        
        Alamofire.request("\(apiUrl)api/event/delete?event_id=\(eventId)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
    
    
    func calendarSyncStatus(complete: @escaping([String: Any])->Void){
        print( "Inside calendar sync status")
        // Both calls are equivalent
        
        var returnedDict: [String: Any] = [:]
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        
        Alamofire.request("\(apiUrl)api/user/calendarsyncstatus/\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : [String: Any] = [:]
            switch response.result {
            case .success:
                json = response.result.value as! [String: Any]
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"] as? NSArray
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
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
        
    }
    
    func meTimeStatus(complete: @escaping([String: Any])->Void){
        print( "Inside meTime data")
        // Both calls are equivalent
        
        var returnedDict: [String: Any] = [:]
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        Alamofire.request("\(apiUrl)api/user/getmetimes?user_id=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
        //Alamofire.request("\(apiUrl)api/user/getmetimes?user_id=22", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : [String: Any] = [:]
            switch response.result {
            case .success:
                json = response.result.value as! [String: Any]
                
                if json["errorCode"] as? Int == 0 {
                    
                    returnedDict["data"] = json["data"] as? NSArray
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
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
        
        Alamofire.request("\(apiUrl)api/event/update?event_member_id=\(eventMemberId)&status=\(status)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
    
    
    func createDiary(uploadDict : [String : Any],complete: @escaping(NSMutableDictionary)->Void )
    {
        
        print( "Inside creating Diary data")
        // Both calls are equivalent
        
        
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let params : Parameters = uploadDict
        
        var returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        
        Alamofire.request("\(apiUrl)api/diary/save", method: .post , parameters: params, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            print("Got response \(response.result)")
            
            switch response.result {
            case .success:
                print( "create diary Successful")
                
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
    
    func updateProfile(email :String ,name :String ,gender :String ,photoUrl :String,complete: @escaping(NSMutableDictionary)->Void )
    {
        
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        var parameters : Parameters!
        if photoUrl == "" {
            parameters = [
                "userId": uid,
                "email": email,
                "name": name,
                "gender": gender,
            ]
        }else{
         parameters = [
            "userId": uid,
            "email": email,
            "name": name,
            "gender": gender,
            "photo":photoUrl,
            ]
        }
        print( "Inside profileUpdate")
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        // Both calls are equivalent
        Alamofire.request("\(apiUrl)api/user/update/", method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON
            { (response ) in
                switch response.result {
                case .success:
                    print("update profile Successful")
                    debugPrint(response.result.value ?? "no value")
                    
                    let json = response.result.value as! NSDictionary
                    
                    if json["errorCode"] as? Int == 0 {
                        
                        
                        
                        
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
    
    
    func logout(complete: @escaping([String: Any])->Void){
        print( "Inside Logout")
        // Both calls are equivalent
        
        var returnedDict: [String: Any] = [:]
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        
        Alamofire.request("\(apiUrl)api/user/logout?userId=\(uid)&deviceType=ios", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : [String: Any] = [:]
            switch response.result {
            case .success:
                json = response.result.value as! [String: Any]
                
                if json["errorCode"] as? Int == 0 {
                    
                }else {
                    returnedDict["Error"] = true
                    returnedDict["ErrorMsg"] = json["errorDetail"] as? String
                    
                }
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
        
    }
    
    func resetBadgeCount() {
        
        if (setting.object(forKey: "token") != nil) {
            let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
            
            let userid = setting.value(forKey: "userId") as! NSNumber
            let uid = "\(userid)"
            
            Alamofire.request("\(apiUrl)api/notification/setBadgeCountsToZero?userId=\(uid)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
                
            }
        }
    }
    
}
