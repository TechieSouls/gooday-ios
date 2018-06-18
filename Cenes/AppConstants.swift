//
//  AppConstants.swift
//  Cenes
//
//  Created by Sabita Rani Samal on 7/13/17.
//  Copyright © 2017 Sabita Rani Samal. All rights reserved.
//

import UIKit


// Image names, Notification names , Strings, Colors
let pageTitles = ["Welcome to CENES\nYour personal in-synced\n calendar","Time prediction\nwith no conflicts",
                  "Private Diary\nrecord your memories"]
var images = ["Group 3","onboarding1","onboarding2"]

let pageDescs = ["Empower self-awareness and\ncustomize all type of schedules.",
                 "Easily manage your events, tasks, and\nreminders at one place."
    , "Mark every milestone on your job and every gathering with friends."]

let DATA_TYPE_CAL_REM = "Reminder"
let DATA_TYPE_CAL_NOR = "Normal"
let BOTTOM_BEFORE_KEYBOARD = 200
let BOTTOM_AFTER_KEYBOARD = 0

let commonColor = UIColor(red: 240/255, green: 120/255, blue: 81/255, alpha: 1)

let cenesDelegate = UIApplication.shared.delegate as! AppDelegate
let loadinIndicatorSize = CGSize(width: 30, height: 30)
