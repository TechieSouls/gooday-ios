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
    var latitudeDouble: Double!
    var address: String!;
    var longitude: String!;
    var longitudeDouble: Double!;
    var placeId: String!;
    var photo: String!;
    var kilometers: String!;
    var openNow: Bool!;
    var phoneNumber: String!;
    var countryISO2Code: String!;
    var country: String!;
    var state: String!;
    var county: String!;
    var newCases: String!;
    var markerSnippet: String!;

    func loadLocationData(locationDict: NSDictionary) -> Location {
        let locationObj = Location();
        
        locationObj.location = locationDict.value(forKey: "title") as? String;
        locationObj.address = locationDict.value(forKey: "address") as? String;
        locationObj.latitude = locationDict.value(forKey: "latitude") as? String;
        locationObj.longitude = locationDict.value(forKey: "longitude") as? String;
        locationObj.placeId = locationDict.value(forKey: "placeId") as? String;
        locationObj.photo = locationDict.value(forKey: "photo") as? String;
        locationObj.kilometers = locationDict.value(forKey: "kilometers") as? String;
        
        return locationObj;
    }
    
    func loadLocationDataFromWorldWideApi(locationDict: NSDictionary) -> Location {
        let locationObj = Location();
        
        let structuredFormatting = locationDict.value(forKey: "structured_formatting") as! NSDictionary;
        locationObj.location = structuredFormatting.value(forKey: "main_text") as? String;
        locationObj.address = structuredFormatting.value(forKey: "secondary_text") as? String;
        locationObj.placeId = locationDict.value(forKey: "place_id") as? String;
        
        return locationObj;
    }
    
    func loadLocationDataFromNearByApi(locationDict: NSDictionary) -> Location {
        
        let locationObj = Location();
        
        locationObj.location = locationDict.value(forKey: "name") as? String;
        locationObj.address = locationDict.value(forKey: "vicinity") as? String;
        
        let geomatry = locationDict.value(forKey: "geometry") as! NSDictionary;
        
        let location = geomatry.value(forKey: "location") as! NSDictionary;
        
        locationObj.latitudeDouble = location.value(forKey: "lat") as? Double;
        locationObj.longitudeDouble = location.value(forKey: "lng") as? Double;
        locationObj.placeId = locationDict.value(forKey: "place_id") as? String;
        locationObj.photo = locationDict.value(forKey: "photo") as? String;
        locationObj.kilometers = locationDict.value(forKey: "kilometers") as? String;
        
        return locationObj;
        
        
    }
    
    
    func loadLocationDataFromPreviousLocations(prevLocDict: NSDictionary) -> Location {
        let locationObj = Location();
        
        locationObj.location = prevLocDict.value(forKey: "location") as? String;
        locationObj.latitude = prevLocDict.value(forKey: "latitude") as? String;
        locationObj.longitude = prevLocDict.value(forKey: "longitude") as? String;
        locationObj.placeId = prevLocDict.value(forKey: "placeId") as? String;
        locationObj.latitudeDouble = Double(prevLocDict.value(forKey: "latitude") as! String);
        locationObj.longitudeDouble = Double(prevLocDict.value(forKey: "longitude") as! String);

        //locationObj.photo = prevLocDict.value(forKey: "photo") as? String;
        //locationObj.kilometers = prevLocDict.value(forKey: "kilometers") as? String;
        
        return locationObj;
    }

}
