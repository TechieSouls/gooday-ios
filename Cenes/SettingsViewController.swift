//
//  SettingsViewController.swift
//  Cenes
//
//  Created by Redblink on 15/09/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import IoniconsSwift

class SettingsViewController: UITableViewController {
    
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    var profileImage = UIImage(named: "profile icon")
    
    var image : UIImage!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CENES"
        self.navigationItem.hidesBackButton = true
        if(image == nil)
        {
            let webServ = WebService()
            webServ.profilePicFromFacebook(url: setting.value(forKey: "photo")! as! String, completion: { image in
                self.profileImage = image
                
            })
        }else{
            self.profileImage? = image
        }
        self.setUpNavBar()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpNavBar(){
        let profileButton = UIButton.init(type: .custom)
        let image = self.profileImage?.compressImage(newSizeWidth: 35, newSizeHeight: 35, compressionQuality: 1.0)
        profileButton.imageView?.contentMode = .scaleAspectFill
        profileButton.setBackgroundImage(image, for: UIControlState.normal)
        profileButton.frame = CGRect.init(x: 0, y: 0, width: 35, height: 35)
        profileButton.layer.cornerRadius = profileButton.frame.height/2
        profileButton.clipsToBounds = true
        profileButton.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        
        
        let barButton = UIBarButtonItem.init(customView: profileButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        let notificationButton = UIButton.init(type: .custom)
        
        notificationButton.setImage(Ionicons.androidNotifications.image(25, color: commonColor), for: .selected)
        notificationButton.setImage(Ionicons.androidNotifications.image(25, color: UIColor.lightGray), for: .normal)
        notificationButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        notificationButton.layer.cornerRadius = notificationButton.frame.height/2
        notificationButton.clipsToBounds = true
        notificationButton.addTarget(self, action: #selector(notificationBarButtonPressed), for: .touchUpInside)
        
        let notificationBarButton = UIBarButtonItem.init(customView: notificationButton)
        
        
        
        let calendarButton = UIButton.init(type: .custom)
        
        calendarButton.setImage(Ionicons.iosCalendarOutline.image(25, color: UIColor.lightGray), for: UIControlState.normal)
        calendarButton.setImage(Ionicons.iosCalendarOutline.image(25, color: commonColor), for: UIControlState.selected)
        calendarButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        calendarButton.layer.cornerRadius = calendarButton.frame.height/2
        calendarButton.clipsToBounds = true
        calendarButton.addTarget(self, action: #selector(calendarBarButtonPressed), for: .touchUpInside)
        
        let calendarBarButton = UIBarButtonItem.init(customView: calendarButton)
        
        self.navigationItem.rightBarButtonItems = [calendarBarButton,notificationBarButton]
        
    }
    
    @objc func calendarBarButtonPressed(){
        
    }
   
    
    @objc func notificationBarButtonPressed(){
        let notificationsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        // notificationsView.image = self.profileImage
        self.navigationController?.pushViewController(notificationsView, animated: true)
    }
    
    @objc func profileButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController  {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}
