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
    
    let get_friend_list = "api/user/phonefriends/v2";
    let get_user_stats = "api/user/userStatsByUserId";
    let get_user_properties = "api/user/userProperties";
    let get_user_by_email = "auth/user/findByEmail";
    
    let post_signup_user_step1 = "api/users/signupstep1";
    let post_signup_user_step2 = "api/users/signupstep2";

    let post_userdetails = "api/user/updateDetails";
    let post_validate_password = "api/user/validatePassword";
    
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
        
        /*let url = "\(apiUrl)/api/users/327";
        let token = "1553765623714eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjcmVlZC5jaG9uZzE1NTM2NzkyMjM3MTQifQ.-PUIm8M07l15nRg6YWkjOCI0oKff5oJGXp87i8acMdAquWXvY9mBZqtd-Z1dPtIumS3xzEuBoUCoeqPShXmV8Q";
        let Auth_header = [ "token" : token ]
        
        Alamofire.request("\(url)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
        */
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
                        let  name = json.object(forKey: "name")
                        let phone = json.object(forKey: "phone")
                        let password = json.object(forKey: "password")

                        if (json.object(forKey:"birthDayStr") as? String) != nil {
                            setting.setValue(json.object(forKey:"birthDayStr") as! String, forKey: "birthDayStr")
                        }
                        
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
                        setting.setValue(phone!, forKey: "phone")
                        setting.setValue(password!, forKey: "password")
                        setting.setValue(2, forKey: "onboarding")

                        /*if (userPhoto != "") {
                            let webServ = WebService()
                            webServ.profilePicFromFacebook(url: userPhoto, completion: { image in
                                DispatchQueue.main.async {
                                    print("Image Downloaded")
                                    appDelegate?.profileImageSet(image: image!)
                                }
                            })
                        }*/
                        
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
    
    func findUserFriendsByUserId(queryStr: String, token: String, complete: @escaping(NSDictionary) ->Void ) {
        let url = "\(apiUrl)\(get_friend_list)?\(queryStr)";
        print("Url : \(url)")
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response)
        });
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
            
                returnedDict["message"] = json.value(forKey: "message")
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
    
    
    func emailSignupRequest(postData: [String: Any], complete: @escaping(NSDictionary)->Void) {
        let url = "\(apiUrl)\(post_signup_user_step1)";
        
        HttpService().postMethodWithoutToken(url: url, postData: postData, complete: {(response) in
            complete(response);
        });
    }
    
    func emailSignupRequestStep2(postData: [String: Any], complete: @escaping(NSDictionary)->Void) {
        let url = "\(apiUrl)\(post_signup_user_step2)";
        
        HttpService().postMethodWithoutToken(url: url, postData: postData, complete: {(response) in
            complete(response);
        });
    }
    
    func postUserDetails(postData: [String: Any], token: String, complete: @escaping(NSDictionary)->Void) {
       
        let url = "\(apiUrl)\(post_userdetails)";
       
        HttpService().postMethod(url: url, postData: postData, token: token, complete: {(response) in
            complete(response);
        });
    }
    
    func postValidatePassword(postData: [String: Any], token: String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_validate_password)";
        
        HttpService().postMethod(url: url, postData: postData, token: token, complete: {(response) in
            complete(response);
        });
    }
    
    func findUserStatsByUserId(queryStr: String, token: String, complete: @escaping(NSDictionary) ->Void ) {
        let url = "\(apiUrl)\(get_user_stats)?\(queryStr)";
        print("Url : \(url)")
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response)
        });
    }
    
    func findUserPropertiesByUserId(queryStr: String, token: String, complete: @escaping(NSDictionary) ->Void ) {
        let url = "\(apiUrl)\(get_user_properties)?\(queryStr)";
        print("Url : \(url)")
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response)
        });
    }
    
    func findUserByEmail(queryStr: String, token: String,  complete: @escaping(NSDictionary) ->Void ) {
        
        let url = "\(apiUrl)\(get_user_by_email)?\(queryStr)";
        print("Url : \(url)")
        HttpService().getMethodWithoutToken(url: url, complete: {(response) in
            complete(response);
        });
    }
}
