//
//  LocationAlertView.swift
//  Cenes
//
//  Created by Cenes_Dev on 08/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit
import GoogleMaps

class LocationAlertView: UIView {

    @IBOutlet weak var alertBackdropView: UIView!
    @IBOutlet weak var alertWhiteView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var scrollViewPlacePhotos: UIScrollView!
    @IBOutlet weak var lblGetDirections: UILabel!
    @IBOutlet weak var ivLocationPhoto: UIImageView!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var openNowLabel: UILabel!
    @IBOutlet weak var locationPhoneLabel: UILabel!
    @IBOutlet weak var showLatestCovidInfoView: UIView!
    @IBOutlet weak var showLatestCovidInfoLabel: UILabel!
    @IBOutlet weak var donotShowThisDataLabel: UILabel!
    @IBOutlet weak var covidDataViewContainer: UIView!
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var aboutCovidIcon: UIImageView!
    @IBOutlet weak var locationMap: GMSMapView!;

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if (ivLocationPhoto != nil) {
            ivLocationPhoto.layer.cornerRadius = 4;
        }
        if (alertWhiteView != nil) {
            alertWhiteView.layer.cornerRadius = 21;
        }
        
        if (locationMap != nil) {
            let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
            locationMap.camera = camera;
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LocationAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    class func locationPhotoInstanceFromNib() -> UIView {
        return UINib(nibName: "LocationAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }
}
