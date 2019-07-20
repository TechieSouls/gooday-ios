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

        return user;
    }
    
    
    func loadUserDataFromUserDefaults(userDataDict: UserDefaults) -> User {
        
        let user = User();
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
        
        //user.token = "1562804566222eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjMTU2MjcxODE2NjIyMiJ9.ul5VtnES-lf4JGpiejRziA-YM3Jj2sJV-y8ONcaARGIlNRvH4nVcCKbIpOybP29d0pBgU6azXUHInGIL0ntq9w"
        //user.userId = 388;
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
