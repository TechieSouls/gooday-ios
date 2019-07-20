//
//  CreateGatheringLocation+UITableView.swift
//  Deploy
//
//  Created by Cenes_Dev on 23/04/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import CoreLocation

extension CreateGatheringLocationViewController: UITableViewDelegate, UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (nearByLocations.count == 0) {
            return 0;
        } else {
            return nearByLocations.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (nearByLocations.count == 0) {
            return UITableViewCell();
        }
        
        let nearbyLocObj = nearByLocations[indexPath.row];
        
        let cell: LocationItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationItemTableViewCell", for: indexPath) as! LocationItemTableViewCell;
        cell.locationTitle.text = nearbyLocObj.location;
        cell.locationAddress.text = nearbyLocObj.address;
        
        if (nearbyLocObj.latitudeDouble != nil) {
            cell.distanceInKm.isHidden = false;

            let destLat : CLLocationDegrees = CLLocationDegrees(nearbyLocObj.latitudeDouble as! Double);
            let destLng : CLLocationDegrees = CLLocationDegrees(nearbyLocObj.longitudeDouble as! Double);
            
            cell.distanceInKm.text = "\(String(LocationManager().getDistanceInKilometres(currentLatitude: currentLatitude, currentLongitude: currentLongitude, destLatitude: destLat, destLongitude: destLng)))Km";
            
        } else {
            cell.distanceInKm.isHidden = true;
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nearByLocObje = nearByLocations[indexPath.row];
        
        LocationService().getLocationLatLong(id: nearByLocObje.placeId, complete: {(response) in
            
            if (response["data"] != nil) {
                let data = response["data"] as! [String: Any];
                if let locationPoints = data["geometry"] as? [String: Any] {
                    let latLong = locationPoints["location"] as? [String: Any]
                    nearByLocObje.latitudeDouble = latLong!["lat"] as! Double
                    nearByLocObje.longitudeDouble = latLong!["lng"] as! Double
                }
                self.selectedLocationProtocolDelegate.locationSelected(location: nearByLocObje);

            }
            self.navigationController?.popViewController(animated: true);
        }); 
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
    }
}
