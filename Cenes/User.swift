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
    var photo: String!;
    var gender: String!;
    var phone: String!;
    var country: String!;
    var birthDay: Int64!;
    var token: String!;
    
    func loadUserData(userDataDict: NSDictionary) -> User {
        
        let user = User();
        user.userId = userDataDict.value(forKey: "userId") as? Int32;
        user.name = userDataDict.value(forKey: "name") as? String;
        user.email = userDataDict.value(forKey: "email") as? String;
        user.photo = userDataDict.value(forKey: "photo") as? String;
        user.gender = userDataDict.value(forKey: "gender") as? String;
        user.phone = userDataDict.value(forKey: "phone") as? String;
        user.country = userDataDict.value(forKey: "country") as? String;
        user.birthDay = userDataDict.value(forKey: "birthDay") as? Int64;
        
        return user;
    }
    
    
    func loadUserDataFromUserDefaults(userDataDict: UserDefaults) -> User {
        
        let user = User();
        user.userId = userDataDict.value(forKey: "userId") as? Int32;
        user.name = userDataDict.value(forKey: "name") as? String;
        user.email = userDataDict.value(forKey: "email") as? String;
        user.photo = userDataDict.value(forKey: "photo") as? String;
        user.gender = userDataDict.value(forKey: "gender") as? String;
        user.phone = userDataDict.value(forKey: "phone") as? String;
        user.country = userDataDict.value(forKey: "country") as? String;
        user.birthDay = userDataDict.value(forKey: "birthDay") as? Int64;
        user.token = userDataDict.value(forKey: "token") as? String;
        
        return user;
    }
    
}
