//
//  SqlliteDbManager+CenesUser.swift
//  Cenes
//
//  Created by Cenes_Dev on 22/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

extension SqlliteDbManager {
    
    func createTableCenesUser() {
        
        do {
            let cenesUsers = Table("cenes_users")
            let userId = Expression<Int64>("user_id")
            let title = Expression<String?>("name")
            let photo = Expression<String>("photo")
            let phone = Expression<String>("phone")

            try database.run(cenesUsers.create { t in
                t.column(userId, defaultValue: 0)
                t.column(title)
                t.column(photo, defaultValue: "")
                t.column(phone, defaultValue: "")
            })
            // CREATE TABLE "users" (
            //     "id" INTEGER PRIMARY KEY NOT NULL,
            //     "name" TEXT,
            //     "email" TEXT NOT NULL UNIQUE
            // )
        } catch {
            print("Create Event Table Error", error)
        }
    }
    
    func saveCenesUser(cenesUser: User) {
        
        let cenesUserDb = findCenesUserByUserId(userId: cenesUser.userId);
        if (cenesUserDb.userId == nil) {
            do {
                let stmt = try database.prepare("INSERT into cenes_users (user_id, name, photo, phone) VALUES (?, ?, ?, ?)");
                
                var name = "";
                if (cenesUser.name != nil) {
                    name = cenesUser.name;
                }
                var photo = "";
                if (cenesUser.photo != nil) {
                    photo = cenesUser.photo;
                }
                var phone = "";
                if (cenesUser.phone != nil) {
                    phone = cenesUser.phone;
                }
                try stmt.run(Int64(cenesUser.userId), name, photo, phone);
                
            } catch {
                print("Error in saveCenesUser : ", error)
            }
        } else {
            updateCenesUserByUserId(cenesUser: cenesUser);
        }
    }
    
    func updateCenesUserByUserId(cenesUser: User) {
        
        do {
            let stmt = try database.prepare("UPDATE cenes_users set name = ?, photo = ?, phone = ? where user_id =  ?");
            var name = "";
           if (cenesUser.name != nil) {
               name = cenesUser.name;
           }
           var photo = "";
           if (cenesUser.photo != nil) {
               photo = cenesUser.photo;
           }
           var phone = "";
           if (cenesUser.phone != nil) {
               phone = cenesUser.phone;
           }
           try stmt.run(name, photo, phone,Int64(cenesUser.userId));
            
        } catch {
            print("Error in updateCenesUserByUserId : ", error);
        }
    }
    
    func findCenesUserByUserId(userId: Int32) -> User {
        
        let cenesUser = User();

        do {
            let stmt = try database.prepare("SELECT * from cenes_users where user_id = ?");
            for cenesUserDb in try stmt.run(Int64(userId)) {
                    
                cenesUser.userId = Int32(cenesUserDb[0] as! Int64);
                cenesUser.name = cenesUserDb[1] as? String;
                cenesUser.photo = cenesUserDb[2] as? String;
                cenesUser.phone = cenesUserDb[3] as? String;
                
            }
        } catch {
            print("Error in saveCenesUser : ", error)
        }
        return cenesUser;
    }
    
    func deleteCenesUserByUserId(userId: Int32) {
        do {
            let stmt = try database.prepare("DELETE from cenes_users where user_id = ?");
            try stmt.run(Int64(userId));
        } catch {
            print("Error in saveCenesUser : ", error)
        }
    }
    
    func deleteAllCenesUser() {
        do {
            let stmt = try database.prepare("DELETE from cenes_users");
            try stmt.run();
        } catch {
            print("Error in deleteAllCenesUser : ", error)
        }
    }

}
