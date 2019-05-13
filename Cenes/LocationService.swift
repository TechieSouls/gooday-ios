//
//  LocationService.swift
//  Deploy
//
//  Created by Cenes_Dev on 22/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import Alamofire

class LocationService {
    
    //static let searchPlacesString: String = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58&input=";
    
    
static let searchPlacesString: String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58&location=3.1893164,101.7383723&radius=100&name=Irama"

    func getLocationLatLong(id :String ,complete: @escaping([String: Any])->Void ) {
        // Both calls are equivalent
        
        var returnedDict: [String: Any] = [:]
        returnedDict["Error"] = false
        returnedDict["ErrorMsg"] = ""
        
        let req =  Alamofire.request("https://maps.googleapis.com/maps/api/place/details/json?placeid=\(id)&key=AIzaSyAg8FTMwwY2LwneObVbjcjj-9DYZkrTR58", method: .get, parameters: nil, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { (response ) in
            
            var json : [String: Any] = [:]
            switch response.result {
            case .success:
                json = response.result.value as! [String: Any]
                returnedDict["data"] = json["result"]
            case .failure(let error):
                let errorX = error as NSError
                if errorX.code == -999 {
                    returnedDict["data"] = NSArray()
                }else{
                    returnedDict["success"] = true
                    returnedDict["ErrorMsg"] = error.localizedDescription
                }
            }
            complete(returnedDict)
        }
    }
}
