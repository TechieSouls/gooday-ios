//
//  CenesUtilFunc.swift
//  Cenes
//
//  Created by Macbook on 09/09/18.
//  Copyright © 2018 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class CenesUtilFunc: UIViewController, NVActivityIndicatorViewable {
    
    func yesNoAlert(title: String, message: String) {
    
        var takeAction: Bool = false;
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            takeAction = true;
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            takeAction = false;
        }))
        
        self.present(refreshAlert, animated: true, completion: nil)
        
        //return takeAction
        
    }
}

class UserSteps {
    static let OnBoardingScreens = "OnBoardingScreens";
    static let PhoneVerification = "PhoneVerification";
    static let Authentication = "Authentication";
}
