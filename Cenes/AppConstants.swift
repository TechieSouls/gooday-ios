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

/////// COLORS
let commonColor = UIColor(red: 240/255, green: 120/255, blue: 81/255, alpha: 1)

let themeColor = UIColor(red: 249/255 , green: 249/255, blue: 249/255, alpha: 1)

let selectedColor = UIColor(red:0.93, green:0.61, blue:0.15, alpha:1)

let cenesLabelBlue = UIColor(red:0.29, green:0.56, blue:0.89, alpha:1)

let unselectedColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1);

//////// IMages
let defaultProfileImage = "profile_icon.png";


let cenesDelegate = UIApplication.shared.delegate as! AppDelegate
let loadinIndicatorSize = CGSize(width: 30, height: 30)

let cgRectSizeLoading = CGRect(x: 0, y: 0, width: 30, height: 30)

let onboardingStep2Title = "GATHERING";
let onboardingStep3Title = "COLLABORATIVE\nREMINDERS";
let onboardingStep4Title = "MeTIME";
let onboardingStep5Title = "MAKE LIFE EASIER TO SOCIALIZE";


let onboardingStep2Desc = "Making plans can't get any easier. A tap on your phone will find the best time for everyone to meet.\n\n\nNo more back and forth messaging. No more time wasting. Keep it simple.";
let onboardingStep3Desc = "Collaborative Reminders is not just for yourself. Share it with others and track its progress.\n\n\nWe're making productivity a little more social.";
let onboardingStep4Desc = "Finding time is difficult. We get it. MeTIME provides acustomizable schedule to set aside some much deserved time to yourself.\n\n\nIf something is worth doing, we'll make the time for it.";
let onboardingStep5Desc = "";

let inviteFriendInvitationSms = "Check out Cenes for your smartphone. Download it today from http://www.cenesgroup.com";


//THIRD PARTY TOKENS
let instabugToken = "d81ee39bd8a6ea5c21f101ae80daef5a";

//SETTINGS SCREEN
let aboutUsVersionUpdateLink = "https://cenesgroup.com";
let cenesWebUrl = "https://betaweb.cenesgroup.com";
let shareLinkText = " \"[Host]\" invites you to \"[Title]\". RSVP through the Cenes app. Link below: ";
let shareEventUrl = "https://betaweb.cenesgroup.com/event/invitation/"
let faqLink = "https://www.cenesgroup.com/faq";
let privacyPolicyLink = "https://www.cenesgroup.com/app/privacyPolicy";
let termsandconditionsLink = "https://www.cenesgroup.com/legal/terms-and-conditions";
