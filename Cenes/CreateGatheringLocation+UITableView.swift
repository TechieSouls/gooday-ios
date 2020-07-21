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
            
            let dist = Double(LocationManager().getDistanceInKilometres(currentLatitude: self.currentLatitude, currentLongitude: self.currentLongitude, destLatitude: nearbyLocObj.latitudeDouble, destLongitude: nearbyLocObj.longitudeDouble))!;
            
            if (Double(dist) > Double(9000)) {
                cell.distanceInKm.isHidden = true;
            } else {
                cell.distanceInKm.isHidden = false;
            }
            cell.distanceInKm.text = "\(String(LocationManager().getDistanceInKilometres(currentLatitude: self.currentLatitude, currentLongitude: self.currentLongitude, destLatitude: nearbyLocObj.latitudeDouble, destLongitude: nearbyLocObj.longitudeDouble)))Km";
            
        } else {
            cell.distanceInKm.isHidden = true;
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nearByLocObje = nearByLocations[indexPath.row];
        
        LocationService().getLocationLatLong(id: nearByLocObje.placeId, complete: {(response) in
            
            if (response["data"] != nil) {
                let data = response["data"] as! NSDictionary;
                if let locationPoints = data["geometry"] as? NSDictionary {
                    let latLong = locationPoints["location"] as! NSDictionary
                    nearByLocObje.latitudeDouble = latLong.value(forKey: "lat") as! Double
                    nearByLocObje.longitudeDouble = latLong.value(forKey: "lng") as! Double
                }
                if (nearByLocObje.placeId == nil) {
                    nearByLocObje.placeId = (data["place_id"] as! String);
                }
                if let openingHours = data.value(forKey: "opening_hours") as? NSDictionary {
                    nearByLocObje.openNow = (openingHours.value(forKey: "open_now") as! Bool);
                }
                if let internationalPhoneNumber = data.value(forKey: "international_phone_number") as? String {
                    nearByLocObje.phoneNumber = internationalPhoneNumber;
                } else if let formattedPhoneNumber = data.value(forKey: "formatted_phone_number") as? String {
                    nearByLocObje.phoneNumber = formattedPhoneNumber;
                }
                
                //Lets find out country, state, county
                if let addressComponents = data.value(forKey: "address_components") as? NSArray {
                    
                    for addressItem in addressComponents {
                        let addressItemDict = addressItem as! NSDictionary;
                        if let types = addressItemDict.value(forKey: "types") as? NSArray {
                            
                            for typeItem in types {
                                let typeOfAddress = typeItem as! String;
                                
                                //Finding Country
                                if (typeOfAddress == "country") {
                                    
                                    nearByLocObje.country = (addressItemDict.value(forKey: "long_name") as! String);
                                    nearByLocObje.countryISO2Code = (addressItemDict.value(forKey: "short_name") as! String);
                                } else if (typeOfAddress == "administrative_area_level_1") {                             //Finding State
                                    nearByLocObje.state = (addressItemDict.value(forKey: "long_name") as! String);
                                } else if (typeOfAddress == "administrative_area_level_2") {//Finding County
                                    //Finding County
                                    nearByLocObje.county = (addressItemDict.value(forKey: "long_name") as! String);
                                }
                            }
                        }
                    }
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
