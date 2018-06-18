//
//  BaseViewController.swift
//  Cenes
//
//  Created by Ashutosh Tiwari on 8/25/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit
import ActionButton
import IoniconsSwift

class BaseViewController: UIViewController {
    
    var actionButton : ActionButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let gathering = ActionButtonItem(title: "Gathering", image: Ionicons.iosCalendarOutline.image(25))
//        gathering.action = { item in print("Sharing...") }
//        
//        let reminder = ActionButtonItem(title: "Reminder", image: Ionicons.iosBellOutline.image(25))
//        reminder.action = { item in print("Email...") }
//        
//        let alarm = ActionButtonItem(title: "Alarm", image: Ionicons.iosAlarmOutline.image(25))
//        alarm.action = { item in print("Alarm...") }
//        
//        actionButton = ActionButton(attachedToView: view, items: [gathering, reminder,alarm])
//        actionButton?.action = { button in button.toggleMenu() }
        

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
