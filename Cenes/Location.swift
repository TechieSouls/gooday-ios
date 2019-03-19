//
//  Location.swift
//  Deploy
//
//  Created by Cenes_Dev on 27/02/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation

class Location {
    
    var location: String!;
    var latitude: String!;
    var address: String!;
    var longitude: String!;
    var placeId: String!;
    var photo: String!;
    
    func loadLocationData(locationDict: NSDictionary) -> Location {
        let locationObj = Location();
        
        locationObj.location = locationDict.value(forKey: "title") as? String;
        locationObj.address = locationDict.value(forKey: "address") as? String;
        locationObj.latitude = locationDict.value(forKey: "latitude") as? String;
        locationObj.longitude = locationDict.value(forKey: "longitude") as? String;
        locationObj.placeId = locationDict.value(forKey: "placeId") as? String;
        locationObj.photo = locationDict.value(forKey: "photo") as? String;
        
        return locationObj;
    }
}
