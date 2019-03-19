//
//  UserService.swift
//  Cenes
//
//  Created by Macbook on 06/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire

class UserService {
    
    var requestArray = NSMutableArray()

    func emailSignUp(postSignupData: [String: String],complete: @escaping(NSMutableDictionary)->Void )
    {
        var parameters: Parameters = [
            "authType": "email",
            "email": postSignupData["email"] ?? "",
            "name": postSignupData["name"] ?? "",
            "password": postSignupData["password"] ?? "",
            "phone" : postSignupData["phone"] ?? ""
        ]
        
        if (postSignupData["picture"] != nil) {
            parameters["photo"] = postSignupData["picture"] ?? "";
            
            let webServ = WebService()
            webServ.profilePicFromFacebook(url: parameters["photo"]! as! String, completion: { image in
                DispatchQueue.main.async {
                    print("Image Downloaded")
                    appDelegate?.profileImageSet(image: image!)
                }
            })
        }
        print( "Inside emailSignUp")
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        // Both calls are equivalent
        
        Alamofire.request("\(apiUrl)api/users/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON
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
                        let name = json.object(forKey: "name")
                        let email = json.object(forKey: "email")
                        
                        
                        setting.setValue(userId!, forKey: "userId")
                        setting.setValue(name!, forKey: "name")
                        setting.setValue(email!, forKey: "email")
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
                        
                        var userPhoto = "";
                        if let photo = json.object(forKey:"photo") as? String {
                            userPhoto = photo;
                            setting.setValue(photo, forKey: "photo")
                        }
                        if let genderUser = json.object(forKey:"gender") as? String {
                            setting.setValue(genderUser, forKey: "gender")
                        }
                        
                        setting.setValue(userId!, forKey: "userId")
                        setting.setValue(name!, forKey: "name")
                        setting.setValue(email!, forKey: "email")
                        setting.setValue(token!, forKey: "token")
                        setting.setValue(token!, forKey: "birthDay")
                        setting.setValue(2, forKey: "onboarding")

                        if (userPhoto != "") {
                            let webServ = WebService()
                            webServ.profilePicFromFacebook(url: userPhoto, completion: { image in
                                DispatchQueue.main.async {
                                    print("Image Downloaded")
                                    appDelegate?.profileImageSet(image: image!)
                                }
                            })
                        }
                        
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
    
    func findUserFriendsByUserId(complete: @escaping(NSMutableDictionary) ->Void ) {
            let userid = setting.value(forKey: "userId") as! NSNumber
            let uid = "\(userid)"
            
            print( "Inside Friend Invite")
            // Both calls are equivalent
            
            let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
            
            let returnedDict = NSMutableDictionary()
            returnedDict["Error"] = false
            returnedDict["ErrorMsg"] = ""
            
            let req =  Alamofire.request("\(apiUrl)api/user/phonefriends?user_id=\(uid)", method: .get, parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
                
                //var json : NSDictionary!
                switch response.result {
                case .success:
                    print( "Friends Events Successful")
                    
                    returnedDict["data"] = response.result.value as! NSArray

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
                print(returnedDict);
                complete(returnedDict)
            }
            
            self.requestArray.add(req)
    }
    
    /**
     * This function will sync all the user device contacts and save in Database on server
     */
    func syncDevicePhoneNumbers(complete: @escaping(NSMutableDictionary)->Void) {
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let phoneNumbersDict = PhonebookService.phoneNumberWithContryCode();
        
        let returnedDict = NSMutableDictionary()
        if (phoneNumbersDict.count > 0) {
            let params:Parameters = [
                "userId" : uid,
                "contacts" : phoneNumbersDict]
            
            returnedDict["Error"] = false
            returnedDict["ErrorMsg"] = ""
            
            let req = Alamofire.request("\(apiUrl)api/syncContacts", method: .post, parameters: params, encoding: JSONEncoding.default, headers: Auth_header).validate(statusCode: 200..<300).responseJSON{
                (response ) in
                complete(returnedDict)
                
            }
            self.requestArray.add(req)

        } else {
            complete(returnedDict)
        }
        
    }
    
    func sendVerificationCode(countryCode: String, phoneNumber: String, complete: @escaping(NSMutableDictionary)->Void) {
        let returnedDict = NSMutableDictionary()
            let params:Parameters = [
                "countryCode" : countryCode,
                "phone" : phoneNumber]
            
            returnedDict["Error"] = false
            returnedDict["ErrorMsg"] = ""
            
        let req = Alamofire.request("\(apiUrl)api/guest/sendVerificationCode", method: .post, parameters: params, encoding: JSONEncoding.default, headers:nil).validate(statusCode: 200..<300).responseJSON{
                (response ) in
            
                let json = response.result.value as! NSDictionary
            
                returnedDict["messsage"] = json.value(forKey: "message")
            returnedDict["success"] = json.value(forKey: "success")
                complete(returnedDict)
                
            }
            self.requestArray.add(req)
    }
    
    func checkVerificationCode(countryCode: String, phoneNumber: String, code: String, complete: @escaping(NSMutableDictionary)->Void) {
        let returnedDict = NSMutableDictionary()
        let params:Parameters = [
            "countryCode" : countryCode,
            "phone" : phoneNumber,
            "code": code]
        
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        let req = Alamofire.request("\(apiUrl)api/guest/checkVerificationCode", method: .post, parameters: params, encoding: JSONEncoding.default, headers:nil).validate(statusCode: 200..<300).responseJSON{
            (response ) in
            
            let json = response.result.value as! NSDictionary
            
            returnedDict["message"] = json.value(forKey: "message")
            returnedDict["success"] = json.value(forKey: "success")
            
            complete(returnedDict)
            
        }
        self.requestArray.add(req)
    }
}
