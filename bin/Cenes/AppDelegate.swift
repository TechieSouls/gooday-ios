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

let setting = UserDefaults.standard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
        UINavigationBar.appearance().tintColor = commonColor
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Override point for customization after application launch.
        let onboarding = setting.integer(forKey: "onboarding")
        if onboarding == 2{
            window?.rootViewController = HomeViewController.MainViewController()
        }
        else if onboarding == 1{
            window?.rootViewController = LoginViewController.MainViewController()
           
        }else{
             window?.rootViewController = OnBoardingController.onboardingViewController()
        }
        
        
        
        //User Notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound,.badge]) {(accepted, error) in
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
        
       //
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
           }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Cenes")
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
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //Delivers a notification to an app running in the foreground. UNNotificationPresentationOptions is the Badge, Sound or Alert. notification is the notification that was delivered.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        completionHandler([.alert, .sound])
        
    }
    
    
    //  When the user responds to a notification, the system calls this method with the results. You use this method to perform the task associated with that action, if at all.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
       print("do something on it")
        
        
        //At the end of your implementation, you must call the completionHandler block to let the system know that you are done processing the notification
        completionHandler()
        
    }
    
}
