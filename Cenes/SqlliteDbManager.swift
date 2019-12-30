//
//  SqlliteDbManager.swift
//  Cenes
//
//  Created by Cenes_Dev on 22/11/2019.
//  Copyright © 2019 Cenes Pvt Ltd. All rights reserved.
//

import Foundation
import SQLite

class SqlliteDbManager {
    
    var database: Connection!;
    init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
            ).first!
            database = try Connection("\(path)/db.sqlite3");
            print(database)
        } catch {
            print(error)
        }
    }
}
