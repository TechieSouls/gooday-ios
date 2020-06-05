//
//  User.swift
//  Deploy
//
//  Created by Cenes_Dev on 27/02/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
class User {
    
    var userId: Int32!;
    var name: String!
    var email: String!;
    var password: String!;
    var photo: String!;
    var gender: String!;
    var phone: String!;
    var country: String!;
    var birthDay: Int64!;
    var birthDayStr: String!;
    var token: String!;
    
    func loadUserData(userDataDict: NSDictionary) -> User {
        
        let user = User();
        user.userId = userDataDict.value(forKey: "userId") as? Int32;
        user.name = userDataDict.value(forKey: "name") as? String;
        user.password = userDataDict.value(forKey: "password") as? String;
        user.email = userDataDict.value(forKey: "email") as? String;
        user.photo = userDataDict.value(forKey: "photo") as? String;
        user.gender = userDataDict.value(forKey: "gender") as? String;
        user.phone = userDataDict.value(forKey: "phone") as? String;
        user.country = userDataDict.value(forKey: "country") as? String;
        user.birthDay = userDataDict.value(forKey: "birthDay") as? Int64;
        user.birthDayStr = userDataDict.value(forKey: "birthDayStr") as? String;
        user.token = userDataDict.value(forKey: "token") as? String;

        return user;
    }
    
    
    func loadUserDataFromUserDefaults(userDataDict: UserDefaults) -> User {
        
        let user = User();
        
        if (userDataDict != nil && userDataDict.value(forKey: "userId") != nil) {
            user.userId = userDataDict.value(forKey: "userId") as? Int32;
            user.name = userDataDict.value(forKey: "name") as? String;
            user.email = userDataDict.value(forKey: "email") as? String;
            user.photo = userDataDict.value(forKey: "photo") as? String;
            user.password = userDataDict.value(forKey: "password") as? String;
            user.gender = userDataDict.value(forKey: "gender") as? String;
            user.phone = userDataDict.value(forKey: "phone") as? String;
            user.country = userDataDict.value(forKey: "country") as? String;
            user.birthDay = userDataDict.value(forKey: "birthDay") as? Int64;
            user.token = userDataDict.value(forKey: "token") as? String;
            user.birthDayStr = userDataDict.value(forKey: "birthDayStr") as? String;
        }
        
        //user.token = "1572598392173eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjcmVlZDEzMzcxNTcyNTExOTkyMTczIn0.UXV_9a5S3lisJYv76k4rFLxY6awm2zWE98Xkjg0OL4CYN3wgChLUlxTwY_J0_6FQ2R8t4V4L80H9J82xXXn4tQ"
        //user.userId = 642;
        //user.userId = 812; //Neha
        //user.userId = 846; //Creed
        //user.userId = 616 //Louisa
        //user.userId = 45 //Sharon Shun
        //user.userId = 847;
        //user.phone = "";

        return user;
    }
    
    func updateUserValuesInUserDefaults(user: User) {
        
        if (user.name != nil) {
            setting.setValue(user.name, forKeyPath: "name")
        }
        
        if (user.gender != nil) {
            setting.setValue(user.gender, forKeyPath: "gender")
        }
        
        if (user.birthDayStr != nil) {
            setting.setValue(user.birthDayStr, forKeyPath: "birthDayStr")
        }
        
        if (user.password != nil) {
            setting.setValue(user.password, forKeyPath: "password")
        }
        
        if (user.photo != nil) {
            setting.setValue(user.photo, forKeyPath: "photo")
        }
    }
    
}
