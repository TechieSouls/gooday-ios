//
//  SideMenuViewController.swift
//  Cenes
//
//  Created by Redblink on 02/11/17.
//  Copyright © 2017 Redblink Pvt Ltd. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import NVActivityIndicatorView
import SideMenu

class SideMenuViewController: UIViewController,NVActivityIndicatorViewable {
    @IBOutlet weak var notificationCount_label: UILabel!
    
    var nactvityIndicatorView = NVActivityIndicatorView.init(frame: cgRectSizeLoading, type: NVActivityIndicatorType.lineScaleParty, color: UIColor.white, padding: 0.0);
    
    var type : Int = 0
    var buttonTag = -1
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    //0 for home 1 for gathering
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //NotificationListApi()
        //notificationCount_label.layer.cornerRadius = notificationCount_label.frame.size.height/2
        //notificationCount_label.clipsToBounds =  true
        userName.text = setting.value(forKey: "name") as? String
        self.profileImage.image = appDelegate?.getProfileImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func NotificationListApi()
    {
        let webservice = WebService()
        startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
        webservice.getNotificationsCounter(){ (returnedDict) in
            print("Got results")
            print(returnedDict)
            self.stopAnimating()
            if returnedDict.value(forKey: "Error") as? Bool == true {
                
                self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                
            }else{
                print(returnedDict)
                self.notificationCount_label.text =  String(returnedDict["data"] as! Int) as? String
                //  self.parseResults(resultArray: (returnedDict["data"] as? NSArray)!)
                
                //Setting badge counts in prefrences
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(returnedDict["data"] , forKey: "badgeCounts");
                userDefaults.synchronize()
            }
    }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print(sender.tag)
        buttonTag = sender.tag

        DispatchQueue.main.async {
            let index = appDelegate?.cenesTabBar?.selectedIndex
            switch self.buttonTag {
            case -1:
                
                print("Do nothing")
            case 0:
                let notificationsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
                notificationsView.image = self.profileImage.image
                notificationsView.hidesBottomBarWhenPushed = true
                notificationsView.navigationController?.isNavigationBarHidden = true;
                
                
                self.dismiss(animated: true, completion: nil)
                let navController = appDelegate?.cenesTabBar?.viewControllers?[index!] as! UINavigationController
                navController.popToRootViewController(animated: false)
                navController.hidesBarsOnTap = true;
               navController.pushViewController(notificationsView, animated: true)
               // self.navigationController?.dismiss(animated: false, completion: {
                    
                //})
               // self.navigationController?.pushViewController(notificationsView, animated: false)
                
                print("Open notifications")
                break
            case 1:
                print("open profile")
                let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                profileView.image = self.profileImage.image
                profileView.hidesBottomBarWhenPushed = true
                self.dismiss(animated: true, completion: nil)
                let navController = appDelegate?.cenesTabBar?.viewControllers?[index!] as! UINavigationController
                navController.popToRootViewController(animated: false)
                navController.pushViewController(profileView, animated: true)
                break
            case 2:
                print("Open me Time")
                /*let meTime = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MeTime") as? MeTimeViewController
                meTime?.hidesBottomBarWhenPushed = true
                meTime?.fromSideMenu = true
                
                self.dismiss(animated: true, completion: nil)
                let navController = appDelegate?.cenesTabBar?.viewControllers?[index!] as! UINavigationController
                navController.popToRootViewController(animated: false)
                navController.pushViewController(meTime!, animated: true)*/
                break
            case 3:
                print("Open calendar sync")
                let calendar = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendar") as? AddCalendarViewController
                calendar?.hidesBottomBarWhenPushed = true
                calendar?.fromSideMenu = true
                self.dismiss(animated: true, completion: nil)
                let navController = appDelegate?.cenesTabBar?.viewControllers?[index!] as! UINavigationController
                navController.popToRootViewController(animated: false)
                navController.pushViewController(calendar!, animated: true)
                break
            case 4:
                print("Holdiay calendar")
                let holiday = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "holiday") as? WorldHolidayCalendarViewController
                holiday?.hidesBottomBarWhenPushed = true
                holiday?.fromSideMenu = true
                self.dismiss(animated: true, completion: nil)
                let navController = appDelegate?.cenesTabBar?.viewControllers?[index!] as! UINavigationController
                navController.popToRootViewController(animated: false)
                navController.pushViewController(holiday!, animated: true)
                break
            case 5:
                print("Help")
                let help = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "help") as? HelpViewController
                help?.hidesBottomBarWhenPushed = true

                self.dismiss(animated: true, completion: nil)
                let navController = appDelegate?.cenesTabBar?.viewControllers?[index!] as! UINavigationController
                navController.popToRootViewController(animated: false)
                navController.pushViewController(help!, animated: true)
                break
            case 6:
                print("About")
                let aboutUs = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "aboutUs") as? AboutViewController
                aboutUs?.hidesBottomBarWhenPushed = true
                
                self.dismiss(animated: true, completion: nil)

                let navController = appDelegate?.cenesTabBar?.viewControllers?[index!] as! UINavigationController
                navController.popToRootViewController(animated: false)
                navController.pushViewController(aboutUs!, animated: true)
                break
            case 7:
                print("Logout")
                
                
                let webservice = WebService()
                self.startAnimating(loadinIndicatorSize, message: "Loading...", type: self.nactvityIndicatorView.type)
                
                webservice.logout() { (returnedDict) in
                    self.stopAnimating()
                    if returnedDict["Error"] as? Bool == true {
                        
                        self.showAlert(title: "Error", message: (returnedDict["ErrorMsg"] as? String)!)
                        
                    }else{
                        //print(returnedDict)
                        
                
                let tokenPush = UserDefaults.standard.object(forKey: "tokenData") as? String
                imageFacebookURL = nil
                GIDSignIn.sharedInstance().signOut()
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                print("Logut from App")
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                
                appDelegate?.clearLocalCache()
                
                let userDefaults = UserDefaults.standard
                if tokenPush != nil {
                    userDefaults.setValue(tokenPush , forKey: "tokenData")
                }
                userDefaults.synchronize()
                UIApplication.shared.keyWindow?.rootViewController = LoginViewController.MainViewController()
                    }
                }
                break
            default:
                print("sMenu do nothign")
                break
            }
            self.buttonTag = -1
            print(#function)
        }
        
    }
    
    
}
