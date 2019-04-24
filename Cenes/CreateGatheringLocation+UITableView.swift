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
        return locationDtos.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (locationDtos.count == 0) {
            return 0;
        } else {
            return locationDtos[section].sectionObjects.count;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (locationDtos.count == 0) {
            return UITableViewCell();
        }
        
        let nearbyLocObj = locationDtos[indexPath.section].sectionObjects[indexPath.row];
        
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
        let nearByLocObje = locationDtos[indexPath.section].sectionObjects[indexPath.row];
        selectedLocationProtocolDelegate.locationSelected(location: nearByLocObje);
        self.navigationController?.popViewController(animated: true);
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let headerTitle = locationDtos[section].sectionName;
        if (headerTitle == "All") {
            return "";
        }
        return headerTitle;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell: LocationItemsHeaderViewCell = tableView.dequeueReusableCell(withIdentifier: "LocationItemsHeaderViewCell") as! LocationItemsHeaderViewCell
        if (section == 0) {
            return UITableViewCell();
        } else {
            return cell;
        }
    }
}
