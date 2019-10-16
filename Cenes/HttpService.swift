//
//  HttpService.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire

class HttpService {
    
    func getMethod(url: String, token: String,complete: @escaping(NSDictionary)->Void) {
    
        let Auth_header = [ "token" : token ]
        
        Alamofire.request("\(url)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
                case .success:
                    returnDict = response.result.value as! NSDictionary;
                case .failure(let error):
                    print(error.localizedDescription)
                    var responseDict: [String: Any] = [:]
                    responseDict["success"] = false;
                    responseDict["message"] = error.localizedDescription;
                    returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
    
    func getMethodForList(url: String, token: String,complete: @escaping(NSDictionary)->Void) {
        
        let Auth_header = [ "token" : token ]
        
        Alamofire.request("\(url)", method: .get , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                let returnArray = response.result.value as! NSArray;
                var responseDict: [String: Any] = [:]
                responseDict["success"] = true;
                responseDict["data"] = returnArray;
                returnDict = responseDict as NSDictionary;
            case .failure(let error):
                print(error.localizedDescription)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = error.localizedDescription;
                returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
    
    func postMethod(url: String, postData: [String: Any], token: String, complete: @escaping(NSDictionary)->Void) {
        
        let Auth_header = [ "token" : token ]

        Alamofire.request("\(url)", method: .post , parameters: postData, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                returnDict = response.result.value as! NSDictionary;
            case .failure(let error):
                print(error.localizedDescription)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = error.localizedDescription;
                returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
    
    func postMethodWithoutToken(url: String, postData: [String: Any], complete: @escaping(NSDictionary)->Void) {
        
        Alamofire.request("\(url)", method: .post , parameters: postData, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                returnDict = response.result.value as! NSDictionary;
            case .failure(let error):
                print(error.localizedDescription)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = error.localizedDescription;
                returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
    
    func getMethodWithoutToken(url: String,complete: @escaping(NSDictionary)->Void) {
                
        Alamofire.request("\(url)", method: .get , parameters: nil, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                returnDict = response.result.value as! NSDictionary;
            case .failure(let error):
                print(error.localizedDescription)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = error.localizedDescription;
                returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
    
    
    func postMultipartImage(url: String, image: UIImage, recurringEventId: Int32, token: String, complete: @escaping(NSDictionary)->Void) {
        
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        let Auth_header = ["token" : token]
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "uploadfile", fileName: "file.jpg", mimeType: "image/jpg")
            MultipartFormData.append( "\(recurringEventId)".data(using: .utf8)!, withName: "recurringEventId")
            
        }, usingThreshold: UInt64.init(), to: "\(url)", method: .post, headers:Auth_header ) { (result) in
            
            var returnDict = NSDictionary();
            
            switch result {
            case .success(let upload,_,_):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    print("Suceess:\(String(describing: response.result.value ))")
                    /////let json = response.result.value as! NSDictionary
                    returnDict = response.result.value as! NSDictionary;
                    //returnDict.setValue(true, forKey: "success");
                    //returnDict.setValue(response.result.value, forKey: "resp");
                    complete(returnDict)
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        }
    }
    
    func postMultipartImageProfilePic(url: String, image: UIImage, userId: Int32, token: String, complete: @escaping(NSDictionary)->Void) {
        
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        
        let Auth_header = ["token" : token]
        
        Alamofire.upload(multipartFormData: { (MultipartFormData) in
            MultipartFormData.append(imgData, withName: "mediaFile", fileName: "file.jpg", mimeType: "image/jpg")
            MultipartFormData.append( "\(userId)".data(using: .utf8)!, withName: "userId")
            
        }, usingThreshold: UInt64.init(), to: "\(url)", method: .post, headers:Auth_header ) { (result) in
            
            var returnDict = NSDictionary();
            
            switch result {
            case .success(let upload,_,_):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    
                    print("Suceess:\(String(describing: response.result.value ))")
                    /////let json = response.result.value as! NSDictionary
                    returnDict = response.result.value as! NSDictionary;
                    //returnDict.setValue(true, forKey: "success");
                    //returnDict.setValue(response.result.value, forKey: "resp");
                    complete(returnDict)
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = encodingError.localizedDescription;
                returnDict = responseDict as NSDictionary;
                complete(returnDict)
                
            }
        }
    }
    
    func putMethod(url: String, token: String,complete: @escaping(NSDictionary)->Void) {
        
        let Auth_header = [ "token" : token ]
        
        Alamofire.request("\(url)", method: .put , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                returnDict = response.result.value as! NSDictionary;
            case .failure(let error):
                print(error.localizedDescription)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = error.localizedDescription;
                returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
    
    
    func deleteMethod(url: String, token: String,complete: @escaping(NSDictionary)->Void) {
        
        let Auth_header = [ "token" : token ]
        
        Alamofire.request("\(url)", method: .delete , parameters: nil, encoding: JSONEncoding.default,headers: Auth_header).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var returnDict = NSDictionary();
            
            switch response.result {
            case .success:
                returnDict = response.result.value as! NSDictionary;
            case .failure(let error):
                print(error.localizedDescription)
                var responseDict: [String: Any] = [:]
                responseDict["success"] = false;
                responseDict["message"] = error.localizedDescription;
                returnDict = responseDict as NSDictionary;
            }
            complete(returnDict)
        }
    }
}
