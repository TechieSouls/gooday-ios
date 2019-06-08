 //
//  AppDelegate.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/5/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import CoreData
import FBSDKLoginKit
import FacebookCore
import UserNotifications
 
import GoogleSignIn
import Google
import SideMenu
 
let setting = UserDefaults.standard

@UIApplicationMain

 class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var cenesTabBar : UITabBarController?
    
    let cenesPersistentContainer = NSPersistentContainer(name: "Cenes")
    
    var storeLoaded = false
    
    
    func loadPersistentContainer() {
        cenesPersistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("  Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print("My App Launched on Termination**************************************");
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Override point for customization after application launch.
        let footprints = setting.string(forKey: "footprints")
        if footprints == UserSteps.Authentication { //if Authentication Done Then go to home screen
            
            let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
            if (loggedInUser.name == nil) {
                window?.rootViewController = SignupSuccessStep2ViewController.MainViewController();
            } else {
                window?.rootViewController = HomeViewController.MainViewController()
            }
        }  else if footprints == UserSteps.PhoneVerification {//If Phone Verificaiton Done Then move to CHoice Screen
            //window?.rootViewController = LoginViewController.MainViewController()
            window?.rootViewController = ChoiceViewController.MainViewController()
        } else if footprints == UserSteps.OnBoardingScreens {
            //window?.rootViewController = PhoneVerificationStep1ViewController.MainViewController()
            window?.rootViewController = PhoneVerificationStep1ViewController.MainViewController()

        } else {
             window?.rootViewController = OnboardingPageViewController.MainViewController()
        }
        
        //User Notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
                
            }else{
                DispatchQueue.main.async {
                    print ("Notificaiton access success")
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
        
        // Google sign in
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
       //Google Analytics code
        guard let gai = GAI.sharedInstance() else {
            assert(false, "Google Analytics not configured correctly")
            return true;
        }
        gai.tracker(withTrackingId: "UA-97875532-2")
        // Optional: automatically report uncaught exceptions.
        gai.trackUncaughtExceptions = true
        
        // Optional: set Logger to VERBOSE for debug information.
        // Remove before app release.
        gai.logger.logLevel = .verbose;
        
        //WebService().resetBadgeCount();
        
        
        let loggedInUser = User().loadUserDataFromUserDefaults(userDataDict: setting);
        if (loggedInUser.userId != nil) {
            let queryStr = "userId=\(String(loggedInUser.userId))";
            NotificationService().findNotificationBadgeCounts(queryStr: queryStr, token: loggedInUser.token, complete: {(response) in
                
                if (response.value(forKey: "success") as! Bool != false) {
                    let notificationDataDict = response.value(forKey: "data") as! NSDictionary
                    if (notificationDataDict["badgeCount"] as! Int != 0) {
                        self.cenesTabBar?.setTabBarDotVisible(visible: true);
                    }
                }
            })
        }
        
        //DispatchQueue.main.async {
            //PhonebookService().phoneNumberWithContryCode();
        //}
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //WebService().resetBadgeCount();

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
        //WebService().resetBadgeCount();
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
           }

    func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        
    }
    
    func profileImageSet(image:UIImage){
        UserDefaults.standard.set(UIImageJPEGRepresentation(image, 1), forKey: "profileImage")
    }
    
    func getProfileImage()-> UIImage {
        if UserDefaults.standard.value(forKey: "profileImage") != nil {
            let data = UserDefaults.standard.value(forKey: "profileImage") as! Data
            let image = UIImage(data: data)
            return image!
        }else{
            return #imageLiteral(resourceName: "profile icon")
        }
    }
    
    func clearLocalCache() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        //let fetchAlarm = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")
        //let alarmDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchAlarm)

        //let fetchReminder = NSFetchRequest<NSFetchRequestResult>(entityName: "RemindersModel")
        //let reminderDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchReminder)

        do {
            //try self.persistentContainer.viewContext.execute(alarmDeleteRequest)
            //try self.persistentContainer.viewContext.execute(reminderDeleteRequest)

            try self.persistentContainer.viewContext.save()
    
        } catch {
            print ("Error in deleting tables")
        }
        
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "deploy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    ///it is used to control flow once user successfully logged in through Facebook and returning back to demo application.
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        
        
            let isGoogleOpenUrl = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
            let isFacebookOpenUrl = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        
        if isGoogleOpenUrl {
            return true
        }
        if isFacebookOpenUrl {
            return true
        }
        if url.scheme == "cenes" {
            let service = OutlookService.shared()
            service.handleOAuthCallback(url: url)
            return true
        }
        return false
    }
   
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("token recieved \(deviceToken.description)")
        
        print(deviceToken.base64EncodedString())
        //Save the device token in Parse
       
        
        //Get the device token
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        print("Registered with device token: \(token)")
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(token , forKey: "tokenData")
        userDefaults.synchronize()
        
         self.setDeviceToken()
        
    }
    
    
    func setDeviceToken(){
        let onboarding = setting.integer(forKey: "onboarding")
        if onboarding == 2 {
        
        WebService().setPushToken()
        }
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("RECIEVE PUSH\(userInfo)")
        
        completionHandler(.newData)
    }

    func creatGradientImage(layer:CALayer) -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(layer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    func getDateFromTimestamp(timeStamp:NSNumber) -> String{
        let timeinterval : TimeInterval = timeStamp.doubleValue / 1000 // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let dateFormatter = DateFormatter()
        //.dateFormat = "h:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.string(from: dateFromServer as Date).capitalized
        
        let dateobj = dateFormatter.date(from: date)
        
        
        dateFormatter.dateFormat = "dd MMM, hh:mm"
        //        dateFormatter.timeStyle = .short
        date = dateFormatter.string(from: dateFromServer as Date).capitalized
        if NSCalendar.current.isDateInToday(dateobj!) == true {
            date = "TODAY \(date)"
        }else if NSCalendar.current.isDateInTomorrow(dateobj!) == true {
            date = "TOMORROW \(date)"
        }
        return date
    }
    
    func fetchReminder(reminderID: NSNumber, title: String) {
        
        var mutatedTitle = title
        
        WebService().acceptReminderInvite(reminderId: String(describing: reminderID as NSNumber)) { (responseDict) in
            print(responseDict)
            
            if responseDict["Error"] as? Bool == true {
                
            }
            else {
                let reminderDict = responseDict["data"] as! [String: Any]
                
                if let reminderTime = reminderDict["reminderTime"] as? NSNumber {
                    let reminderTimString = self.getDateFromTimestamp(timeStamp: reminderTime)
                    mutatedTitle.append(" at " + reminderTimString)
                }

                if let location = reminderDict["location"] as? String {
                    mutatedTitle.append(" in " + location)
                }
                
                self.showReminderInvite(forTitle: mutatedTitle, reminderID: reminderID)
            }
        }
    }
    
    func showReminderInvite(forTitle: String, reminderID: NSNumber) {
        let alertController = UIAlertController(title: "Reminder Invitation", message: forTitle, preferredStyle: UIAlertControllerStyle.alert)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (UIAlertAction) in
            
            if let cenesTabBarViewControllers = self.cenesTabBar?.viewControllers {
                self.cenesTabBar?.selectedIndex = 1
                
                let reminder = (cenesTabBarViewControllers[1] as? UINavigationController)?.viewControllers.first as? RemindersViewController
                
                (cenesTabBarViewControllers[1] as? UINavigationController)?.viewControllers = [reminder!]
                
                reminder?.acceptOrDeclineInvitation(forReminder: reminderID, status: "Accept")
            }
        }
        
        let declineAction = UIAlertAction(title: "Reject", style: .default) {(UIAlertAction) in
            
            if let cenesTabBarViewControllers = self.cenesTabBar?.viewControllers {
                self.cenesTabBar?.selectedIndex = 1
                
                let reminder = (cenesTabBarViewControllers[1] as? UINavigationController)?.viewControllers.first as? RemindersViewController
                
                (cenesTabBarViewControllers[1] as? UINavigationController)?.viewControllers = [reminder!]
                
                reminder?.acceptOrDeclineInvitation(forReminder: reminderID, status: "Declined")
            }
        }
        
        let ignoreAction = UIAlertAction(title: "Ignore", style: .default) { (UIAlertAction) in
            
//            if let cenesTabBarViewControllers = self.cenesTabBar?.viewControllers {
//                self.cenesTabBar?.selectedIndex = 1
//
//                let reminder = (cenesTabBarViewControllers[1] as? UINavigationController)?.viewControllers.first as? RemindersViewController
//
//                (cenesTabBarViewControllers[1] as? UINavigationController)?.viewControllers = [reminder!]
//
//                reminder?.acceptOrDeclineInvitation(forReminder: reminderID, status: "")
//            }
        }
        
        alertController.view.tintColor = UIColor(red:0.98, green:0.6, blue:0.17, alpha:1)
        alertController.addAction(declineAction)
        alertController.addAction(acceptAction)
        alertController.addAction(ignoreAction)
        
        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //Delivers a notification to an app running in the foreground. UNNotificationPresentationOptions is the Badge, Sound or Alert. notification is the notification that was delivered.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        self.cenesTabBar?.setTabBarDotVisible(visible: true);
        print(notification.request.content.userInfo)
        NSLog("%@",notification)
        
        let userInfo = notification.request.content.userInfo["aps"]! as? NSDictionary
        let alertDict = userInfo!["alert"] as! NSDictionary
            
        if alertDict["type"] as? String == "HomeRefresh" {
                if let cenesTabBarViewControllers = cenesTabBar?.viewControllers {
                    self.cenesTabBar?.selectedIndex = 0
                    
                    let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                    homeViewController?.refreshHomeScreenData();
                }
            } else {
                completionHandler([.alert, .sound])
            }
        
    }
    
    
    //  When the user responds to a notification, the system calls this method with the results. You use this method to perform the task associated with that action, if at all.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print(response.notification.request.content.userInfo)
        if response.notification.request.content.userInfo.count == 0 {
            return
        }
        
        let userInfo = response.notification.request.content.userInfo["aps"]! as? NSDictionary
        
        if userInfo!["type"] as? String == "HomeRefresh" {

            if let cenesTabBarViewControllers = cenesTabBar?.viewControllers {
                self.cenesTabBar?.selectedIndex = 0
                
                let homeViewController = (cenesTabBarViewControllers[0] as? UINavigationController)?.viewControllers.first as? NewHomeViewController
                homeViewController?.refreshHomeScreenData();
            }
        } else if userInfo!["type"] as? String == "Gathering" {
            
            
            
            if let cenesTabBarViewControllers = cenesTabBar?.viewControllers {
                self.cenesTabBar?.selectedIndex = 0
                
                let notificationViewController = (cenesTabBarViewControllers[2] as? UINavigationController)?.viewControllers.first as? NotificationViewController
                notificationViewController?.initilize();
                
                /*let gathering = (cenesTabBarViewControllers[2] as? UINavigationController)?.viewControllers.first as? GatheringViewController
                
                if SideMenuManager.default.menuLeftNavigationController?.isNavigationBarHidden == true{
//                if SideMenuManager.menuLeftNavigationController.isHidden == true{
                
                gathering?.dismiss(animated: false, completion: nil)
                }else{
                    
                    let side = SideMenuManager.default.menuLeftNavigationController?.viewControllers.first as! SideMenuViewController
                   side.dismiss(animated: true, completion: nil)
                }
                (cenesTabBarViewControllers[2] as? UINavigationController)?.viewControllers = [gathering!]
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                gathering?.isNewInvite = true
                
                let eventId = "\((userInfo!["id"] as? NSNumber)!)"
                let invitationData = CenesCalendarData()
                    invitationData.eventId = eventId
                gathering?.invitationData = invitationData
                //gathering?.setInvitation()
                }*/
            }
        }
        
        if userInfo!["type"] as? String == "Reminder" {
//            print(userInfo)
            
            let alertDict = userInfo?.object(forKey: "alert") as? NSDictionary
            var invitationTitle = alertDict?.object(forKey: "title") as? String
            if SideMenuManager.default.menuLeftNavigationController?.isNavigationBarHidden == false{

//            if SideMenuManager.menuLeftNavigationController.isHidden == false{
                
                let side = SideMenuManager.default.menuLeftNavigationController?.viewControllers.first as! SideMenuViewController
                side.dismiss(animated: true, completion: nil)
            }
            
            self.fetchReminder(reminderID: (userInfo!["id"] as? NSNumber)!, title: invitationTitle!)
            
//            self.showReminderInvite(forTitle: invitationTitle!, reminderID: (userInfo!["notificationTypeId"] as? NSNumber)!)
            
            
            
//            if let cenesTabBarViewControllers = cenesTabBar?.viewControllers {
//                self.cenesTabBar?.selectedIndex = 1
//
//                let reminder = (cenesTabBarViewControllers[1] as? UINavigationController)?.viewControllers.first as? RemindersViewController
//
//                (cenesTabBarViewControllers[1] as? UINavigationController)?.viewControllers = [reminder!]
//
//                reminder?.acceptInvitation(forReminder: (userInfo!["notificationTypeId"] as? NSNumber)!)
//            }
        }
        //At the end of your implementation, you must call the completionHandler block to let the system know that you are done processing the notification
        completionHandler()
        
    }
    
}
