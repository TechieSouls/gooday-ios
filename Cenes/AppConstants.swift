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

let themeColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)

let selectedColor = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1)

let cenesLabelBlue = UIColor(red: 59/255, green: 76/255, blue: 139/255, alpha: 1);

let cenesDelegate = UIApplication.shared.delegate as! AppDelegate
let loadinIndicatorSize = CGSize(width: 30, height: 30)


let onboardingStep2Title = "GATHERING";
let onboardingStep3Title = "COLLABORATIVE\nREMINDERS";
let onboardingStep4Title = "MeTIME";
let onboardingStep5Title = "MAKE LIFE EASIER TO SOCIALIZE";


let onboardingStep2Desc = "Making plans can't get any easier. A tap on your phone will find the best time for everyone to meet.\n\n\nNo more back and forth messaging. No more time wasting. Keep it simple.";
let onboardingStep3Desc = "Collaborative Reminders is not just for yourself. Share it with others and track its progress.\n\n\nWe're making productivity a little more social.";
let onboardingStep4Desc = "Finding time is difficult. We get it. MeTIME provides acustomizable schedule to set aside some much deserved time to yourself.\n\n\nIf something is worth doing, we'll make the time for it.";
let onboardingStep5Desc = "";

let inviteFriendInvitationSms = "Check out Cenes for your smartphone. Download it today from http://www.cenesgroup.com";

//SETTINGS SCREEN
let aboutUsVersionUpdateLink = "http://www.cenesgroup.com";
let cenesWebUrl = "http://cenes-web.com.s3-website-us-east-1.amazonaws.com";
