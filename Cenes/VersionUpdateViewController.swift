//
//  VersionUpdateViewController.swift
//  Cenes
//
//  Created by Cenes_Dev on 14/09/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import UIKit

class VersionUpdateViewController: UIViewController {

    @IBOutlet weak var versionUpdateBar: UIView!
    
    @IBOutlet weak var buildVersion: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "About";

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false;
        self.tabBarController?.tabBar.isHidden = true;
        self.view.backgroundColor = themeColor;

        let updateVersionGuestureListener = UITapGestureRecognizer.init(target: self, action: #selector(openAppStoreLink));
        self.versionUpdateBar.addGestureRecognizer(updateVersionGuestureListener);
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.buildVersion.text = "Version \(String(appVersion!))";

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func openAppStoreLink() {
        
        UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/cenes/id1475664339")!, options: [String:String](), completionHandler: nil);
    }
}
