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
    let get_user_sync_details = "api/user/syncDetails";
    let get_user_by_email = "auth/user/findByEmail";
    let get_forget_password_email = "auth/forgetPassword/v2";
    let get_forget_password_send_email = "auth/forgetPassword/v2/sendEmail";
    let get_country_by_ip_address = "auth/getCountryByIpAddress";
    
    let post_signup_user_step1 = "api/users/signupstep1";
    let post_signup_user_step2 = "api/users/signupstep2";
    let post_userdetails = "api/user/updateDetails";
    let post_validate_password = "api/user/validatePassword";
    let post_sync_google_events = "api/google/events/v2";
    let post_sync_device_events = "api/user/syncdevicecalendar";
    let post_refresh_device_events = "api/apple/refreshEvents";
    let post_sync_outlook_events = "api/outlook/events/v2";
    let post_upload_profile_pic = "api/user/profile/upload/v2";
    let post_sync_holiday_calendar = "api/holiday/calendar/events/v2";
    let post_update_password = "auth/updatePassword";
    let post_delete_user_by_phone_password = "api/deleteUserByPhonePassword";
    let post_verification_code = "api/guest/sendVerificationCode";
    let post_check_verification_code = "api/guest/checkVerificationCode";

    
    let delete_sync_token = "api/user/deleteSyncBySyncId"
    
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
                        let name = json.object(forKey: "name")
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
                        
                        if let name = json.object(forKey: "name") as? String {
                            setting.setValue(name, forKey: "name")
                        } else {
                            setting.setValue("", forKey: "name")
                        }
                        
                        setting.setValue(userId!, forKey: "userId")
                        setting.setValue(email!, forKey: "email")
                        setting.setValue(token!, forKey: "token")
                        setting.setValue(phone!, forKey: "phone")
                        setting.setValue(password!, forKey: "password")

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
        
        let phoneNumbersDict = PhonebookService.phoneNumberWithContryCode();

        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
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
    
    
    /********************** POST REQUESTS  **************************/
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
    
    func syncGoogleEvent(postData: [String: Any],token :String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_sync_google_events)";
        
        HttpService().postMethod(url: url, postData: postData, token: token, complete: {(response) in
            complete(response);
        });
        
    }
    func syncDeviceEvents(postData: [String: Any],token :String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_sync_device_events)";
        
        HttpService().postMethod(url: url, postData: postData, token: token, complete: {(response) in
            complete(response);
        });
        
    }
    
    func refreshDeviceEvents(postData: [String: Any],token :String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_refresh_device_events)";
        
        HttpService().postMethod(url: url, postData: postData, token: token, complete: {(response) in
            complete(response);
        });
        
    }
    
    func syncOutlookEvents(postData: [String: Any],token :String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_sync_outlook_events)";
        
        HttpService().postMethod(url: url, postData: postData, token: token, complete: {(response) in
            complete(response);
        });
    }
    
    func syncHolidayCalendar(postData: [String: Any],token :String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_sync_holiday_calendar)";
        
        HttpService().postMethod(url: url, postData: postData, token: token, complete: {(response) in
            complete(response);
        });
    }
    
    func uploadUserProfilePic(postData: [String: Any], token: String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_upload_profile_pic)";
        
        HttpService().postMultipartImageProfilePic(url: url, image: postData["uploadImage"] as! UIImage, userId: postData["userId"] as! Int32, token: token, complete: {(response) in
            complete(response);
        });
    }
    
    
    func updatePasswordWithoutToken(postData: [String: Any], complete: @escaping(NSDictionary)->Void) {
        let url = "\(apiUrl)\(post_update_password)";
        
        HttpService().postMethodWithoutToken(url: url, postData: postData, complete: {(response) in
            complete(response);
        });
    }
    
    func deleteUserByPhoneAndPassword(postData: [String: Any],token :String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_delete_user_by_phone_password)";
        
        HttpService().postMethod(url: url, postData: postData, token: token, complete: {(response) in
            complete(response);
        });
    }
    
    func postVerificationCodeWithoutToken(postData: [String: Any], complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_verification_code)";
        
        HttpService().postMethodWithoutToken(url: url, postData: postData, complete: {(response) in
            complete(response);
        });
    }
    
    func postCheckVerificationCodeWithoutToken(postData: [String: Any], complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_check_verification_code)";
        
        HttpService().postMethodWithoutToken(url: url, postData: postData, complete: {(response) in
            complete(response);
        });
    }
    
    
    
    /******************************   GET REQUESTS   ***********************************/
    func findUserSyncTokens(queryStr: String, token: String, complete: @escaping(NSDictionary) ->Void ) {
        let url = "\(apiUrl)\(get_user_sync_details)?\(queryStr)";
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
    
    
    
    
    func deleteSyncTokenByTokenId(queryStr: String, token: String,  complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(delete_sync_token)?\(queryStr)";
        
        HttpService().deleteMethod(url: url, token: token, complete: {(response) in
            complete(response);
        });
    }
    
    func getForgetPasswordEmail(queryStr: String,  complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(get_forget_password_email)?\(queryStr)";
        
        HttpService().getMethodWithoutToken(url: url, complete: {(response) in
            complete(response);
        })
    }
    
    func sendForgetPasswordEmail(queryStr: String,  complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(get_forget_password_send_email)?\(queryStr)";
        
        HttpService().getMethodWithoutToken(url: url, complete: {(response) in
            complete(response);
        })
    }

    
    func getCountryByIpAddressWithoutToken(queryStr: String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(get_country_by_ip_address)?\(queryStr)";
        
        HttpService().getMethodWithoutToken(url: url, complete: {(response) in
            complete(response);
        });
    }
}
