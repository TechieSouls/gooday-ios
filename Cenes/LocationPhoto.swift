//
//  LocationPhoto.swift
//  Cenes
//
//  Created by Cenes_Dev on 08/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
class LocationPhoto {
    
    var height: Int32!;
    var width: Int32!;
    var photoReference: String!;
    

    func loadLocationPhotoByDict(locationPhotoDict: NSDictionary) -> LocationPhoto {
        
        let locationPhoto = LocationPhoto();
        locationPhoto.height = locationPhotoDict.value(forKey: "height") as! Int32;
        locationPhoto.width = locationPhotoDict.value(forKey: "width") as! Int32;
        locationPhoto.photoReference = locationPhotoDict.value(forKey: "photo_reference") as! String;
        return locationPhoto;
    }


    func loadLocationPhotoByArray(locArr: NSArray) -> [LocationPhoto] {
        
        var locationPhotos = [LocationPhoto]();
        for locItem in locArr {
            let locItemDict = locItem as! NSDictionary;
            locationPhotos.append(loadLocationPhotoByDict(locationPhotoDict: locItemDict));
        }
        return locationPhotos;
    }

}
