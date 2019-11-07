//
//  MeTimeService.swift
//  Deploy
//
//  Created by Cenes_Dev on 19/03/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class MeTimeService {
    
    //GET
    let get_metimeData: String  = "api/user/getmetimes";
    
    //PUT
    let put_deleteByRecurringId: String = "/api/user/metime/deleteByRecurringId";
    
    //POST
    let post_metimeData: String = "api/user/metime";
    let post_metimePhoto: String = "api/recurring/upload";
    
    
    //Function to get User Gatherings
    func getMeTimes(queryStr: String, token: String, complete: @escaping(NSDictionary)->Void){
        // Both calls are equivalent
        let url = "\(apiUrl)\(get_metimeData)?\(queryStr)";
        
        HttpService().getMethod(url: url, token: token, complete: { (response ) in
            complete(response)
            
        });
    }
    
    func saveMeTime(postData: [String: Any], token: String, complete: @escaping(NSDictionary)->Void){
        let url = "\(apiUrl)\(post_metimeData)";
        print(postData)
        HttpService().postMethod(url: url, postData: postData, token: token, complete: { (response) in
            complete(response)
        });
    }
    
    func uploadMeTimeImage(image: UIImage, recurringEventId: Int32, token: String, complete: @escaping(NSDictionary) -> Void) {
    
        let url = "\(apiUrl)\(post_metimePhoto)";
        
        HttpService().postMultipartImage(url: url, image: image, recurringEventId: recurringEventId, token: token, complete: { (response) in
            
            complete(response)
        });
    }
    
    func deleteMeTimeByRecurringEventId(queryStr: String, token: String, complete: @escaping(NSDictionary)->Void){
        
        let url = "\(apiUrl)\(put_deleteByRecurringId)?\(queryStr)";
        HttpService().putMethod(url: url, token: token, complete: { (response) in
            complete(response)
        });
    }
}
