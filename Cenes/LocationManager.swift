//
//  LocationManager.swift
//  Deploy
//
//  Created by Cenes_Dev on 22/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    
    func getDistanceInKilometres(currentLatitude: CLLocationDegrees, currentLongitude: CLLocationDegrees, destLatitude: CLLocationDegrees, destLongitude: CLLocationDegrees) -> Int{
        //My location
        let myLocation = CLLocation(latitude: currentLatitude, longitude: currentLongitude)
        
        //My buddy's location
        print("Dest Lat ", destLatitude, "Dest Long " ,destLongitude)
        let myBuddysLocation = CLLocation(latitude: destLatitude, longitude: destLongitude)
        
        //Measuring my distance to my buddy's (in km)
        let distance = myLocation.distance(from: myBuddysLocation) / 1000
        print("Distance", distance)
        return Int(distance);
    }
    
    func parseNearByLocationResults(nearByResults: NSArray) -> [Location] {
        
        var nearByLocation = [Location]();
        for nearByResultsObj in nearByResults {
            nearByLocation.append(Location().loadLocationDataFromNearByApi(locationDict: nearByResultsObj as! NSDictionary))
        }
        return nearByLocation;
    }
    
    func parseWorldWideLocationResults(worldwideResults: NSArray) -> [Location] {
        
        var worldWideLocation = [Location]();
        for worldWideLocationObj in worldwideResults {
            worldWideLocation.append(Location().loadLocationDataFromWorldWideApi(locationDict: worldWideLocationObj as! NSDictionary))
        }
        return worldWideLocation;
    }
    
}
