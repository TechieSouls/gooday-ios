//
//  LocationAlertView.swift
//  Cenes
//
//  Created by Cenes_Dev on 08/06/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class LocationAlertView: UIView {

    @IBOutlet weak var alertBackdropView: UIView!
    @IBOutlet weak var alertWhiteView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var scrollViewPlacePhotos: UIScrollView!
    @IBOutlet weak var lblGetDirections: UILabel!
    @IBOutlet weak var ivLocationPhoto: UIImageView!

    
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
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "LocationAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    class func locationPhotoInstanceFromNib() -> UIView {
        return UINib(nibName: "LocationAlertView", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! UIView
    }
}
