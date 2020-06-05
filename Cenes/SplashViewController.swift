//
//  SplashViewController.swift
//  Cenes
//
//  Created by Cenes_Dev on 24/04/2020.
//  Copyright © 2020 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var splashImageView: UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let localSplashRecord = sqlDatabaseManager.findSplashRecords();
        if (localSplashRecord.splashRecordId != nil) {
            self.splashImageView.sd_setImage(with: URL.init(string: "\(imageUploadDomain)\(localSplashRecord.splashImage!)"), completed: nil);
        }
        // Do any additional setup after loading the view.
        UserService().commonGetWithoutAuthCall(queryStr: "", apiEndPoint: "\(apiUrl)\(UserService().get_splash_records)", token: "", complete: {response in
            
            var delay = 0;
            let success = response.value(forKey: "success") as! Bool;
            if (success == true) {
                let splashDict = response.value(forKey: "data") as! NSDictionary;
                let splashRecord = SplashRecord().loadSplashRecord(splashDict: splashDict);
                
                //If Splash Record not present locally then we will show image.
                if (localSplashRecord.splashRecordId == nil) {
                    delay = 3;
                    self.splashImageView.sd_setImage(with: URL.init(string: "\(imageUploadDomain)\(splashRecord.splashImage!)"), completed: nil);
                } else {
                    delay = 5;
                }
                sqlDatabaseManager.deleteSplashRecords();
                sqlDatabaseManager.saveSplashRecords(splashRecord: splashRecord);
            } else {
                sqlDatabaseManager.deleteSplashRecords();
            }
            self.perform(#selector(self.navigateToViewController), with: nil, afterDelay: TimeInterval(delay));
        });
        //perform(#selector(navigateToViewController), with: nil, afterDelay: 2)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func navigateToViewController() {
        // Override point for customization after application launch.
        let footprints = setting.string(forKey: "footprints")
        if footprints == UserSteps.Authentication {//if Authentication Done Then go to home screen
            let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
            if (loggedInUser.name == nil || loggedInUser.name == "") {
                UIApplication.shared.keyWindow?.rootViewController = SignupSuccessStep2ViewController.MainViewController();
            } else {
                UIApplication.shared.keyWindow?.rootViewController = NewHomeViewController.MainViewController()
            }
        }  else if footprints == UserSteps.PhoneVerification {//If Phone Verificaiton Done Then move to CHoice Screen
            //window?.rootViewController = LoginViewController.MainViewController()
            UIApplication.shared.keyWindow?.rootViewController = ChoiceViewController.MainViewController()
        } else if footprints == UserSteps.OnBoardingScreens {
            //window?.rootViewController = PhoneVerificationStep1ViewController.MainViewController()
            UIApplication.shared.keyWindow?.rootViewController = PhoneVerificationStep1ViewController.MainViewController()
        } else {
             UIApplication.shared.keyWindow?.rootViewController = OnboardingPageViewController.MainViewController()
        }
    }
}
