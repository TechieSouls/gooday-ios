//
//  GatheringService.swift
//  Deploy
//
//  Created by Mandeep on 18/01/19.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire

class GatheringService {
    
    let get_gatherings_by_status: String = "api/user/gatherings/v2"; //user_id, status
    let get_gathering_data: String = "api/event/"; //eventId
    let get_delete_event_api: String = "/api/event/delete";//event_id
    let get_update_invitation_api: String = "/api/event/memberStatusUpdate";
    let get_predictive_api: String = "api/predictive/calendar/v2";
    let get_event_by_key: String = "/api/event/invitation/";
    
    let post_event_image_upload = "api/event/upload";
    let post_event_image_upload_v2 = "/api/event/uploadv2";
    let post_event_create_v2 = "/api/event/create";
    
    var requestArray = NSMutableArray()
    
    //Function to get User Gatherings
    func getGatheringEventsByStatus(queryStr: String, token: String, complete: @escaping(NSDictionary)->Void){
        let url : String = "\(apiUrl)\(get_gatherings_by_status)?\(queryStr)";
        print(url);
        
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response);
        })
    }
    
    //Function to get User Gatherings
    func createGatheringV2(postData: [String: Any],token :String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(post_event_create_v2)";
        
        HttpService().postMethod(url: url, postData: postData, token: token, complete: {(response) in
            complete(response);
        });
    }


    //Function To Create Gathering..
    func createGathering(uploadDict : [String : Any],complete: @escaping(NSMutableDictionary)->Void ) {
        
        print( "Inside Getting Predictive data")
        // Both calls are equivalent
        
        
        //let searchSTr = nameString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let userid = setting.value(forKey: "userId") as! NSNumber
        let uid = "\(userid)"
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let params : Parameters = uploadDict
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        
        Alamofire.request("\(apiUrl)api/event/create", method: .post , parameters: params, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
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
    
    //Function to upload Gathering event image
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
            
        }, usingThreshold: UInt64.init(), to: "\(imageUploadDomain)api/event/upload", method: .post, headers:Auth_header) { (result) in
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
                print(encodingError.localizedDescription)
                returnedDict["Error"] = true
                returnedDict["ErrorMsg"] = encodingError.localizedDescription
                complete(returnedDict)
                
            }
            
        }
    }
    
    
    //Function to upload Gathering event image
    func uploadEventImageV2(image : UIImage?, eventId: Int32, loggedInUser: User , complete: @escaping(NSMutableDictionary)->Void)
    {
        guard image != nil else { return }
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        let Auth_header    = ["token" : loggedInUser.token]
        
        
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "uploadfile", fileName: "file.jpg", mimeType: "image/jpg")
            MultipartFormData.append( "\(String(eventId))".data(using: .utf8)!, withName: "eventId")
            
        }, usingThreshold: UInt64.init(), to: "\(apiUrl)\(post_event_image_upload)", method: .post, headers:Auth_header as! HTTPHeaders) { (result) in
            switch result {
            case .success(let upload,_,_):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    print("Suceess:\(String(describing: response.result.value ))")
                    if (response.result.value != nil) {
                        let json = response.result.value as! NSDictionary
                        returnedDict["data"] = json
                    } else {
                        returnedDict["Error"] = true
                        returnedDict["ErrorMsg"] = "Photo cannot be uploaded."
                    }
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
    
    //Function to upload Gathering event image
    func uploadEventImageV3(image : UIImage?, loggedInUser: User , complete: @escaping(NSDictionary)->Void)
    {
        guard image != nil else { return }
        let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        let Auth_header    = ["token" : loggedInUser.token]
        
        var returnedDict = NSDictionary()
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "uploadfile", fileName: "file.jpg", mimeType: "image/jpg")
        }, usingThreshold: UInt64.init(), to: "\(imageUploadDomain)\(post_event_image_upload_v2)", method: .post, headers:Auth_header as! HTTPHeaders) { (result) in
            switch result {
            case .success(let upload,_,_):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    print("Suceess:\(String(describing: response.result.value ))")
                    if (response.result.value != nil) {
                        returnedDict = response.result.value as! NSDictionary
                    } else {
                        var returResp = [String: Any]();
                        returResp["success"] = false
                        returResp["message"] = "Photo cannot be uploaded."
                        returnedDict = returResp as NSDictionary;
                    }
                    complete(returnedDict)
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                var returResp = [String: Any]();
                returResp["success"] = false
                returResp["message"] = encodingError.localizedDescription
                returnedDict = returResp as NSDictionary;
                complete(returnedDict)
            }
            
        }
    }
    
    func eventInfoTask(eventId: Int64, complete: @escaping(NSMutableDictionary)->Void) {
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
    
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]

        let url = "\(apiUrl)\(get_gathering_data)\(eventId)";
        let req = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:Auth_header).validate(statusCode: 200..<300).responseJSON{
        (response ) in
        
            if (response.result.value != nil) {
                let json = response.result.value as! NSDictionary
                
                returnedDict["data"] = json.value(forKey: "data")
                returnedDict["success"] = json.value(forKey: "success")

            } else {
                returnedDict["Error"] = true
                returnedDict["success"] = false;
                returnedDict["message"] = "Event not found";
            }
            
            complete(returnedDict)
        }
        self.requestArray.add(req)
    }
    
    func deleteGatheringTask(eventId: Int32, complete: @escaping(NSMutableDictionary)->Void) {
        let returnedDict = NSMutableDictionary()
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        let Auth_header    = [ "token" : setting.value(forKey: "token") as! String ]
        
        let url = "\(apiUrl)\(get_delete_event_api)?event_id=\(eventId)";
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
    
    func updateGatheringStatus(queryStr: String,token: String, complete: @escaping(NSDictionary)->Void) {
        let url = "\(apiUrl)\(get_update_invitation_api)?\(queryStr)";
        print("API Url : \(url)")
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response);
        });
    }
    
    func getPredictiveData(queryStr: String, token: String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(get_predictive_api)?\(queryStr)";
        print("API Url : \(url)")
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response);
        });
    }

    func getEventInfoByKey(pathVariable: String, token: String, complete: @escaping(NSDictionary)->Void) {
        
        let url = "\(apiUrl)\(get_event_by_key)\(pathVariable)";
        print("API Url : \(url)")
        HttpService().getMethod(url: url, token: token, complete: {(response) in
            complete(response);
        });
    }

}
